#!/usr/bin/env bash
# Interactive CLI wrapper for NatMEG localctl tunnel management
# User-friendly menu interface with color output

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCALCTL="$SCRIPT_DIR/scripts/localctl.sh"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if localctl.sh exists
if [[ ! -f "$LOCALCTL" ]]; then
  echo -e "${RED}Error: localctl.sh not found at $LOCALCTL${NC}"
  echo "Please run 'make setup' first to initialize the submodule."
  exit 1
fi

show_menu() {
  clear
  echo -e "${BOLD}╔════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}║  NatMEG Tunnel Manager${NC}"
  echo -e "${BOLD}╚════════════════════════════════════════╝${NC}"
  echo
  echo -e "${BLUE}What would you like to do?${NC}"
  echo
  echo "  1) ${GREEN}Start${NC}    - Launch remote server and create SSH tunnel"
  echo "  2) ${YELLOW}Status${NC}   - Check tunnel and server status"
  echo "  3) ${YELLOW}Stop${NC}     - Stop tunnel (optionally stop server)"
  echo "  4) ${YELLOW}List${NC}     - List all running servers"
  echo "  5) ${RED}Cleanup${NC}  - Stop a specific server by port"
  echo "  6) ${RED}Cleanup All${NC} - Kill ALL your servers and clean up"
  echo "  7) ${BLUE}Settings${NC} - Configure remote server"
  echo "  0) ${RED}Exit${NC}"
  echo
}

show_settings() {
  clear
  echo -e "${BOLD}Settings${NC}"
  echo
  echo "SSH Target (user@host):"
  read -rp "  > " ssh_target
  echo
  echo "Remote Repository Path:"
  read -rp "  > " remote_repo
  echo
  echo "Local Port (default 8080):"
  read -rp "  > " local_port
  local_port=${local_port:-8080}
  
  # Save settings for next run
  mkdir -p "$SCRIPT_DIR/.config"
  cat > "$SCRIPT_DIR/.config/settings" <<EOF
SSH_TARGET="$ssh_target"
REMOTE_REPO="$remote_repo"
LOCAL_PORT="$local_port"
EOF
  
  echo -e "${GREEN}✓ Settings saved${NC}"
  read -rp "Press Enter to continue..."
}

load_settings() {
  if [[ -f "$SCRIPT_DIR/.config/settings" ]]; then
    source "$SCRIPT_DIR/.config/settings"
  fi
}

run_start() {
  echo -e "${BLUE}Starting tunnel...${NC}"
  echo
  
  local args=""
  [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
  [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
  [[ -n "${LOCAL_PORT:-}" ]] && args="$args --local-port $LOCAL_PORT"
  
  if "$LOCALCTL" start $args; then
    echo
    echo -e "${GREEN}✓ Tunnel started successfully!${NC}"
    echo "Check your browser at http://localhost:${LOCAL_PORT:-8080}"
  else
    echo -e "${RED}✗ Failed to start tunnel${NC}"
  fi
  
  read -rp "Press Enter to continue..."
}

run_status() {
  echo -e "${BLUE}Checking tunnel status...${NC}"
  echo
  
  local args=""
  [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
  [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
  
  "$LOCALCTL" status $args || true
  
  echo
  read -rp "Press Enter to continue..."
}

run_stop() {
  echo -e "${YELLOW}Stopping tunnel...${NC}"
  echo
  
  local args=""
  [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
  [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
  
  "$LOCALCTL" stop $args || true
  
  echo
  read -rp "Press Enter to continue..."
}

run_list() {
  echo -e "${BLUE}Listing running servers...${NC}"
  echo
  
  local args=""
  [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
  [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
  
  "$LOCALCTL" list $args || true
  
  echo
  read -rp "Press Enter to continue..."
}

run_cleanup() {
  echo -e "${YELLOW}Cleanup a specific server by port${NC}"
  echo
  
  local args=""
  [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
  [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
  
  "$LOCALCTL" cleanup $args || true
  
  echo
  read -rp "Press Enter to continue..."
}

run_cleanup_all() {
  echo -e "${RED}${BOLD}WARNING: This will kill ALL your running servers!${NC}"
  echo
  read -rp "Are you sure? (yes/no): " confirm
  
  if [[ "$confirm" == "yes" ]]; then
    echo -e "${YELLOW}Cleaning up all servers...${NC}"
    echo
    
    local args="--all"
    [[ -n "${SSH_TARGET:-}" ]] && args="$args $SSH_TARGET"
    [[ -n "${REMOTE_REPO:-}" ]] && args="$args $REMOTE_REPO"
    
    if "$LOCALCTL" cleanup $args; then
      echo
      echo -e "${GREEN}✓ All servers cleaned up${NC}"
    else
      echo
      echo -e "${RED}✗ Cleanup encountered issues${NC}"
    fi
  else
    echo -e "${YELLOW}Cleanup cancelled${NC}"
  fi
  
  echo
  read -rp "Press Enter to continue..."
}

# Main loop
load_settings

while true; do
  show_menu
  read -rp "Enter your choice (0-7): " choice
  
  case "$choice" in
    1) run_start ;;
    2) run_status ;;
    3) run_stop ;;
    4) run_list ;;
    5) run_cleanup ;;
    6) run_cleanup_all ;;
    7) show_settings; load_settings ;;
    0) 
      clear
      echo -e "${GREEN}Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid choice. Press Enter to try again.${NC}"
      read -rp ""
      ;;
  esac
done
