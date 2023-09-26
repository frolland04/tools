#!/bin/bash

# Check if folder is provided
if [[ $# -ne 1 ]] || [[ ! -d "$1" ]]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

FOLDER="$1"
declare -A unique_paths

# Use 'find' to get all executable files in the folder
while IFS= read -r -d $'\0' file; do

    echo "******** Processing $file"

    # Run 'ldd' on the current file, extract shared object paths
    # and add them to the associative array.
    while IFS= read -r line; do

        # Extract paths from ldd output using awk
        path=$(echo "$line" | awk -F' => ' '{print $2}' | awk '{print $1}')

        if [[ -n "$path" && ! -e "${unique_paths[$path]}" ]] ; then
            unique_paths["$path"]=1
        fi

    done < <(ldd "$file")

done < <(find "$FOLDER" -type f -executable -print0)

# Print unique paths
for path in "${!unique_paths[@]}"; do
    echo "$path"
done

