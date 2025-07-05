# Cursor Machine ID Reset

This Python script resets the machine identifiers used by Cursor editor, allowing you to refresh your identity.

## How It Works

The script modifies two key files used by Cursor to store machine identification:

1. **Storage JSON file**: Contains machine identifiers and telemetry information
2. **SQLite database**: Stores persistent state information including machine IDs

## Usage

### Interactive Mode

Run the script directly:

```bash
python reset_machine_id.py
```

The script will guide you through the process with interactive prompts:
1. Log out of your Cursor account
2. Exit the Cursor application
3. Reset machine IDs
4. Re-register and log in to Cursor

### Non-Interactive Mode

The script can also be used in non-interactive mode through the `run.sh` script in the parent directory.

## Technical Details

### Machine IDs Generated

The script generates the following new identifiers:

- `telemetry.devDeviceId`: UUID v4
- `telemetry.macMachineId`: SHA-512 hash of random bytes
- `telemetry.machineId`: SHA-256 hash of random bytes
- `telemetry.sqmId`: UUID v4 in curly braces
- `storage.serviceMachineId`: Same as devDeviceId

### File Locations

#### Windows
- Storage: `%APPDATA%\Cursor\User\globalStorage\storage.json`
- SQLite: `%APPDATA%\Cursor\User\globalStorage\state.vscdb`

#### macOS
- Storage: `~/Library/Application Support/Cursor/User/globalStorage/storage.json`
- SQLite: `~/Library/Application Support/Cursor/User/globalStorage/state.vscdb`

#### Linux
- Storage: `~/.config/cursor/User/globalStorage/storage.json`
- SQLite: `~/.config/cursor/User/globalStorage/state.vscdb`

## Safety Features

- Creates backups of modified files
- Verifies file permissions before making changes
- Handles errors gracefully

## Dependencies

- Python 3.x
- Standard library modules only (no external dependencies)

## License

This project is licensed under the MIT License.

## Disclaimer

This tool is provided for educational purposes only. Use at your own risk. 