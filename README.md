# NatMEG BIDSifier - User Edition

A user-friendly interface for managing remote NatMEG data processing servers.

## Quick Start

### 1. Clone This Repository
```bash
git clone <this-repo-url>
cd NatMEG-BIDSifier
```

### 2. Run Setup (First Time Only)
```bash
make setup
```

This will:
- Download the `localctl.sh` script from the admin repository
- Configure your SSH connection
- Set up your preferred remote server path
- Verify your SSH connection works

### 3. Start Using It

**Interactive Menu (Recommended for most users):**
```bash
make ui
```

**Or use direct commands:**
```bash
make start       # Launch a tunnel to the remote server
make status      # Check tunnel status
make stop        # Stop the tunnel
make list        # List running servers
make cleanup-all # Kill all your servers
```

## Features

### Start Tunnel
Launches a remote server and creates an SSH tunnel to your local machine.
- Auto-selects available ports
- Opens browser automatically
- Shows connection details

### Check Status
View current tunnel and remote server status at a glance.

### Stop Tunnel
Gracefully stops the SSH tunnel. Optionally stops the remote server too.

### List Servers
See all running servers and which ports they're using.

### Cleanup Specific Server
Stop a single server by port number.

### Cleanup All
**WARNING:** Kills all servers running under your user account.
- Only affects your own processes
- Admin's servers are protected
- Cleans up local configuration files

## Configuration

Settings are stored in `.config/settings`:
```bash
SSH_TARGET="youruser@compute.example.com"
REMOTE_REPO="/path/to/NatMEG-BIDSifier"
LOCAL_PORT="8080"
```

To reconfigure:
```bash
make setup
```

## Updating

To get the latest version of `localctl.sh` from the admin repository:
```bash
make update
```

## Troubleshooting

### "SSH connection failed"
- Check your SSH credentials
- Verify the remote server is accessible
- Run: `ssh youruser@your.server.com`

### "Port already in use"
- The script will auto-select another port
- Or specify a different port in settings: `make setup`

### "Permission denied when killing servers"
- The script only kills your own servers
- You cannot kill servers started by other users

### "Tunnel timed out"
- Remote server may be down
- Check with admin: `make list`

## File Structure

```
NatMEG-BIDSifier-user/
├── localctl-ui.sh       # Interactive menu wrapper
├── setup.sh             # Initial setup script
├── Makefile             # Convenient command shortcuts
├── README.md            # This file
├── .config/
│   └── settings         # Your configuration (created by setup)
├── .gitignore           # Git exclusions
└── scripts/
    └── localctl.sh      # Synced from admin repo (symlinked)
```

## Advanced Usage

### Using localctl.sh Directly
For advanced users, you can use `localctl.sh` directly with more options:

```bash
./scripts/localctl.sh --help
./scripts/localctl.sh start user@server /path/to/repo --local-port 9090
./scripts/localctl.sh cleanup --all user@server /path/to/repo
```

## Support

For issues with:
- **Tunnel connection:** Check your SSH configuration
- **Remote server:** Contact your NatMEG administrator
- **This tool:** Check the README or contact your admin

## License

See the main NatMEG-BIDSifier repository for license information.
