#!/bin/bash

run_nmap() {
    local ip=$1
    local options=$2
    local command="nmap $ip $options"
    local result
    result=$(eval "$command")
    echo "$result"
}

main() {
    read -p "Enter the IP address to scan: " ip_address

    # Initial, faster scan
    options="-F"
    scan_result=$(run_nmap "$ip_address" "$options")
    echo "$scan_result"

    # Ask user if they want to continue with a more detailed scan
    read -p "Do you want to continue with a more detailed scan? (y/n): " user_input
    if [ "${user_input,,}" != 'y' ]; then
        echo "Exiting."
        exit 0
    fi

    # Progressively slower and more accurate scans
    options_list=(
        '-Pn'
        '-p 1-65535'
        '-sV -O'
        '-p 1-65535 -sV -A'
        '-p 1-65535 -sV -A -T4'
        '-p 1-65535 -sV -A -T4 -sS'
    )

    for options in "${options_list[@]}"; do
        scan_result=$(run_nmap "$ip_address" "$options")
        echo "$scan_result"

        # Ask user if they want to continue
        read -p "Do you want to continue with an even more detailed scan? (y/n): " user_input
        if [ "${user_input,,}" != 'y' ]; then
            echo "Exiting."
            break
        fi
    done
}

main
l