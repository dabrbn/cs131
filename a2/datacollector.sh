#!/bin/bash

# save start dir, create temp dir to work in, and temp dir trap
start_dir=$(pwd)
tmp_dir=$(mktemp -d ./tmp.XXXXXX) || exit 1
trap 'rm -rf "$tmp_dir"' EXIT

# prompt user for url
read -rp "Enter URL to a CSV dataset: " url 
curled=$(basename "$url")

cd "$tmp_dir" || exit 1

# retrieve file from url
curl -s -L -o "$curled" "$url"

# unzip if .zip
# if unzip fails, exit
if [[ "$curled" =~ \.zip$ ]]; then
  echo "Unzipping $curled..."
  if ! unzip -q "$curled"; then
    echo "Failed to unzip. Aborting."
    exit 1
  fi
fi

# gather all csv files and put in array
csv_files=()
for csv_file in ./*.csv; do
  [[ -f "$csv_file" ]] && csv_files+=("$csv_file")
done

# exit if there are no csv files
if [[ ${#csv_files[@]} -eq 0 ]]; then
  echo "No CSV files found. Aborting."
  exit 1
fi

# print the number of csv files
echo "${#csv_files[@]} CSV file(s) found"

# function to process csv
process_csv() {
  local csv_file="$1"
  local summary_file="${csv_file%.*}_summary.md"

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
  
  
  cp "$summary_file" "$start_dir/$summary_file"
}

# process every csv file in the directory
for csv_file in *.csv; do 
  echo "Processing $csv_file..."
  process_csv "$csv_file"
done

echo "Summary report(s) generated and saved to $start_dir"

cd "$start_dir" || exit 1


















