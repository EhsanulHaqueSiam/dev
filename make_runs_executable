#!/bin/bash

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Change to the script directory
cd "$script_dir"

# Find all files in ./runs that are not executable and make them executable
find ./runs -maxdepth 1 -mindepth 1 -type f ! -executable -exec chmod +x {} \;

echo "All files in ./runs are now executable!"
