#!/bin/bash

echo -n "Please type a file name."
read FILE

if [ -d  $FILE ]; then
	echo "$FILE is a directory"
elif [ -f  "$FILE" ]; then
	echo "$FILE is a file" 
else
	echo "$FILE does not exist"
fi
