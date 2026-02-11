# NatMEG BIDSifier - User Edition

A user-friendly interface for managing remote NatMEG data processing servers.

## 30-Second Quick Start

```bash
# 1. Clone and setup
git clone <this-repo-url>
cd NatMEG-BIDSifier
make setup

# 2. Launch
make ui              # Interactive menu (easiest)
# or
make start           # Direct start
```

## Common Tasks

```bash
make ui              # Start interactive menu
make start           # Launch a tunnel to the remote server
make stop            # Stop the tunnel
make status          # Check tunnel and server status
make list            # List all running servers
make cleanup-all     # Kill all your servers (with confirmation)
make update          # Get latest version
```

## Features

- **Easy Setup:** One-time configuration wizard
- **Interactive Menu:** No command-line knowledge required
- **Auto-Port Selection:** Detects available ports automatically
- **Browser Integration:** Opens browser automatically when tunnel starts
- **Safe Cleanup:** Only stops your own processes
- **Auto-Updates:** Stays synchronized with latest version
- **SSH Tunnel:** Secure connection to remote servers

## Configuration

Settings are stored in `.config/settings` (created during setup):

```bash
SSH_TARGET="youruser@compute.example.com"
REMOTE_REPO="/path/to/NatMEG-BIDSifier"
LOCAL_PORT="8080"
```

To reconfigure: `make setup`

## Installation for Administrators

### Option 1: Direct GitHub Clone
```bash
git clone git@github.com:k-CIR/NatMEG-BIDSifier.git
cd NatMEG-BIDSifier
make setup
```

### Option 2: Share via Filesystem
```bash
cp -r NatMEG-BIDSifier /shared/applications/
# Users: cd /shared/applications/NatMEG-BIDSifier && make setup
```

### Multiple Users on Shared Machine
```bash
sudo git clone git@github.com:k-CIR/NatMEG-BIDSifier.git /opt/natmeg-tunnel
sudo chmod 777 /opt/natmeg-tunnel/.config
# Each user runs: make setup
```

## How It Works

```
┌─────────────────────────────────────────────────┐
│ Your Local Machine                              │
│ ┌────────────────────────────────────────────┐  │
│ │ Browser: localhost:PORT                    │  │
│ └────────────────────────────────────────────┘  │
│           ↑                                      │
│    SSH Tunnel (secure)                          │
│           ↓                                      │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ Remote Server                                   │
│ ┌────────────────────────────────────────────┐  │
│ │ NatMEG Application                          │  │
│ └────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| SSH connection fails | Run `make setup` to reconfigure SSH details |
| Port already in use | Script auto-selects another port |
| Want to change server | Run `make setup` again |
| Want latest version | Run `make update` |
| Permission denied when killing servers | Script only stops your own processes |
| Tunnel times out | Remote server may be down; contact admin |

## File Structure

```
NatMEG-BIDSifier/
├── localctl-ui.sh          # Interactive menu
├── setup.sh                # Setup wizard
├── Makefile                # Command shortcuts
├── README.md               # This file
├── .config/
│   └── settings            # Your configuration (created by setup)
├── scripts/
│   └── localctl.sh         # Main control script (synced from admin)
└── shared/
    └── admin/              # Admin repo (synced automatically)
```

## Advanced Usage

### Using localctl.sh Directly
For advanced users:

```bash
./scripts/localctl.sh --help
./scripts/localctl.sh start user@server /path/to/repo --local-port 9090
./scripts/localctl.sh cleanup --all user@server /path/to/repo
```

### Synchronization
The tool automatically stays synchronized with the admin repository. Updates flow through:

```
Admin Repo → Git Submodule → Symlink → Your Environment
                    (git pull and make update pulls latest)
```

## Support

- **Tunnel connection issues:** Check SSH configuration
- **Remote server issues:** Contact your NatMEG administrator
- **Tool issues:** Run `make help` or check documentation files in `.archive/`

## License

See the main NatMEG-BIDSifier repository for license information.
