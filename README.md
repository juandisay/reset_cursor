# Cursor Reset Tool

A comprehensive tool for resetting your Cursor editor identity by changing your MAC ID and machine identifiers.

## Features

- **MAC ID Reset**: Randomizes your MAC address for Wi-Fi interface
- **Account Reset**: Resets machine identifiers used by Cursor
- **Resilient Design**: Handles network issues and GitHub API rate limits
- **Multiple Fallbacks**: Works even without internet connection using local scripts

## Prerequisites

- macOS or Linux operating system
- Homebrew (for macOS)
- Python 3.x (for local script fallback)
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

The script will guide you through the process with interactive prompts.

### What the Script Does

1. **MAC ID Reset**
   - Checks if spoof-mac is installed (installs if needed)
   - Randomizes your MAC address for Wi-Fi
   - Displays the old and new MAC addresses

2. **Account Reset**
   - Attempts to download and run the latest reset script
   - Falls back to local script if GitHub is unreachable
   - Handles GitHub API rate limits with multiple options
   - Resets machine identifiers used by Cursor

## Troubleshooting

### Network Connectivity Issues

If you encounter network connectivity issues:
- The script will automatically check your internet connection
- It will wait and retry if needed
- If GitHub is unreachable, it will offer DNS fix options

### GitHub API Rate Limit

If you hit GitHub API rate limits:
1. Wait for the rate limit to reset (usually 1 hour)
2. Use a VPN to change your IP address
3. Use the local reset script instead

### Local Script Fallback

The script includes a non-interactive version of the machine ID reset that:
- Works without internet connection
- Directly modifies Cursor configuration files
- Avoids making any GitHub API calls

## File Structure

- `run.sh` - Main script
- `cursor-vip/reset_machine_id.py` - Original Python reset script
- `cursor_accounts.txt` - Optional file for storing account information

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This tool is provided for educational purposes only. Use at your own risk.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 