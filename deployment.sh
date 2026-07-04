#!/bin/bash
set -e

# --- Configuration ---
COMPOSE_FILE="docker-compose/docker-compose.yaml"
# Fix: Export the system hostname so Docker Compose can see it
export HOSTNAME=$(hostname)

# --- Helper: Update Sources ---
update_sources() {
    echo "📥 Pulling latest codebase and images..."
    git pull || echo "⚠️  Git pull failed or no changes to pull."
    docker compose -f "$COMPOSE_FILE" pull
}

# --- Logic: Quick Update (Standard Refresh) ---
quick_update() {
    update_sources
    
    echo "🔄 Refreshing containers..."
    # -d runs in background. 
    # Docker Compose automatically recreates containers if the image has changed.
    docker compose -f "$COMPOSE_FILE" up -d
    
    echo "🎉 Quick update complete! Containers are running in the background."
}

# --- Logic: Full (Re)install (Wipe & Restart) ---
full_reinstall() {
    update_sources

    read -p "⚠️  Are you ABSOLUTELY sure? This deletes ALL volume data! (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "🛑 Performing full wipe and restart..."
        docker compose -f "$COMPOSE_FILE" down --volumes --remove-orphans
        docker compose -f "$COMPOSE_FILE" up -d
        echo "🎉 System wiped and restarted fresh."
    else
        echo "❌ Aborted."
    fi
}

# --- Logic: Check Status ---
check_status() {
    docker compose -f "$COMPOSE_FILE" ps
}

# --- MAIN MENU ---
while true; do
    echo ""
    echo "=========================================="
    echo "   🚀 OPEN-WEBUI DEPLOYMENT MANAGER"
    echo "=========================================="
    echo "1) ⚡ Quick Update (Refresh)"
    echo "2) ⚠️  Full (Re)install (Wipe & Restart)"
    echo "3) 📊 Check Status"
    echo "4) 🚪 Exit"
    echo "=========================================="
    read -p "Select an option [1-4]: " choice

    case $choice in
        1) quick_update ;;
        2) full_reinstall ;;
        3) check_status ;;
        4) echo "👋 Goodbye!"; exit 0 ;;
        *) echo "❌ Invalid option." ;;
    esac
done