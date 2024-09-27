
#!/bin/zsh

# Log file path
LOG_FILE="$HOME/consumer_core_prepare_machine_$(date +'%Y%m%d_%H%M%S').log"

# Function to log messages with timestamps
log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Initialize arrays for tracking installation statuses
installed=()
already_installed=()
failed=()

# List all the tools to be installed
log_message "The following installations will be performed:"
log_message "1. Oh My Zsh"
log_message "2. Homebrew"
log_message "3. kubectl"
log_message "4. git"
log_message "5. kubelogin"
log_message "6. Docker"
log_message "7. AWS CLI (v2 or higher)"
log_message "8. kubeconfig"
log_message "9. Vault"
log_message "10. kns (Kubernetes Namespace Switcher)"
log_message "11. Terraform"
log_message "12. Stern"
log_message "13. pip (via Homebrew Python)"
log_message "14. pre-commit (via pip)"
log_message "15. Kubernetes Lens"
log_message "16. ggrep"
log_message "17. GitHub CLI (gh) + PR function"
log_message "18. Set up alias (idea)"
log_message "-----------------------------------------------"

# Function to handle success and failure tracking
handle_status() {
  if [ $? -eq 0 ]; then
    installed+=("$1")
  else
    failed+=("$1")
  fi
}

# Function to install packages
install_package() {
  package_name=$1
  install_command=$2
  if ! command -v $package_name &> /dev/null; then
    log_message "Installing $package_name..."
    eval $install_command
    handle_status "$package_name"
  else
    log_message "$package_name is already installed."
    already_installed+=("$package_name")
  fi
}

# Function to write aliases to .zshrc
write_to_zshrc() {
  if ! grep -q "$1" ~/.zshrc; then
    log_message "Adding alias '$1' to your shell profile..."
    echo "$1" >> ~/.zshrc
    source ~/.zshrc
  fi
}

set_path_to_zshrc() {
    local path_to_add="$1"

    # Check if the path is already in ~/.zshrc
    if ! grep -q "export PATH=.*$path_to_add" "$HOME/.zshrc"; then
        echo "export PATH=\"$path_to_add:\$PATH\"" >> "$HOME/.zshrc"
        echo "Added $path_to_add to ~/.zshrc"
    else
        echo "$path_to_add is already in ~/.zshrc"
    fi
}

# Install Oh My Zsh first
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log_message "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  handle_status "Oh My Zsh"
else
  log_message "Oh My Zsh is already installed."
  already_installed+=("Oh My Zsh")
fi

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
  log_message "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  handle_status "Homebrew"
else
  log_message "Homebrew is already installed."
  already_installed+=("Homebrew")
fi

download_and_run_eksconfig() {
    file_url="https://raw.githubusercontent.com/hellofresh/hf-kubernetes/master/eks/eksconfig.sh"
    output_file="eksconfig.sh"
    curl -o "$output_file" "$file_url"
    chmod +x "$output_file"
    echo "Downloaded and added execute permissions to $output_file"
    ./"$output_file"
}




# Update Homebrew
log_message "Updating Homebrew..."
brew update

# Installing all packages
install_package "kubectl" "brew install kubectl"
install_package "kubelogin" "brew install Azure/kubelogin/kubelogin"
install_package "docker" "brew install --cask docker"
install_package "git" "brew install git"
install_package "aws" "brew install awscli"
install_package "vault" "brew install vault"
download_and_run_eksconfig
install_package "kns" "brew tap blendle/blendle && brew install kns"
install_package "terraform" "brew install terraform"
install_package "stern" "brew install stern"
install_package "ggrep" "brew install grep"
install_package "lens" "brew install --cask lens"
install_package "gh" "brew install gh && gh auth login"

# Install pip using Homebrew (Python includes pip)
if ! command -v pip3 &> /dev/null; then
  log_message "Installing Python and pip..."
  brew install python
  handle_status "pip (via Python)"
else
  log_message "pip is already installed."
  already_installed+=("pip")
fi

# Set the paths
set_path_to_zshrc "$HOME/bin"
set_path_to_zshrc "$HOME/.local/bin"
set_path_to_zshrc "/usr/local/bin"
set_path_to_zshrc "/opt/homebrew/bin"
set_path_to_zshrc "$HOME/.local/bin"
set_path_to_zshrc "/usr/local/aws-cli/v2/current/bin"

# Install pre-commit using pip
install_package "pre-commit" "pip3 install pre-commit"

# Add aliases to .zshrc
write_to_zshrc 'alias k=kubectl'
write_to_zshrc 'alias lens="open -a Lens"'
write_to_zshrc 'alias idea="open -na \"IntelliJ IDEA\" --args --project $(pwd)"'
write_to_zshrc 'alias ecr-login="aws ecr get-login-password --region eu-west-1 --profile sso-hf-it-developer | docker login --username AWS --password-stdin https://489198589229.dkr.ecr.eu-west-1.amazonaws.com"'
write_to_zshrc 'alias sso-eks-ahoy-basic="aws sso login --profile sso-eks-ahoy-basic"'
write_to_zshrc 'alias sso-eks-dwh-admin="aws sso login --profile sso-eks-dwh-admin"'
write_to_zshrc 'alias sso-eks-dwh-basic="aws sso login --profile sso-eks-dwh-basic"'
write_to_zshrc 'alias sso-eks-live-admin="aws sso login --profile sso-eks-live-admin"'
write_to_zshrc 'alias sso-eks-live-basic="aws sso login --profile sso-eks-live-basic"'
write_to_zshrc 'alias sso-eks-staging-admin="aws sso login --profile sso-eks-staging-admin"'
write_to_zshrc 'alias sso-eks-staging-basic="aws sso login --profile sso-eks-staging-basic"'
write_to_zshrc 'alias sso-eks-tools-admin="aws sso login --profile sso-eks-tools-admin"'
write_to_zshrc 'alias sso-hf-it-developer="aws sso login --profile sso-hf-it-developer"'

# Add PR function to .zshrc
if ! grep -q "function pr" ~/.zshrc; then
  log_message "Adding PR function to your shell profile..."
  cat <<'EOL' >> ~/.zshrc

# Plans script for creating PR
function pr(){
  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$branch" = "master" ]] || [[ "$branch" = "main" ]]; then
    return
  fi

  remotes=$(git remote -v show)
  if [[ ! "$remotes" =~ .*"github".* ]]; then
    return
  fi

  if [[ ! "$remotes" =~ .*"hellofresh".* ]]; then
    gh pr create --base=master --fill
    return
  fi
 
  LABEL_CACHE_PATH="${HOME}/.github/hellofresh_labels.txt"
  mkdir -p ${HOME}/.github
  touch -a $LABEL_CACHE_PATH

  LABEL_TRIBE="tribe: consumer-core"
  LABEL_SQUAD="squad: plans"
  LABEL_TYPE="type: feature"

  repoName=$(basename -s .git `git config --get remote.origin.url`)
  if ! grep -qFx "$repoName" $LABEL_CACHE_PATH; then
    echo "I don't know if the repo has your labels; gonna attempt to create the labels for tribe, squad, and type."
    gh api --silent repos/hellofresh/${repoName}/labels -f name=${LABEL_TRIBE} -f color="d4c5f9"
    gh api --silent repos/hellofresh/${repoName}/labels -f name=${LABEL_SQUAD} -f color="bf1e51"
    gh api --silent repos/hellofresh/${repoName}/labels -f name=${LABEL_TYPE} -f color="6843a8"
    echo "The label creation attempts are completed; saving this repo to avoid future requests."
    echo "$repoName" >> $LABEL_CACHE_PATH
  fi
  
  branchName=`git rev-parse --abbrev-ref HEAD`
  branchName_uc=$(echo $branchName | tr '[:lower:]' '[:upper:]')

  jiraId=$(echo $branchName_uc | /usr/bin/perl -ne '/[^\/]*\/([a-zA-Z]+-[0-9]+)/ && print $1')

  title=$(echo $branchName | ggrep -Po "(?<=$jiraId-).*$" | tr - " " | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')

  commits=$(git --no-pager log --pretty=format:%s --cherry "master...${branchName}" | awk '{print "- "$0}')
  body="**Ticket:** https://hellofresh.atlassian.net/browse/${jiraId}
  **Description:** 
  **Commits:**
  $commits"

  gh pr create --base=master --title="${jiraId} - ${title}" --body="${body}" --label ${LABEL_TRIBE} --label ${LABEL_SQUAD} --label ${LABEL_TYPE}
}
EOL
  source ~/.zshrc
fi

# Check pre-commit version
pre-commit --version

# Final update and cleanup
log_message "Running brew cleanup..."
brew cleanup

# Summary of installations
log_message "-----------------------------------------------"
log_message "Installation Summary:"
log_message "-----------------------------------------------"

if [ ${#installed[@]} -ne 0 ]; then
  log_message "Successfully installed:"
  for item in "${installed[@]}"; do
    log_message "  - $item"
  done
else
  log_message "No new installations were made."
fi

if [ ${#already_installed[@]} -ne 0 ]; then
  log_message "Already installed:"
  for item in "${already_installed[@]}"; do
    log_message "  - $item"
  done
fi

if [ ${#failed[@]} -ne 0 ]; then
  log_message "Failed to install:"
  for item in "${failed[@]}"; do
    log_message "  - $item"
  done
else
  log_message "No installation failures."
fi

log_message "Installation process complete!"

