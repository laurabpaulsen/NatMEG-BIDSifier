.PHONY: setup ui start stop status list cleanup cleanup-all update local-start local-stop local-status help

SCRIPT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
LOCALCTL := $(SCRIPT_DIR)/scripts/localctl.sh
LOCALCTL_LOCAL := $(SCRIPT_DIR)/scripts/localctl-local.sh
UI := $(SCRIPT_DIR)/localctl-ui.sh

help:
	@echo "NatMEG BIDSifier User Edition"
	@echo "============================="
	@echo ""
	@echo "Available commands:"
	@echo "  make setup        - Initialize and configure (run first!)"
	@echo "  make ui           - Launch interactive menu (detects your configured mode)"
	@echo ""
	@echo "Remote Mode (SSH Tunnel):"
	@echo "  make start        - Start tunnel to remote server"
	@echo "  make stop         - Stop tunnel"
	@echo "  make status       - Check tunnel status"
	@echo "  make list         - List running servers"
	@echo "  make cleanup      - Stop a specific server by port"
	@echo "  make cleanup-all  - Kill ALL your servers"
	@echo ""
	@echo "Local Mode (No SSH):"
	@echo "  make local-start  - Initialize local mode"
	@echo "  make local-stop   - Stop local mode"
	@echo "  make local-status - Check local mode status"
	@echo ""
	@echo "  make update       - Update localctl.sh from admin repo"
	@echo "  make help         - Show this help message"

setup:
	@./setup.sh

ui:
	@$(UI)

start:
	@$(LOCALCTL) start

stop:
	@$(LOCALCTL) stop

status:
	@$(LOCALCTL) status

list:
	@$(LOCALCTL) list

cleanup:
	@$(LOCALCTL) cleanup

cleanup-all:
	@$(LOCALCTL) cleanup --all

local-start:
	@$(LOCALCTL_LOCAL) start

local-stop:
	@$(LOCALCTL_LOCAL) stop

local-status:
	@$(LOCALCTL_LOCAL) status

update:
	@echo "Updating from admin repository..."
	@git submodule update --remote
	@echo "✓ Updated localctl.sh"

.DEFAULT_GOAL := help
