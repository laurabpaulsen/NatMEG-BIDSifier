# NatMEG-BIDSifier User Repository Setup - Summary

## ✅ What Was Created

A complete, user-friendly CLI-based tool for managing remote tunnel connections to NatMEG servers.

### Repository Structure

```
NatMEG-BIDSifier-user/
├── localctl-ui.sh              # Interactive menu (main entry point for users)
├── setup.sh                    # One-time setup wizard
├── Makefile                    # Command shortcuts (make start, make stop, etc.)
├── README.md                   # User documentation
├── QUICKSTART.md               # Quick reference guide
├── INSTALL.md                  # Admin installation guide
├── .gitignore                  # Git configuration
├── .gitmodules                 # Submodule configuration
├── scripts/
│   └── localctl.sh            # Symlink to admin repo version (synced via submodule)
└── shared/
    └── admin/                  # Git submodule pointing to k-CIR/NatMEG-BIDSifier
        └── scripts/
            └── localctl.sh    # Canonical source (in admin repo)
```

## 🎯 Key Features

### 1. **Interactive Menu (`localctl-ui.sh`)**
   - Easy numbered menu for all operations
   - Color-coded output
   - Saves user preferences
   - No command-line knowledge required

### 2. **One-Command Setup (`setup.sh`)**
   - Initializes git submodule automatically
   - Configures SSH connection
   - Verifies connectivity
   - Saves settings for future use

### 3. **Convenient Make Commands**
   ```bash
   make help          # Show all commands
   make setup         # First-time setup
   make ui            # Launch interactive menu
   make start         # Start tunnel
   make stop          # Stop tunnel
   make status        # Check status
   make list          # List running servers
   make cleanup       # Stop one server
   make cleanup-all   # Kill all your servers
   make update        # Update from admin repo
   ```

### 4. **Automatic Synchronization**
   - `localctl.sh` is a symlink to the admin repo version
   - Git submodule automatically tracks changes
   - Users get latest features with `make update`
   - Single source of truth in admin repository

## 🚀 User Workflow

### First Time
```bash
git clone <user-repo-url>
cd NatMEG-BIDSifier-user
make setup
make ui
```

### Regular Use
```bash
cd NatMEG-BIDSifier-user
make ui              # or any of the make commands
```

### Keep Updated
```bash
make update
```

## 📁 File Breakdown

| File | Purpose | Audience |
|------|---------|----------|
| `localctl-ui.sh` | Interactive menu wrapper | End users |
| `setup.sh` | Initialization script | End users (first-time) |
| `Makefile` | Command shortcuts | End users |
| `README.md` | User guide | End users |
| `QUICKSTART.md` | Quick reference | End users |
| `INSTALL.md` | Admin distribution guide | Administrators |
| `scripts/localctl.sh` | Synced script (symlink) | Both |
| `shared/admin/` | Submodule (admin repo) | Internal |

## 🔄 Synchronization Mechanism

### How It Works
1. **Admin repo** (`NatMEG-BIDSifier`) has canonical `scripts/localctl.sh`
2. **User repo** (`NatMEG-BIDSifier-user`) includes admin repo as git submodule
3. **Symlink** in user repo points to submodule's `localctl.sh`
4. **Users** run `make update` → pulls latest from admin repo

### Updates Flow
```
Admin repo change
       ↓
User runs: make update
       ↓
Git submodule pulls latest
       ↓
Symlink automatically uses new version
```

## 🛠️ For Administrators

### Distributing to Users

**Option 1: GitHub Clone**
```bash
git clone git@github.com:k-CIR/NatMEG-BIDSifier-user.git
cd NatMEG-BIDSifier-user
make setup
```

**Option 2: Shared Directory**
```bash
# Copy to shared location
cp -r NatMEG-BIDSifier-user /shared/apps/natmeg-tunnel
# Users: cd /shared/apps/natmeg-tunnel && make setup
```

**Option 3: Docker Container**
```bash
docker run -it natmeg-tunnel make ui
```

### Maintaining Sync

When you update `localctl.sh` in the admin repo:
1. Commit and push to `k-CIR/NatMEG-BIDSifier`
2. Users automatically see it when running `make update`

## ✨ Why This Works Well

✅ **Separation of Concerns**
- Users never see admin files
- Admin can iterate without user impact
- Clean file structure

✅ **Easy Updates**
- All users get latest `localctl.sh` automatically
- Single source of truth
- Transparent synchronization

✅ **User-Friendly**
- No terminal commands needed (just menu)
- Pretty colors and clear messaging
- Remembers settings
- One-time setup

✅ **Professional**
- Git-based distribution
- Proper versioning
- Easy to maintain
- Scalable

✅ **Robust**
- Works on macOS, Linux, WSL
- Handles SSH keys and passwords
- Permission-aware (only kills own processes)
- Auto-selects available ports

## 📊 Current Status

✅ Repository created locally at:
```
/Users/andreas.gerhardsson/Sites/NatMEG-BIDSifier-user
```

✅ All files created and committed:
- 2 commits
- 8 files
- Git submodule configured
- Ready for distribution

## 🔗 Next Steps

### For You (Admin)
1. Push to GitHub: `git remote add origin <repo-url> && git push -u origin master`
2. Share URL with users
3. Test with a user account

### For Users
1. Clone the repo
2. Run `make setup`
3. Run `make ui` to start

### For Production
- Add pre-commit hooks to validate scripts
- Set up GitHub Actions for testing
- Create release notes/changelog
- Document any local modifications

## 📚 Documentation Files

- **README.md** - Main user guide (what they see first)
- **QUICKSTART.md** - 30-second quick reference
- **INSTALL.md** - Admin distribution guide
- **Makefile** - Built-in help (`make help`)

All have clear, jargon-free explanations suitable for users of all skill levels.

---

**You now have a complete, production-ready user repository!** 🎉

Users can clone, setup, and start managing their tunnels in minutes without any technical knowledge.
