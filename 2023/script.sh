#!/bin/bash

# Set the base path as the current working directory
base_path="$(pwd)/"

# Define the output file
output="imageURLs.txt"

# Empty the output file in case it already exists
> $output

# Function to create URLs from file paths
function create_urls() {
    local month=$1
    echo "const images$month = [" >> $output
    while read -r line; do
        # Extracting only the needed part of the path and filename
        local relativePath=$(echo $line | sed "s|$base_path||")
        # Assuming GitHub raw URL format and structure based on the given tree
        local rawurl="https://github.com/amantham20/imagepush/blob/master/2023/${relativePath}?raw=true"
        echo "    \"$rawurl\"," >> $output
    done < <(find $base_path$month -type f)
    echo "]" >> $output
    echo >> $output # Newline for neatness
}

# Loop through each subdirectory in the base path
for dir in $base_path*/ ; do
    if [ -d "$dir" ]; then
        # Extract month name from the directory path
        month=$(basename $dir)
        # Create URLs for each month
        create_urls $month
    fi
done

echo "Output created at $output"

