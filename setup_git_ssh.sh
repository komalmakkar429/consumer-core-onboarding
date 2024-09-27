#!/bin/bash

# Check if an email address is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <your_email@example.com>"
    exit 1
fi

# Function to check for existing SSH key
check_ssh_key() {
    if [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
        echo "SSH key already exists. Proceeding to add to SSH agent..."
    else
        echo "No SSH key found. Generating a new SSH key..."
        ssh-keygen -t rsa -b 4096 -C "$1" -N "" -f "$HOME/.ssh/id_rsa"
    fi
}

# Function to start the SSH agent and add the SSH key
add_ssh_key_to_agent() {
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_rsa"
}

# Function to display the public key
display_public_key() {
    echo "Your SSH public key is:"
    cat "$HOME/.ssh/id_rsa.pub"
    echo "Copy this key and add it to your Git hosting service."
}


# Main script execution
check_ssh_key "$1"
add_ssh_key_to_agent
display_public_key

