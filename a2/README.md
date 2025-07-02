# a2: datacollector.sh

## What this command does

The `datacollector.sh` script does the following:
- Downloads a tabular dataset (CSV or ZIP containing CSVs) from the URL provided
- Unzips the file if necessary
- Parses each CSV file and identifies numerical columns
- Generates summary reports for each CSV file

## How to use this command

There are two ways to use the script.

```bash
# Run the script as is, and then enter the URL when prompted
(bash) → ./datacollector.sh
Enter URL to a CSV dataset: # provide URL

# Provide URL when running the script
(bash) → ./datacollector.sh <url>
```

## Demo

```bash
(bash) → ./datacollector.sh
Enter URL to a CSV dataset: https://archive.ics.uci.edu/static/public/186/wine+quality.zip
Unzipping wine+quality.zip...
Found 2 CSV file(s)
Processing ./winequality-red.csv...
Processing ./winequality-white.csv...
Summary report(s) saved to /Users/aeknadmal/ws_sjsu/ws_cs131/a2
```
``` 
(bash) → ls
README.md
datacollector.sh
winequality-red_summary.md
winequality-white_summary.md   
```

## Notes

- The script will append a suffix to the markdown summary if a file of that name already exists.
- The script works in a temporary directory that is deleted on exit.
- Exits with status code 1 if anything funny happens.

## Resources

- Prof's lecture slides
- https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
- https://www.baeldung.com/linux/awk-split-parameter-by-character

