#!/bin/bash

# Cursor Reset Tool
# This script resets MAC ID and user account for Cursor

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Cursor Reset Tool ===${NC}"

# Function to handle errors
handle_error() {
  local error_message=$1
  local exit_immediately=${2:-true}
  local error_code=${3:-1}
  local additional_info=${4:-""}
  
  echo -e "\n${RED}ERROR: $error_message${NC}"
  
  # Create more detailed log entry
  local log_file="cursor_reset_error.log"
  {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $error_message"
    echo "Error Code: $error_code"
    echo "Command: $BASH_COMMAND"
    echo "Line Number: ${BASH_LINENO[0]}"
    
    if [ -n "$additional_info" ]; then
      echo "Additional Info: $additional_info"
    fi
    
    echo "System: $(uname -a)"
    echo "-----------------------------------"
  } >> "$log_file"
  
  if [ "$exit_immediately" = true ]; then
    echo -e "${YELLOW}For more details, check the error log: $log_file${NC}"
    echo -e "${YELLOW}If you continue to experience issues, please report this problem.${NC}"
    echo -e "${YELLOW}Include the error log file when reporting issues.${NC}"
    exit $error_code
  fi
  
  return $error_code
}

# Function to prompt for user approval
ask_for_approval() {
  local action=$1
  echo -e "${YELLOW}This action requires your approval: $action${NC}"
  read -p "Do you want to proceed? (y/n): " choice
  case "$choice" in 
    y|Y ) return 0;;
    * ) echo -e "${YELLOW}Action cancelled by user${NC}"; return 1;;
  esac
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
    
    if ask_for_approval "Install spoof-mac using Homebrew"; then
      brew install spoof-mac || handle_error "Failed to install spoof-mac"
      echo -e "${GREEN}spoof-mac installed successfully${NC}"
    else
      handle_error "MAC ID reset cancelled"
    fi
  fi
  
  # Randomize MAC address for Wi-Fi
  echo -e "${BLUE}Randomizing MAC address for Wi-Fi interface...${NC}"
  if ask_for_approval "Randomize MAC address for Wi-Fi interface (requires sudo)"; then
    sudo spoof-mac randomize Wi-Fi || handle_error "Failed to randomize MAC address"
    echo -e "${GREEN}MAC ID reset completed successfully${NC}"
  else
    handle_error "MAC ID reset cancelled"
  fi
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



# Function to check network connectivity
check_network() {
  local test_url="https://raw.githubusercontent.com"
  echo -e "${BLUE}Checking network connectivity...${NC}"
  
  # Try to connect to GitHub's raw content server
  if curl --connect-timeout 5 -s -o /dev/null -I "$test_url"; then
    echo -e "${GREEN}Network connectivity: OK${NC}"
    return 0
  else
    echo -e "${RED}Network connectivity: Failed${NC}"
    echo -e "${YELLOW}Cannot connect to $test_url${NC}"
    return 1
  fi
}

# Function to download and run the installation script
download_and_run_install_script() {
  echo -e "${BLUE}Downloading and running installation script...${NC}"
  
  SCRIPT_URL="https://raw.githubusercontent.com/yeongpin/cursor-free-vip/main/scripts/install.sh"
  
  if ask_for_approval "Download and execute the installation script"; then
    # Check network connectivity first
    if ! check_network; then
      handle_error "Network connectivity check failed" false 4 "Cannot connect to GitHub's raw content server"
      echo -e "${YELLOW}Please check your internet connection and try again${NC}"
      return 1
    fi
    
    # Step 1: Download the script with progress indicator
    echo -e "${BLUE}Downloading installation script...${NC}"
    CURL_OUTPUT=$(curl -L --progress-bar "$SCRIPT_URL" -o install.sh 2>&1)
    CURL_EXIT_CODE=$?
    if [ $CURL_EXIT_CODE -ne 0 ]; then
      echo -e "${RED}Failed to download the installation script${NC}"
      handle_error "Failed to download installation script" false $CURL_EXIT_CODE "URL: $SCRIPT_URL\nCurl output: $CURL_OUTPUT"
      return 1
    fi
    
    # Verify the downloaded file is not empty
    if [ ! -s install.sh ]; then
      echo -e "${RED}Downloaded script is empty${NC}"
      handle_error "Downloaded script is empty" false 2 "URL: $SCRIPT_URL"
      rm -f install.sh
      return 1
    fi
    
    # Step 2: Make the script executable
    echo -e "${BLUE}Making script executable...${NC}"
    if ! chmod +x install.sh; then
      echo -e "${RED}Failed to make the script executable${NC}"
      rm -f install.sh
      handle_error "Failed to make installation script executable" false 3
      return 1
    fi
    
    # Step 3: Execute the script
    echo -e "${BLUE}Executing installation script...${NC}"
    ./install.sh 2>&1 | tee install_output.log
    SCRIPT_EXIT_CODE=${PIPESTATUS[0]}
    
    if [ $SCRIPT_EXIT_CODE -ne 0 ]; then
      echo -e "${RED}Installation script failed with exit code: $SCRIPT_EXIT_CODE${NC}"
      echo -e "${RED}Check install_output.log for detailed error information${NC}"
      
      # Extract the last few lines of output for the error log
      LAST_OUTPUT=$(tail -n 10 install_output.log)
      handle_error "Failed to execute installation script" false $SCRIPT_EXIT_CODE "Last output:\n$LAST_OUTPUT"
      return 1
    else
      echo -e "${GREEN}Installation script executed successfully${NC}"
    fi
    
    # Cleanup
    rm -f install.sh install_output.log
    return 0
  else
    echo -e "${YELLOW}Installation cancelled by user${NC}"
    return 1
  fi
}

# Function to check if Cursor is installed
check_cursor_installed() {
  local cursor_app="/Applications/Cursor.app"
  local cursor_data="$HOME/Library/Application Support/Cursor"
  
  if [ -d "$cursor_app" ] || [ -d "$cursor_data" ]; then
    return 0  # Cursor is installed
  else
    return 1  # Cursor is not installed
  fi
}

# Function to reset the account
reset_account() {
  echo -e "${BLUE}Resetting account...${NC}"
  
  # Check if Cursor is installed
  if ! check_cursor_installed; then
    echo -e "${YELLOW}Warning: Cursor does not appear to be installed on this system${NC}"
    if ! ask_for_approval "Continue with account reset even though Cursor is not detected"; then
      echo -e "${YELLOW}Account reset cancelled${NC}"
      return 1
    fi
  fi
  
  # Check if Cursor is running
  if pgrep -x "Cursor" > /dev/null; then
    echo -e "${YELLOW}Warning: Cursor is currently running${NC}"
    echo -e "${YELLOW}It's recommended to close Cursor before resetting the account${NC}"
    if ! ask_for_approval "Continue with Cursor running"; then
      echo -e "${YELLOW}Please close Cursor and try again${NC}"
      return 1
    fi
  fi
  
  if ask_for_approval "Reset Cursor account by downloading and running installation script"; then
    echo -e "${BLUE}Starting account reset process...${NC}"
    
    # Try to download and run the installation script
    if ! download_and_run_install_script; then
      # Get Cursor version if available
      CURSOR_VERSION="Unknown"
      if [ -d "$HOME/Library/Application Support/Cursor" ]; then
        if [ -f "$HOME/Library/Application Support/Cursor/version" ]; then
          CURSOR_VERSION=$(cat "$HOME/Library/Application Support/Cursor/version")
        fi
      fi
      
      handle_error "Account reset failed" false 10 "Cursor version: $CURSOR_VERSION"
      echo -e "${YELLOW}Please try again later or contact support for assistance.${NC}"
      echo -e "${YELLOW}You can also try manually downloading the script from:${NC}"
      echo -e "${CYAN}https://raw.githubusercontent.com/yeongpin/cursor-free-vip/main/scripts/install.sh${NC}"
      echo -e "${YELLOW}Manual steps:${NC}"
      echo -e "${CYAN}1. Download the script: curl -L $SCRIPT_URL -o install.sh${NC}"
      echo -e "${CYAN}2. Make it executable: chmod +x install.sh${NC}"
      echo -e "${CYAN}3. Run it: ./install.sh${NC}"
      return 1
    fi
    
    # Check if Cursor data directory exists and was modified
    local cursor_data_dir="$HOME/Library/Application Support/Cursor"
    if [ -d "$cursor_data_dir" ]; then
      local last_modified=$(stat -f "%m" "$cursor_data_dir")
      local current_time=$(date +%s)
      local time_diff=$((current_time - last_modified))
      
      if [ $time_diff -lt 60 ]; then
        echo -e "${GREEN}Cursor data directory was recently modified${NC}"
        echo -e "${GREEN}Account reset appears to be successful${NC}"
      else
        echo -e "${YELLOW}Warning: Cursor data directory was not recently modified${NC}"
        echo -e "${YELLOW}The reset might not have been fully applied${NC}"
      fi
    fi
    
    echo -e "${GREEN}Account reset completed successfully${NC}"
    return 0
  else
    echo -e "${YELLOW}Account reset cancelled by user${NC}"
    return 1
  fi
}


# Cleanup function
cleanup() {
  echo -e "${BLUE}Cleaning up temporary files...${NC}"
  rm -f ./cursor_mac_id_modifier.sh ./install.sh
}

# Set trap to ensure cleanup on exit
trap cleanup EXIT

# Function to display system information
display_system_info() {
  echo -e "${BLUE}System Information:${NC}"
  echo -e "${BLUE}OS:${NC} $(uname -s) $(uname -r)"
  echo -e "${BLUE}Architecture:${NC} $(uname -m)"
  
  # Check if running on macOS and get version
  if [[ "$(uname)" == "Darwin" ]]; then
    echo -e "${BLUE}macOS Version:${NC} $(sw_vers -productVersion)"
  fi
  
  # Check internet connectivity
  echo -ne "${BLUE}Internet Connectivity:${NC} "
  if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}Connected${NC}"
  else
    echo -e "${RED}Disconnected${NC}"
  fi
  
  # Check if Cursor is installed
  echo -ne "${BLUE}Cursor Installation:${NC} "
  if check_cursor_installed; then
    echo -e "${GREEN}Installed${NC}"
    
    # Get Cursor version if available
    if [ -f "$HOME/Library/Application Support/Cursor/version" ]; then
      CURSOR_VERSION=$(cat "$HOME/Library/Application Support/Cursor/version")
      echo -e "${BLUE}Cursor Version:${NC} $CURSOR_VERSION"
    fi
  else
    echo -e "${RED}Not Installed${NC}"
  fi
}

# Main execution
echo -e "${GREEN}===== Cursor Reset Tool =====${NC}"
echo -e "${BLUE}Version: 1.2.0${NC}"
echo -e "${BLUE}This tool will help you reset your MAC ID and Cursor account${NC}"
display_system_info

if ask_for_approval "Run Cursor Reset Tool (This will reset your MAC ID and Cursor account)"; then
  echo -e "\n${GREEN}Starting reset process...${NC}"
  
  # Track overall success
  MAC_RESET_SUCCESS=false
  ACCOUNT_RESET_SUCCESS=false
  
  # Reset MAC ID
  echo -e "\n${BLUE}Step 1: Resetting MAC ID${NC}"
  if reset_mac_id; then
    MAC_RESET_SUCCESS=true
    # Display MAC address change
    display_mac_change
  else
    echo -e "${YELLOW}MAC ID reset failed or was cancelled.${NC}"
  fi
  
  # Reset account
  echo -e "\n${BLUE}Step 2: Resetting Cursor account${NC}"
  if reset_account; then
    ACCOUNT_RESET_SUCCESS=true
  else
    echo -e "${YELLOW}Account reset failed or was cancelled.${NC}"
  fi
  
  # Clean up
  echo -e "\n${BLUE}Step 3: Cleaning up temporary files${NC}"
  cleanup
  
  # Summary
  echo -e "\n${GREEN}===== Reset Summary =====${NC}"
  if [ "$MAC_RESET_SUCCESS" = true ]; then
    echo -e "${GREEN}✓ MAC ID reset: Successful${NC}"
  else
    echo -e "${RED}✗ MAC ID reset: Failed${NC}"
  fi
  
  if [ "$ACCOUNT_RESET_SUCCESS" = true ]; then
    echo -e "${GREEN}✓ Account reset: Successful${NC}"
  else
    echo -e "${RED}✗ Account reset: Failed${NC}"
  fi
  
  if [ "$MAC_RESET_SUCCESS" = true ] && [ "$ACCOUNT_RESET_SUCCESS" = true ]; then
    echo -e "\n${GREEN}Cursor has been reset successfully!${NC}"
    echo -e "${GREEN}You can now launch Cursor and use it with a fresh account.${NC}"
  else
    echo -e "\n${YELLOW}Cursor reset completed with some issues.${NC}"
    echo -e "${YELLOW}Please check the error log for details or try again.${NC}"
  fi
else
  echo -e "${YELLOW}Operation cancelled by user${NC}"
fi

echo -e "\n${GREEN}Thank you for using Cursor Reset Tool!${NC}"
exit 0
