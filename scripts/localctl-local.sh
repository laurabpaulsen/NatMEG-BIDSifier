#!/usr/bin/env bash
# Local mode runner - starts NatMEG BIDSifier application locally without SSH tunneling
# Usage: ./scripts/localctl-local.sh [start|stop|status] [--local-port N]

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
USER_RUNTIME_DIR="$REPO_ROOT/.connect_logs"
mkdir -p "$USER_RUNTIME_DIR/local"
PIDFILE="$USER_RUNTIME_DIR/local/.app.pid"
PORTFILE="$USER_RUNTIME_DIR/local/.app.port"
LOGFILE="$USER_RUNTIME_DIR/local/.app.log"

LOCAL_PORT=8080
APP_DIR="$REPO_ROOT/shared/admin/server"

usage(){
  cat <<EOF
Usage: $0 [start|stop|status] [--local-port N]

Commands:
  start   - Start the NatMEG BIDSifier application locally
  stop    - Stop the running application
  status  - Check application status

Flags:
  --local-port N    - Port to listen on (defaults to 8080)

The application will be started from: $APP_DIR
EOF
  exit 2
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then usage; fi

# Parse command first
cmd="start"
if [[ ${1:-} =~ ^(start|stop|status)$ ]]; then
  cmd="$1"
  shift || true
fi

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local-port)
      LOCAL_PORT="$2"; shift 2;;
    -*|--*)
      echo "Unknown flag: $1"; usage;;
    *)
      shift;;
  esac
done

case "$cmd" in
  start)
    echo "Starting NatMEG BIDSifier application..."
    echo
    
    # Check if Python and uvicorn are available
    if ! command -v python3 &> /dev/null; then
      echo "✗ Error: python3 is required but not installed"
      exit 1
    fi
    
    # Check if app directory exists
    if [[ ! -d "$APP_DIR" ]]; then
      echo "✗ Error: Application not found at $APP_DIR"
      echo "Make sure shared/admin submodule is initialized: git submodule update --init"
      exit 1
    fi
    
    # Check if dependencies are installed
    if ! python3 -c "import uvicorn" 2>/dev/null; then
      echo "Installing required dependencies..."
      
      # Try multiple installation methods
      if python3 -m pip install --break-system-packages -q -r "$REPO_ROOT/shared/admin/requirements.txt" 2>/dev/null; then
        true
      elif python3 -m pip install --user -q -r "$REPO_ROOT/shared/admin/requirements.txt" 2>/dev/null; then
        true
      else
        echo "✗ Failed to install dependencies automatically"
        echo
        echo "Please install dependencies manually:"
        echo "  python3 -m pip install --break-system-packages -r $REPO_ROOT/shared/admin/requirements.txt"
        echo
        echo "Or use a virtual environment:"
        echo "  python3 -m venv .venv"
        echo "  source .venv/bin/activate"
        echo "  pip install -r $REPO_ROOT/shared/admin/requirements.txt"
        exit 1
      fi
      echo "✓ Dependencies installed"
      echo
    fi
    
    # Save port information
    echo "$LOCAL_PORT" > "$PORTFILE"
    
    # Kill any existing process on this port
    if [[ -f "$PIDFILE" ]]; then
      old_pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
      if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null; then
        echo "Stopping previous instance (PID: $old_pid)..."
        kill "$old_pid" 2>/dev/null || true
        sleep 1
      fi
    fi
    
    # Start the app in background from the server directory
    # Explicitly pass LOCAL_MODE environment variable to enable local-only file access
    cd "$APP_DIR"
    LOCAL_MODE="${LOCAL_MODE:-1}" python3 -m uvicorn app:app --host localhost --port "$LOCAL_PORT" > "$LOGFILE" 2>&1 &
    NEW_PID=$!
    
    # Save PID
    echo "$NEW_PID" > "$PIDFILE"
    
    # Give server time to start
    sleep 2
    
    # Check if server started successfully
    if ! kill -0 "$NEW_PID" 2>/dev/null; then
      echo "✗ Failed to start application. Check log:"
      cat "$LOGFILE"
      exit 1
    fi
    
    echo "✓ Application started successfully (PID: $NEW_PID)"
    echo
    echo "Access the application at: http://localhost:$LOCAL_PORT"
    echo
    echo "Server output logged to: $LOGFILE"
    echo "Use 'make local-stop' to stop the application"
    
    # Auto-open browser if running locally (cross-platform: macOS, Linux, Windows/Git Bash)
    # Skip if $DISPLAY is not set (no X server, e.g., SSH session without X11 forwarding)
    if [[ -z "${DISPLAY:-}" ]]; then
      echo "No X server found (\$DISPLAY not set); skipping browser auto-open"
    else
      sleep 1  # give server a moment to stabilize
      if command -v open >/dev/null 2>&1; then
        # macOS
        open "http://localhost:$LOCAL_PORT"
      elif command -v xdg-open >/dev/null 2>&1; then
        # Linux
        xdg-open "http://localhost:$LOCAL_PORT" >/dev/null 2>&1 &
      elif command -v start >/dev/null 2>&1; then
        # Windows/Git Bash
        start "http://localhost:$LOCAL_PORT"
      fi
    fi
    ;;
    
  stop)
    if [[ -f "$PIDFILE" ]]; then
      pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
      if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        echo "Stopping application (PID: $pid)..."
        kill "$pid" 2>/dev/null || true
        rm -f "$PIDFILE"
        sleep 1
        echo "✓ Application stopped"
      else
        echo "✗ Application not running (stale PID file)"
        rm -f "$PIDFILE"
      fi
    else
      echo "✗ Application not running (no PID file found)"
    fi
    rm -f "$PORTFILE"
    ;;
    
  status)
    if [[ -f "$PORTFILE" ]]; then
      port=$(cat "$PORTFILE")
      echo "Application configured to use port: $port"
      echo
      
      if [[ -f "$PIDFILE" ]]; then
        pid=$(cat "$PIDFILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
          echo "✓ Application is running (PID: $pid)"
          
          # Try to ping the API
          if command -v curl &> /dev/null; then
            if curl -s "http://localhost:$port/api/ping" > /dev/null 2>&1; then
              echo "✓ API is responding at http://localhost:$port"
            else
              echo "⚠ Process running but API not responding yet"
              echo "  Try accessing http://localhost:$port in a moment"
            fi
          else
            echo "Access the application at: http://localhost:$port"
          fi
        else
          echo "⚠ PID file exists but process is not running"
          echo "  Run 'make local-start' to restart"
        fi
      else
        echo "⚠ Application not running"
        echo "  Run 'make local-start' to start"
      fi
    else
      echo "⚠ Local mode not initialized"
      echo "  Run 'make local-start' first"
    fi
    
    if [[ -f "$LOGFILE" ]]; then
      echo
      echo "Recent log entries:"
      tail -5 "$LOGFILE"
    fi
    ;;
    
  *)
    echo "Unknown command: $cmd"
    usage
    ;;
esac
