#!/bin/bash

echo "the number of params is $#"

count=1

while [[ $# -gt 0 ]]; do
	echo "\$$count is $1"
	shift
	count=$(($count + 1))
done
