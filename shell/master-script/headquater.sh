#!/bin/bash

# Function to execute a shell script and wait for it to complete
execute_script() {
    script=$1
    echo "Executing $script..."
    ./$script
    wait $!
    echo "$script done."
}

# List of shell scripts to execute
scripts=("main-nmap-shell.sh" "os-creds.sh" "persistent-shell.sh")

# Loop through the list and execute each script
for script in "${scripts[@]}"; do
    execute_script "$script"
done

echo "All scripts executed."
