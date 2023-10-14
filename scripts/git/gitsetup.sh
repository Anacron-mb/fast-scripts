#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
    read -p "Git is not installed. Do you want to install it? (y/n): " install_git
    if [ "$install_git" == "y" ]; then
        # Install Git using apt
        sudo apt update
        sudo apt install git
        echo "Git has been installed."
    else
        echo "Git is required for this script. Exiting."
        exit 1
    fi
fi

# Check if Git is already configured
if git config --global --get user.name &> /dev/null && git config --global --get user.email &> /dev/null; then
    read -p "Git is already configured. Do you want to reconfigure? (y/n): " reconfigure_git
    if [ "$reconfigure_git" != "y" ]; then
        echo "Exiting."
        exit 0
    fi
fi

read -p "Enter your GitHub username: " github_username
read -p "Enter your GitHub email: " github_email

# Set Git username and email
git config --global user.name "$github_username"
git config --global user.email "$github_email"

read -p "Do you want to set up an SSH key for GitHub? (y/n): " generate_ssh

if [ "$generate_ssh" == "y" ]; then
    # Generate SSH key
    ssh-keygen -t rsa -b 4096 -C "$github_email"

    # Add SSH key to SSH agent
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

    # Display the SSH key for the user to copy
    echo "Your SSH key is:"
    cat ~/.ssh/id_rsa.pub

    read -p "Copy the above SSH key to your clipboard and press Enter when done."

    # Test SSH connection
    ssh -T git@github.com

    echo "SSH key has been added to GitHub. You can now use SSH for authentication."
else
    echo "Git is configured with your username and email. You can use HTTPS for authentication."
fi

echo "Git setup for GitHub is complete."
