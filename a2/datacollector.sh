#!/bin/bash

# save start dir
# create and move to a temp dir to work in
# add temp dir trap
start_dir=$(pwd)
tmp_dir=$(mktemp -d ./tmp.XXXXXX) || exit 1
trap 'rm -rf "$tmp_dir"' EXIT
cd "$tmp_dir" || exit 1

# prompt for url if not passed 
if [[ $# -eq 1 ]]; then
  url="$1"
else
  read -rp "Enter URL to a CSV dataset: " url
fi

curled=$(basename "$url")

# retrieve file from url
# if curl fails, exit
if ! curl -s -L -o "$curled" "$url"; then
  echo "Failed to download from $url. Aborting."
  exit 1
fi

# unzip if .zip
# if unzip fails, exit
if [[ "$curled" =~ \.zip$ ]]; then
  echo "Unzipping $curled..."
  if ! unzip -q "$curled"; then
    echo "Failed to unzip. Aborting."
    exit 1
  fi
fi

# gather all csv files into an array
# checking subdirectories just in case cause of zip
csv_files=()
while IFS= read -r file; do
  csv_files+=("$file")
done < <(find . -type f -iname '*.csv')

# exit if there are no csv files
if [[ ${#csv_files[@]} -eq 0 ]]; then
  echo "No CSV files found. Aborting."
  exit 1
fi

# print the number of csv files
echo "Found ${#csv_files[@]} CSV file(s)"

# function to process csv
process_csv() {
  local csv_file="$1"
  local csv_name; csv_name="$(basename "${csv_file%.*}")"
  local summary_file="${csv_name}_summary.md"

  # this is to make sure i don't overwrite duplicate files (from subdirectories)
  local dupes=1
  while [[ -e "$start_dir/$summary_file" ]]; do
    summary_file="${csv_name}_summary_$dupes.md"
    ((dupes++))
  done

  # get first line, and remove quotations.
  local header; header=$(head -n 1 "$csv_file" | sed 's/"//g')

  # the winequality file is semi-colon separated
  # csv=comma-separated so i'm going to use conditional just to be safe
  local delimiter
  if [[ "$header" == *";"* ]]; then
    delimiter=";"
  else
    delimiter=","
  fi

  # split header into features array using detected delimiter
  IFS="$delimiter" read -ra features <<< "$header"

  # start generating summary report
  {
    echo "# Feature Summary for $csv_file"
    echo
    echo "## Feature Index and Names"

    local index
    for i in "${!features[@]}"; do
      index=$((i + 1))
      echo "$index. ${features[$i]}"
    done

    echo
    echo "## Statistics (Numerical Features)"
    echo "| Index | Feature | Min | Max | Mean | StdDev |"
    echo "|-------|---------|-----|-----|------|--------|"
  } >> "$summary_file"

  # calculate stats for each column, ignoring header line
  tail -n +2 "$csv_file" | awk -F"$delimiter" -v num_cols="${#features[@]}" '
    # function to check if is number
    function is_num(value) {
      return value ~ /^-?[0-9]+(\.[0-9]+)?$/
    }
    
    {
      # go through each row, and update sum, squared sum, count, min, and max
      for (i = 1; i <= num_cols; i++) {
        if (!ignore_col[i]) {
          if (is_num($i)) {
            sum[i] += $i
            squared_sum[i] += ($i)^2
            count[i]++
            if ((min[i] == "") || ($i < min[i])) min[i] = $i
            if ((max[i] == "") || ($i > max[i])) max[i] = $i
          } else {
            ignore_col[i] = 1
          }
        }
      }
    }

    END {
      # for each column calculate stats if it has numerical features
      for (i = 1; i <= num_cols; i++) {
        if (!ignore_col[i] && count[i] > 0) {
          mean = sum[i] / count[i]
          stddev = sqrt((squared_sum[i] / count[i]) - (mean)^2)
          printf "| %d | %s | %.2f | %.2f | %.3f | %.3f |\n", i, "'"${features[i-1]}"'", min[i], max[i], mean, stddev
        }
      }
    }
  ' >> "$summary_file"
  
  cp "$summary_file" "$start_dir/$summary_file"
}

# process every csv file in the directory
for csv_file in "${csv_files[@]}"; do 
  echo "Processing $csv_file..."
  process_csv "$csv_file"
done

echo "Summary report(s) saved to $start_dir"

cd "$start_dir" || exit 1
