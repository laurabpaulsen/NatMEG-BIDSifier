# Test Checklist

Run these commands to verify the setup works:

## 1. Check Make Commands
```bash
make help
# Expected: Shows 10 commands with descriptions
```

## 2. Verify localctl.sh Symlink
```bash
./scripts/localctl.sh --help | head -5
# Expected: Shows usage information
```

## 3. Check UI Script
```bash
file localctl-ui.sh
# Expected: executable shell script
```

## 4. Verify Setup Script
```bash
./setup.sh
# Expected: Interactive setup (can cancel with Ctrl+C)
```

## 5. Git Status
```bash
git status
# Expected: clean working directory
```

## 6. Submodule Check
```bash
ls -la scripts/localctl.sh
# Expected: symbolic link to ../shared/admin/scripts/localctl.sh
```

## 7. Configuration
```bash
make setup
# Then edit .config/settings manually if needed
cat .config/settings
```

All tests pass? You're ready to distribute! ✅
