#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables and paths
REPO_URL="https://storage.googleapis.com/git-repo-downloads/repo"
REPO_KEY="8BB9AD793E8E6153AF0F9A4416530D5E920F5C65"
REPO_TEMP=$(mktemp /tmp/repo.build.XXXXXXXXXX.$(date +%Y%m%d%H%M%S))
PACKAGES_FILE="ubuntu_22.04_packages_required.txt"
FAILED_PACKAGES=()

# Functions
check_dependency() {
    dpkg -s "$1" &> /dev/null
}

install_dependency() {
    if ! check_dependency "$1"; then
        sudo apt install "$1" -y
    fi
}

remove_if_exists() {
    if [ -e "$1" ]; then
        sudo rm "$1"
    fi
}

install_packages() {
    while IFS= read -r package; do
        echo "Installing $package..."
        if install_dependency "$package"; then
            echo "$package installed successfully."
        else
            echo "Failed to install $package."
            FAILED_PACKAGES+=("$package")
        fi
        echo
    done < "$PACKAGES_FILE"

    if [ ${#FAILED_PACKAGES[@]} -ne 0 ]; then
        echo "The following packages failed to install:"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo "- $pkg"
        done
    else
        echo "All packages installed successfully."
    fi
}

remove_existing_repo() {
    if command -v repo > /dev/null; then
        echo "Removing existing repo tool..."
        sudo rm -f "$(command -v repo)"
    fi
}

install_repo_tool() {
    remove_existing_repo
    curl -o "${REPO_TEMP}" "${REPO_URL}"
    gpg --recv-keys "${REPO_KEY}"
    if curl -s "${REPO_URL}.asc" | gpg --verify - "${REPO_TEMP}"; then
        sudo install -m 755 "${REPO_TEMP}" /usr/local/bin/repo
        repo --version
    else
        echo "GPG verification failed. Repo tool installation aborted."
        exit 1
    fi
    rm -r "${REPO_TEMP}"
}

configure_git() {
    read -p "Enter your Git user name: " git_username
    read -p "Enter your Git user email: " git_useremail

    git config --global user.name "$git_username"
    git config --global user.email "$git_useremail"

    echo "Git configuration set:"
    git config --global --get user.name
    git config --global --get user.email
}

verify_repo_installation() {
    if command -v repo > /dev/null; then
        echo "Repo tool is available on PATH."
    else
        echo "Failed to install Repo tool."
    fi
}

# script execution
install_packages
install_repo_tool
configure_git
verify_repo_installation

echo "#########################################################################"
echo "Ubuntu 22.04 Updated & Required Packages Installed"
echo "Repo tool installed successfully and is available on PATH."
echo "Git configuration set."
echo "#########################################################################"