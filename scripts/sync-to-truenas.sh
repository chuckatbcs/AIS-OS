#!/usr/bin/env bash
# sync-to-truenas.sh — Sync local AIS-OS → TrueNAS (source of truth for other agents)
#
# The canonical shared location is:
#   /mnt/Home-Directories/Documents/AI Folder/AIS-OS/
#
# Run by cron every 15 minutes from /home/chuck/AIS-OS/

set -euo pipefail

LOCAL_DIR="/home/chuck/AIS-OS"
TRUENAS_DIR="/mnt/Home-Directories/Documents/AI Folder/AIS-OS"
LOG_FILE="/home/chuck/AIS-OS/sync-truenas.log"

# Ensure TrueNAS mount is alive
if [ ! -d "$TRUENAS_DIR" ]; then
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) ERROR: TrueNAS mount not accessible: $TRUENAS_DIR" >> "$LOG_FILE"
  exit 1
fi

# Exclusions: .git is local-only, sync log is ephemeral
EXCLUDES=(
  --exclude='.git/'
  --exclude='sync-truenas.log'
  --exclude='*.pyc'
  --exclude='__pycache__/'
)

# Push local → TrueNAS (only if local is newer or file doesn't exist on TrueNAS)
rsync -av --update "${EXCLUDES[@]}" "$LOCAL_DIR/" "$TRUENAS_DIR/" >> "$LOG_FILE" 2>&1

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) ✓ Sync complete: $LOCAL_DIR → $TRUENAS_DIR" >> "$LOG_FILE"
