#!/bin/bash

# Define directories within the user's home directory
MIRROR_DIR="$HOME/aosp/mirror"
MAIN_DIR="$HOME/aosp/main"
PLATFORM_MIRROR_URL="https://android.googlesource.com/platform/manifest"

# Calculate half the number of processors, rounded down
HALF_NPROC=$(( $(nproc --all) / 2 ))

# Function to create and sync the platform mirror
create_and_sync_platform_mirror() {
  echo "Creating and syncing the platform mirror..."

  # Create directory for the mirror if it doesn't exist
  mkdir -p "$MIRROR_DIR"
  cd "$MIRROR_DIR" || exit

  # Initialize the platform mirror repository
  repo init -u "$PLATFORM_MIRROR_URL" --mirror

  # Sync the platform mirror repository
  repo sync -c -j"$HALF_NPROC" || error_exit "Repo sync failed"
}

# Function to initialize and sync the client repository from the platform mirror
sync_client_from_platform_mirror() {
  echo "Syncing client from the platform mirror..."

  # Create directory for the main repository if it doesn't exist
  mkdir -p "$MAIN_DIR"
  cd "$MAIN_DIR" || exit

  # Initialize the client repository using the local platform mirror
  repo init -u "$MIRROR_DIR/platform/manifest.git"

  # Sync the client repository
  repo sync -c -j"$HALF_NPROC" || error_exit "Repo sync failed"
}

# Function to regularly sync the platform mirror and clients
regular_sync() {
  echo "Regularly syncing the platform mirror and clients..."

  # Sync the platform mirror against the server
  cd "$MIRROR_DIR" || exit
  repo sync -c -j"$HALF_NPROC" || error_exit "Repo sync failed"

  # Sync the client against the platform mirror
  cd "$MAIN_DIR" || exit
  repo sync -c -j"$HALF_NPROC" || error_exit "Repo sync failed"
}

# Function to handle errors
error_exit() {
  echo "$1" 1>&2
  exit 1
}

# Main script execution
create_and_sync_platform_mirror
sync_client_from_platform_mirror
regular_sync

echo "Platform mirror and client setup complete."
