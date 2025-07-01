#!/bin/bash

# save start dir, create temp dir to work in, and temp dir trap
start_dir=$(pwd)
tmp_dir=$(mktemp -d ./tmp.XXXXXX) || exit 1
#trap 'rm -rf "$tmp_dir"' EXIT

# prompt user for url
read -rp "Enter URL to a CSV dataset: " url 
curled=$(basename "$url")

cd "$tmp_dir" || exit 1

curl -s -L -o "$curled" "$url"

# unzip if .zip
if [[ "$curled" =~ \.zip$ ]]; then
  unzip -q "$curled"
fi

# exit if no csv files found
if [[ $(ls ./*.csv | grep -c '\.csv$') -eq 0 ]]; then
  exit 1
fi

# function to process csv
process_csv() {
  local csv_file="$1"
  local summary_file="${csv_file%.*}_summary.md"

  cat >> "$summary_file" <<EOF
# Feature Summary for $csv_file

EOF
  
  # get first line, and remove "
  header="$(head -n 1 "$csv_file" | sed 's/"//g')"

  # the wine file is semi-colon separated
  # csv is comma-separated so using conditional statement 
  if [[ "$header" == *";"* ]]; then
    delimiter=";"
  else
    delimiter=","
  fi

  # using delimiter split header and populate features array
  IFS="$delimiter" read -ra features <<< "$header"

  echo "## Feature Index and Names" >> "$summary_file"
  for i in "${!features[@]}"; do
    index=$((i + 1))
    echo "$index. ${features[$i]}" >> "$summary_file"
  done

  cat >> "$summary_file" <<EOF

## Statistics (Numerical Features)
| Index | Feature | Min | Max | Mean | StdDev |
|-------|---------|-----|-----|------|--------|
EOF

}

# process every csv file in the directory
for csv_file in *.csv; do 
  process_csv "$csv_file"
done

cd "$start_dir" || exit 1
