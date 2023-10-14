import subprocess

def run_nmap(ip, options):
    command = f'nmap {ip} {options}'
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, text=True)
    return result.stdout

def main():
    ip_address = input("Enter the IP address to scan: ")

    # Initial, faster scan
    options = '-F'
    scan_result = run_nmap(ip_address, options)
    print(scan_result)

    # Ask user if they want to continue with a more detailed scan
    user_input = input("Do you want to continue with a more detailed scan? (y/n): ")
    if user_input.lower() != 'y':
        print("Exiting.")
        return

    # Progressively slower and more accurate scans
    options_list = [
        '-Pn',
        '-p 1-65535',
        '-sV -O',
        '-p 1-65535 -sV -A',
        '-p 1-65535 -sV -A -T4',
        '-p 1-65535 -sV -A -T4 -sS',
    ]

    for options in options_list:
        scan_result = run_nmap(ip_address, options)
        print(scan_result)

        # Ask user if they want to continue
        user_input = input("Do you want to continue with an even more detailed scan? (y/n): ")
        if user_input.lower() != 'y':
            print("Exiting.")
            break

if __name__ == "__main__":
    main()
