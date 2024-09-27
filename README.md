
# Installation Script for Development Tools for Consumer Core

This script automates the installation of various development tools and configurations on your machine, primarily for use in a development environment. It ensures that the necessary tools are installed, adds relevant aliases to your Zsh configuration, and logs all activities for future reference.

## Features
- Sets up Oh My Zsh!
- Installs the following tools:
    - Homebrew
    - Kubernetes tools (`kubectl`, `kns`)
    - Docker
    - AWS CLI (v2 or higher)
    - HashiCorp Vault
    - Terraform
    - Stern
    - Python and pip
    - Pre-commit
    - Kubernetes Lens
    - GitHub CLI
    - Additional utilities (`ggrep`, IntelliJ IDEA alias)
- Adds aliases to `.zshrc` for quick access to frequently used commands.
- Logs installation activities to a timestamped log file for review.

## Requirements

- **Zsh**: Ensure you have Zsh installed as the default shell.
- **Internet Access**: The script requires internet access to download packages.

## Usage

1. **Clone the Repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x consumer_core_prepare_machine.sh
   ```

3. **Run the Script**:
   ```bash
   ./consumer_core_prepare_machine.sh
   ```

4. **Review the Log File**:
   After execution, a log file will be created in your home directory with the format `consumer_core_prepare_machine_YYYYMMDD_HHMMSS.log`. You can review this file for details about the installation process.


- A function for creating GitHub pull requests is also added to `.zshrc`.

## Dogfooding and Contributions

This script is currently in a dogfooding phase. While it covers many essential tools and configurations, it is not exhaustive. Contributions to improve this script are welcome! Feel free to open issues or submit pull requests to enhance its functionality.
The following set is up for contribution: 
1. Ahoy
2. Jetstream


## Troubleshooting

- If you encounter issues with the installation, please check the generated log file for specific error messages.
- Ensure you have the necessary permissions to install software on your machine.

## License

This script is provided as-is. Use it at your own risk.
