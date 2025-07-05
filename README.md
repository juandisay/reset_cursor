# Cursor Reset Tool

A bash script to reset MAC ID and Cursor account for macOS users with improved error handling.

## Features

- **MAC ID Reset**: Randomizes your MAC address for Wi-Fi interface
- **Account Reset**: Resets machine identifiers used by Cursor
- **User Approval**: Prompts for user approval before executing sensitive operations
- **Enhanced Error Handling**: Provides detailed error messages and logs errors to a file for troubleshooting
- **Streamlined Installation**: Direct download and execution of the installation script
- **Simplified Process**: Streamlined approach for account reset
- **Direct Execution**: Downloads and executes the installation script in one step
- **Network Connectivity Check**: Verifies internet connection before attempting downloads
- **System Information Display**: Shows OS, architecture, and Cursor installation details
- **Cursor Installation Check**: Detects if Cursor is installed before attempting reset
- **Detailed Error Logging**: Captures comprehensive error information for troubleshooting

## Prerequisites

- macOS or Linux operating system
- Homebrew (for macOS)
- Administrative privileges (for changing MAC address)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/reset_cursor.git
   cd reset_cursor
   ```

2. Make the script executable:
   ```bash
   chmod +x run.sh
   ```

## Usage

Simply run the script:

```bash
./run.sh
```

The script will guide you through the reset process with clear prompts and status updates:

1. You'll be asked for overall approval to run the Cursor Reset Tool
2. Each sensitive operation will require separate approval
3. Progress will be displayed with color-coded status messages
4. A summary report will show which operations succeeded or failed

### What the Script Does

1. **MAC ID Reset**
   - Checks if spoof-mac is installed (installs if needed with your approval)
   - Randomizes your MAC address for Wi-Fi (requires your approval)
   - Displays the old and new MAC addresses with clear before/after comparison
   - Handles errors gracefully with detailed messages

2. **Account Reset**
   - Checks if Cursor is currently running and warns if it is
   - Verifies if Cursor is installed before attempting reset
   - Downloads and executes the latest reset script in one step
   - Requires your approval before execution
   - Captures and displays detailed output for troubleshooting
   - Logs installation script output to a dedicated log file
   - Verifies reset success by checking data directory modification time
   - Provides clear error messages with manual recovery instructions if reset fails
   - Resets machine identifiers used by Cursor

3. **Error Handling and Reporting**
   - Logs all errors to a dedicated log file with detailed context information
   - Includes system information, error codes, and command details in error logs
   - Performs network connectivity checks before download attempts
   - Displays system information for better diagnostics
   - Provides clear, color-coded status messages with specific error codes
   - Captures and logs installation script output for troubleshooting
   - Provides step-by-step manual recovery instructions when operations fail
   - Generates a summary report of all operations with detailed status

## Troubleshooting

### System Information

The script now displays system information at startup to help with troubleshooting:
- Operating system and architecture
- macOS version (if applicable)
- Internet connectivity status
- Cursor installation status and version
- This information is also included in error logs for better context

### Error Logs

The script now creates a detailed error log file (`cursor_reset_error.log`) that contains information about any errors encountered during execution. This log can be helpful for diagnosing issues.

### Connection Issues

If you encounter connection issues:
- The script now performs a network connectivity check before attempting downloads
- Connection problems are detected early and reported with specific error messages
- The error log includes detailed information about the connection attempt
- If connectivity fails, the script provides guidance on how to check your network

### Direct Script Execution

The script now downloads and executes the installation script in one step:
- Simplifies the process with a single command
- Requires your approval before execution
- If the download or execution fails, the script will report the error

### Installation Failures

If the installation script fails to execute:
- Detailed error output is captured and displayed with specific error codes
- The installation script output is logged to a dedicated log file (install_output.log)
- The error is logged to the error log file with system information and context
- The script checks for empty downloaded files and reports specific issues
- The script provides the last 10 lines of the installation log for quick diagnosis
- Manual recovery instructions are provided with exact curl commands to run
- A summary report will show which steps succeeded and which failed with detailed status

### Recovery Options

If the primary reset methods fail:
1. The script will provide clear error messages with specific error codes
2. All errors are logged with detailed context information for troubleshooting
3. The script now provides step-by-step manual recovery instructions
4. For account reset failures, the script shows the exact curl commands you can run manually
5. The error log includes system information and Cursor version details to help with support requests

## File Structure

- `run.sh` - Main script with enhanced error handling
- `cursor_reset_error.log` - Error log file (created automatically when errors occur)
- `install_output.log` - Installation script output log for troubleshooting
- `cursor_accounts.txt` - Optional file for storing account information

## Version History

### v1.2.0
- Added network connectivity check before download attempts
- Added system information display for better diagnostics
- Added Cursor installation detection
- Enhanced error logging with detailed context information
- Improved error handling with specific error codes
- Added step-by-step execution with better progress reporting
- Added manual recovery instructions for failed operations

### v1.1.0
- Added enhanced error handling with detailed error messages
- Implemented direct script download and execution
- Improved error messaging for failed operations
- Added detailed error logging to cursor_reset_error.log
- Improved user interface with step-by-step progress indicators
- Added summary report of successful and failed operations

### v1.0.0
- Initial release with basic MAC ID and account reset functionality

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This tool is provided for educational purposes only. Use at your own risk.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.