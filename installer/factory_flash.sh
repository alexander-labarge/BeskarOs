#!/bin/bash

# Define the einfo function for logging messages
function einfo() {
    local blue='\e[1;34m'   # Light blue
    local yellow='\e[1;33m' # Yellow
    local red='\e[1;31m'    # Red
    local reset='\e[0m'     # Reset text formatting
    local hostname=$(hostname)
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="install-log-${hostname}-$(date '+%Y-%m-%d').log"

    # Ensure the log file exists in the current directory
    touch "$log_file"

    echo -e "${red}------------------------------------------------------------------------------------------------------------${reset}"
    echo -e "${blue}[${yellow}$(date '+%Y-%m-%d %H:%M:%S')${blue}] $1${reset}"
    echo -e "${red}------------------------------------------------------------------------------------------------------------${reset}"

    # Append the log message to the log file in the current directory
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$log_file" 2>&1
}

function einfo_purple_bold() {
    local purple_bold='\e[1;35m' # Purple and bold
    local reset='\e[0m'          # Reset text formatting
    echo -e "${purple_bold}$1${reset}"
}

# New function to execute commands and log their output and errors
function exec_and_log() {
    local command_output
    local command_error

    # Combine all arguments into one string to log the full command
    local full_command="$*"

    # Log the command being executed
    einfo "Executing command: $full_command"

    # Execute command and capture stdout and stderr
    command_output=$(eval "$full_command" 2>&1)
    command_error=$?

    # Log output
    einfo "$command_output"

    # Check if there was an error
    if [ $command_error -ne 0 ]; then
        einfo "Error (Exit Code: $command_error): $command_output"
        exit $command_error
    fi
}

function countdown_timer() {
    for ((i = 3; i >= 0; i--)); do
        if [ $i -gt 0 ]; then
            echo -ne "\r\033[K\e[31mContinuing in \e[34m$i\e[31m seconds\e[0m"
        else
            echo -e "\r\033[K\e[1;34mContinuing\e[0m"
        fi
        sleep 1
    done
}

function factory_flash_device() {
    echo "

        ########    ###     ######  ########  #######  ########  ##    ## 
        ##         ## ##   ##    ##    ##    ##     ## ##     ##  ##  ##  
        ##        ##   ##  ##          ##    ##     ## ##     ##   ####   
        ######   ##     ## ##          ##    ##     ## ########     ##    
        ##       ######### ##          ##    ##     ## ##   ##      ##    
        ##       ##     ## ##    ##    ##    ##     ## ##    ##     ##    
        ##       ##     ##  ######     ##     #######  ##     ##    ##    

            ########  #### ##     ## ######## ##           #######            
            ##     ##  ##   ##   ##  ##       ##          ##     ##           
            ##     ##  ##    ## ##   ##       ##          ##     ##           
            ########   ##     ###    ######   ##           #######            
            ##         ##    ## ##   ##       ##          ##     ##           
            ##         ##   ##   ##  ##       ##          ##     ##           
            ##        #### ##     ## ######## ########     #######            
                                                    
                                                                            "

    einfo_purple_bold "BeskarOS 0.1.0 Pixel 8 Factory Flashing Tool"

    # Check if adb is installed
    if ! command -v adb &> /dev/null; then
        einfo "adb is not installed. Please install adb and try again."
        exit 1
    fi

    einfo "adb is installed"

    # Check if fastboot is installed
    if ! command -v fastboot &> /dev/null; then
        einfo "fastboot is not installed. Please install fastboot and try again."
        exit 1
    fi

    einfo "fastboot is installed"

    # Check if adb version is at least 35
    adb_version=$(adb --version | grep -oP 'Version \K[0-9]+\.[0-9]+' | head -1)
    adb_major_version=$(echo $adb_version | cut -d. -f1)

    if [ "$adb_major_version" -lt 35 ]; then
        einfo "adb version is less than 35. Please update adb and try again."
        exit 1
    fi

    einfo "adb version is $adb_version"

    # Check if fastboot version is at least 35
    fastboot_version=$(fastboot --version | grep -oP 'fastboot version \K[0-9]+\.[0-9]+' | head -1)
    fastboot_major_version=$(echo $fastboot_version | cut -d. -f1)

    if [ "$fastboot_major_version" -lt 35 ]; then
        einfo "fastboot version is less than 35. Please update fastboot and try again."
        exit 1
    fi

    einfo "fastboot version is $fastboot_version"

    # Check if adb devices returns a device
    device_count=$(adb devices | grep -w "device" | wc -l)
    if [ "$device_count" -eq 0 ]; then
        einfo "No device found. Please connect a device and try again."
        exit 1
    fi

    countdown_timer

    einfo "Device Detected - Current Device Info:"

    # Fetch build fingerprint and other important information
    build_fingerprint=$(adb shell getprop ro.build.fingerprint)
    build_version_release=$(adb shell getprop ro.build.version.release)
    build_version_sdk=$(adb shell getprop ro.build.version.sdk)
    build_id=$(adb shell getprop ro.build.id)

    einfo "Build Fingerprint: $build_fingerprint"
    einfo "Build Version Release: $build_version_release"
    einfo "Build Version SDK: $build_version_sdk"
    einfo "Build ID: $build_id"

    # Download the factory image
    einfo "Downloading factory image..."
    exec_and_log "wget https://dl.google.com/dl/android/aosp/shiba-ap2a.240705.005-factory-461aa7c8.zip"

    # Unzip the downloaded factory image
    einfo "Unzipping factory image..."
    exec_and_log "unzip shiba-ap2a.240705.005-factory-461aa7c8.zip"

    # Navigate to the unzipped directory
    cd shiba-ap2a.240705.005
    einfo "Navigated to $(pwd)"

    # Reboot to Bootloader
    einfo "Rebooting to bootloader..."
    exec_and_log "adb reboot bootloader"

    # Flash the factory image
    einfo "Flashing factory image..."

    exec_and_log "./flash-all.sh"

    einfo "Device successfully flashed and rebooted."
    einfo "Script ended successfully"
}

# Run the factory_flash_device function
factory_flash_device
