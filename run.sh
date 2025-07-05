#!/bin/bash

# Cursor Reset Tool
# This script resets MAC ID and user account for Cursor

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Cursor Reset Tool ===${NC}"

# Function to handle errors
handle_error() {
  echo -e "${RED}Error: $1${NC}"
  exit 1
}

# Function to reset MAC ID
reset_mac_id() {
  echo -e "${BLUE}Resetting MAC ID...${NC}"
  
  # Check if spoof-mac is installed
  if ! command -v spoof-mac &> /dev/null; then
    echo -e "${BLUE}spoof-mac not found. Installing...${NC}"
    if ! command -v brew &> /dev/null; then
      handle_error "Homebrew is not installed. Please install Homebrew first."
    fi
    
    brew install spoof-mac || handle_error "Failed to install spoof-mac"
    echo -e "${GREEN}spoof-mac installed successfully${NC}"
  fi
  
  # Randomize MAC address for Wi-Fi
  echo -e "${BLUE}Randomizing MAC address for Wi-Fi interface...${NC}"
  sudo spoof-mac randomize Wi-Fi || handle_error "Failed to randomize MAC address"
  echo -e "${GREEN}MAC ID reset completed successfully${NC}"
}

# Function to display MAC address change information
display_mac_change() {
  echo -e "${BLUE}Displaying MAC address change information...${NC}"
  
  # Get interface name (Wi-Fi or en0)
  INTERFACE="en0"
  
  # Get old MAC address from system logs if available
  OLD_MAC=$(grep -i "MAC address changed" /var/log/system.log 2>/dev/null | tail -1 | grep -o -E "([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}" | head -1)
  
  # If not found in logs, use a placeholder
  if [ -z "$OLD_MAC" ]; then
    OLD_MAC="[Previous MAC address]"
  fi
  
  # Get current MAC address
  NEW_MAC=$(ifconfig $INTERFACE | grep ether | awk '{print $2}')
  
  echo -e "${BLUE}Interface:${NC} $INTERFACE"
  echo -e "${BLUE}Old MAC:${NC} $OLD_MAC"
  echo -e "${BLUE}New MAC:${NC} $NEW_MAC"
  echo -e "${GREEN}MAC address has been changed successfully${NC}"
}

# Function to download and run the installation script
download_and_run_install_script() {
  echo -e "${BLUE}Downloading and running installation script...${NC}"
  
  MAX_RETRIES=3
  RETRY_DELAY=30
  RETRY_COUNT=0
  
  while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -fsSL https://raw.githubusercontent.com/yeongpin/cursor-free-vip/main/scripts/install.sh -o install.sh; then
      chmod +x install.sh
      ./install.sh
      return 0
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        echo -e "${YELLOW}Connection failed. Retrying in $RETRY_DELAY seconds... (Attempt $RETRY_COUNT of $MAX_RETRIES)${NC}"
        sleep $RETRY_DELAY
      else
        handle_error "Failed to download installation script after $MAX_RETRIES attempts"
      fi
    fi
  done
}

# Reset account by downloading and running the installation script
reset_account() {
  echo -e "${BLUE}Resetting account...${NC}"
  download_and_run_install_script
  echo -e "${GREEN}Account reset completed successfully${NC}"
}


# Cleanup function
cleanup() {
  echo -e "${BLUE}Cleaning up temporary files...${NC}"
  rm -f ./cursor_mac_id_modifier.sh ./install.sh
}

# Set trap to ensure cleanup on exit
trap cleanup EXIT

# Main execution
reset_mac_id
display_mac_change
reset_account

echo -e "${GREEN}All reset operations completed successfully!${NC}"
