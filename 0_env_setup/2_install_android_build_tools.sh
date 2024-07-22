#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if dependencies are already installed before installing
check_dependency() {
    dpkg -s "$1" &> /dev/null
}

install_dependency() {
    if ! check_dependency "$1"; then
        sudo apt install "$1" -y
    fi
}

# Check existence before removing
remove_if_exists() {
    if [ -e "$1" ]; then
        sudo rm "$1"
    fi
}

# List of packages to install
packages=(
  "git-core"
  "gnupg"
  "flex"
  "bison"
  "build-essential"
  "zip"
  "vim"
  "curl"
  "zlib1g-dev"
  "wget"
  "libc6-dev-i386"
  "x11proto-core-dev"
  "libx11-dev"
  "lib32z1-dev"
  "libgl1-mesa-dev"
  "libxml2-utils"
  "xsltproc"
  "unzip"
  "fontconfig"
)

# Array to hold the names of packages that failed to install
failed_packages=()

# Loop through each package and attempt to install
for package in "${packages[@]}"; do
  echo "Installing $package..."
  if install_dependency "$package"; then
    echo "$package installed successfully."
  else
    echo "Failed to install $package."
    failed_packages+=("$package")
  fi
  echo
done

# Print packages that failed to install
if [ ${#failed_packages[@]} -ne 0 ]; then
  echo "The following packages failed to install:"
  for pkg in "${failed_packages[@]}"; do
    echo "- $pkg"
  done
else
  echo "All packages installed successfully."
fi

# Install Repo tool
repo_temp=$(mktemp /tmp/repo.XXXXXXXXX)
curl -o "${repo_temp}" https://storage.googleapis.com/git-repo-downloads/repo
gpg --recv-keys 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
if curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - "${repo_temp}"; then
    sudo install -m 755 "${repo_temp}" /usr/local/bin/repo
    repo --version
else
    echo "GPG verification failed. Repo tool installation aborted."
    exit 1
fi
rm -r "${repo_temp}"

# Prompt user for Git configuration
read -p "Enter your Git user name: " git_username
read -p "Enter your Git user email: " git_useremail

# Configure Git user name and email
git config --global user.name "$git_username"
git config --global user.email "$git_useremail"

echo "Git configuration set:"
git config --global --get user.name
git config --global --get user.email

# Verify repo installation
if command -v repo > /dev/null; then
    echo "Repo tool installed successfully and is available on PATH."
else
    echo "Failed to install Repo tool."
fi
