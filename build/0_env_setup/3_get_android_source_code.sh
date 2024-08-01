#!/bin/bash

# Variables
MIRROR_DIR=/mnt/android/mirror
BESKAR_BUILD_DIR=/mnt/android/beskaros
REPO_URL="https://android.googlesource.com/platform/manifest"
MAKE_CORES="16" # Change to an integer if needed
REQUIRED_SPACE_GB=512 # TODO: figure out top capacity

# Function to display error messages and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Check if repo command exists
function check_repo_command {
    if ! command -v repo &> /dev/null; then
        error_exit "repo command could not be found. Please install repo tool."
    fi
}

# Function to check available disk space
function check_disk_space {
    local dir_path="$1"
    local available_space=$(df -BG "$dir_path" | tail -1 | awk '{print $4}' | sed 's/G//')
    echo "Available space in $dir_path: ${available_space}GB"
    if [ "$available_space" -lt "$REQUIRED_SPACE_GB" ]; then
        error_exit "Not enough disk space in $dir_path. Required: ${REQUIRED_SPACE_GB}GB, Available: ${available_space}GB"
    fi
}

# Function to delete and recreate a directory
setup_directory() {
    local dir_path="$1"

    if [ -d "$dir_path" ]; then
        echo "Directory $dir_path exists. Deleting its contents..."
        sudo rm -rf "${dir_path:?}"/* || error_exit "Failed to delete contents of $dir_path"
    else
        echo "Creating directory $dir_path..."
        sudo mkdir -p "$dir_path" || error_exit "Failed to create directory $dir_path"
    fi

    check_disk_space "$dir_path"
    ensure_ownership "$dir_path"
}

# Ensure the specified directory is owned by the current user
function ensure_ownership {
    local dir_path="$1"
    echo "Changing ownership of $dir_path to current user..."
    sudo chown -R $(whoami):$(whoami) "$dir_path" || error_exit "Failed to change ownership of $dir_path"
}

# Create and sync the mirror
function create_and_sync_mirror {
    setup_directory "$MIRROR_DIR"
    
    # Check if .repo directory exists and delete it if it does
    if [ -d "$MIRROR_DIR/.repo" ]; then
        echo "Deleting existing .repo directory..."
        sudo rm -rf "$MIRROR_DIR/.repo" || error_exit "Failed to delete .repo directory in $MIRROR_DIR"
    fi

    cd "$MIRROR_DIR" || error_exit "Failed to navigate to mirror directory"
    echo "Creating and syncing the mirror..."
    repo init -u "$REPO_URL" --mirror || error_exit "Repo init for mirror failed"
    repo sync -c -j"$MAKE_CORES" || error_exit "repo sync -c -j$MAKE_CORES for mirror failed"
}

# Sync clients from the mirror
function sync_clients_from_mirror {
    setup_directory "$BESKAR_BUILD_DIR"
    cd "$BESKAR_BUILD_DIR" || error_exit "Failed to navigate to main directory"
    echo "Syncing clients from the mirror..."
    repo init -u "$MIRROR_DIR/platform/manifest.git" || error_exit "Repo init for main failed"
    repo sync -c -j"$MAKE_CORES" || error_exit "repo sync -c -j$MAKE_CORES for main failed"
}

# Sync the mirror and the client again to ensure they're up to date
function final_sync {
    cd "$MIRROR_DIR" || error_exit "Failed to navigate to mirror directory"
    echo "Syncing the mirror against the server..."
    repo sync -c -j"$MAKE_CORES" || error_exit "repo sync -c -j$MAKE_CORES for mirror failed"
    cd "$BESKAR_BUILD_DIR" || error_exit "Failed to navigate to main directory"
    echo "Syncing the client against the mirror..."
    repo sync -c -j"$MAKE_CORES" || error_exit "repo sync -c -j$MAKE_CORES for main failed"
}

# Main function to orchestrate the setup
function main {
    check_repo_command
    create_and_sync_mirror
    sync_clients_from_mirror
    final_sync
    echo "Android Source Download Complete"
    echo "Source code located at: $BESKAR_BUILD_DIR"
}

# Run the main function
main
