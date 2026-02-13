# Installation Guide for Administrators

This guide explains how to set up and distribute the NatMEG-BIDSifier user repository.

## For System Administrators

### Option 1: Direct Distribution

1. **Create the user repository** (if not already done):
   ```bash
   git clone git@github.com:k-CIR/NatMEG-BIDSifier.git
   cd NatMEG-BIDSifier
   ```

2. **Share with users:**
   ```bash
   # Via GitHub (recommended)
   # Users clone directly from GitHub
   
   # Or via shared filesystem
   cp -r NatMEG-BIDSifier /shared/applications/
   ```

### Option 2: Create a Wrapper Script

For completely hands-off setup, provide users with a single bootstrap script:

**File: `download-natmeg.sh`**
```bash
#!/bin/bash
git clone git@github.com:k-CIR/NatMEG-BIDSifier.git
cd NatMEG-BIDSifier
make setup
make ui
```

Users just run:
```bash
bash download-natmeg.sh
```

### Option 3: Container/Module Loading

If your cluster uses modules:

```bash
# Create a modulefiles entry
module load natmeg-tunnel/1.0
# Which would set up PATH and run the UI
```

## For End Users

### Quick Setup Instructions

**Step 1: Get the Repository**
```bash
# Option A: From GitHub
git clone git@github.com:k-CIR/NatMEG-BIDSifier.git
cd NatMEG-BIDSifier

# Option B: From shared location
cp -r /path/to/NatMEG-BIDSifier .
cd NatMEG-BIDSifier
```

**Step 2: Initialize**
```bash
make setup
```

When prompted, provide:
- SSH target: `youruser@compute.example.com`
- Remote repo: `/data/users/natmeg/scripts/NatMEG-BIDSifier` (or press Enter)
- Local port: `8080` (or press Enter)

**Step 3: Start Using**
```bash
make ui              # Interactive menu
# OR
make start           # Direct start
```

## Updating

Users can get the latest `localctl.sh` anytime:
```bash
make update
```

This pulls the latest from the admin repository automatically.

## Managing Multiple Users

### For a Shared Lab Machine

1. Install in `/opt/` or `/usr/local/`:
   ```bash
   sudo git clone git@github.com:k-CIR/NatMEG-BIDSifier.git /opt/natmeg-tunnel
   sudo chmod 777 /opt/natmeg-tunnel/.config
   ```

2. Each user creates their own config:
   ```bash
   cd /opt/natmeg-tunnel
   make setup
   ```

### For Individual Machines

Each user:
```bash
cd ~/projects/
git clone git@github.com:k-CIR/NatMEG-BIDSifier.git
cd NatMEG-BIDSifier
make setup
```

## Keeping Admin and User Repos In Sync

The submodule automatically tracks the admin repo's `main` branch.

**For admin repo changes:**
1. Update `scripts/localctl.sh` in the admin repo (NatMEG-BIDSifier-admin)
2. Commit and push to GitHub
3. Users run `make update` to get the latest

**For bulk user updates:**
```bash
# For each user machine
cd NatMEG-BIDSifier
git pull origin main
git submodule update --remote
```

## Troubleshooting

### "git submodule not found"
Run: `git submodule update --init --recursive`

### "localctl.sh not found"
Run: `make setup` to reinitialize

### "Permission denied" on symlink
The symlink should work on all systems. If not:
```bash
cd scripts
rm localctl.sh
cp ../shared/admin/scripts/localctl.sh ./
```

### Users can't update to latest
```bash
cd NatMEG-BIDSifier
git pull origin main
git submodule update --remote
```

## File Summary

| File | Purpose |
|------|---------|
| `localctl-ui.sh` | Interactive menu wrapper |
| `setup.sh` | First-time initialization |
| `Makefile` | Command shortcuts |
| `scripts/localctl.sh` | Symlink to admin's version |
| `shared/admin/` | Synced admin repo (submodule) |
| `.config/settings` | User's configuration (created during setup) |
| `README.md` | User documentation |
| `QUICKSTART.md` | Quick reference |

## Support

- **For users:** See README.md and QUICKSTART.md
- **For admins:** See this file
- **For bugs:** Report to the admin repo: https://github.com/k-CIR/NatMEG-BIDSifier/issues
