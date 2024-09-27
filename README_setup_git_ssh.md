# setup_ssh_git.sh

## Overview
This script sets up SSH for Git by generating an SSH key pair, adding the key to the SSH agent, and displaying the public key for you to add to your Git hosting service (e.g., GitHub, GitLab, Bitbucket). It also prompts you to clone a repository using SSH.

## Prerequisites
- Ensure you have Git installed on your machine (set up by consumer_core_prepare_machine.sh).
- Make sure you have a terminal that supports Bash.

## Usage
To use this script, follow these steps:

1. **Download the script**:
   Save the script as `setup_ssh_git.sh` on your local machine.

2. **Make the script executable**:
   Run the following command in your terminal:
   ```bash
   chmod +x setup_ssh_git.sh
