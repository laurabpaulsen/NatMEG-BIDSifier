# Quick Start Guide

## 30-Second Setup

```bash
# 1. Clone and setup
git clone <repo-url>
cd NatMEG-BIDSifier
make setup

# 2. Launch (choose one)
make ui              # Interactive menu
# or
make start           # Direct start
```

## Common Tasks

### First Time: Connect to Server
```bash
make ui
# Choose option 1: Start
# Browser opens automatically
```

### Check What's Running
```bash
make list
```

### Stop Everything
```bash
make cleanup-all
# Confirms before deleting
```

### Just Stop the Tunnel (Keep Server Running)
```bash
make stop
```

## Need Help?

| Problem | Solution |
|---------|----------|
| SSH connection fails | Run `make setup` to reconfigure |
| Port already in use | Script auto-picks another port |
| Want to change server | Edit `.config/settings` or `make setup` |
| Want latest version | Run `make update` |

## Pro Tips

1. **Bookmarks:** After `make start`, the URL is `http://localhost:PORT`
2. **Settings:** Saved in `.config/settings` - edit directly if needed
3. **SSH Keys:** Use passwordless SSH for smooth experience
4. **Auto-start:** Run `make start` in a cron job or startup script

That's it! You're ready to go. 🚀
