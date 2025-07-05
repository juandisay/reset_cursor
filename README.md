# Cursor Reset Tool

A simple tool for resetting your Cursor editor identity by changing your MAC ID and machine identifiers.

## Features

- **MAC ID Reset**: Randomizes your MAC address for Wi-Fi interface
- **Account Reset**: Resets machine identifiers used by Cursor

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

The script will automatically perform the necessary operations.

### What the Script Does

1. **MAC ID Reset**
   - Checks if spoof-mac is installed (installs if needed)
   - Randomizes your MAC address for Wi-Fi
   - Displays the old and new MAC addresses

2. **Account Reset**
   - Downloads and runs the latest reset script
   - Resets machine identifiers used by Cursor

## Troubleshooting

### Connection Issues

If you encounter connection issues, the script will retry up to 3 times with a 30-second delay between attempts.

### Installation Failures

If the script fails to install spoof-mac or reset your account, it will display an error message and exit.

## File Structure

- `run.sh` - Main script
- `cursor-vip/reset_machine_id.py` - Python reset script (not used by default)
- `cursor_accounts.txt` - Optional file for storing account information

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This tool is provided for educational purposes only. Use at your own risk.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 