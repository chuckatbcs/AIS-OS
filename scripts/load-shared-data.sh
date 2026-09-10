#!/bin/bash
# load-shared-data.sh — Run at harness startup to ensure shared data is accessible
# Uses rsync (not symlinks) since TrueNAS SMB share doesn't support symlinks

TRUENAS_DIR="/mnt/Home-Directories/Documents/AI Folder/AIS-OS"
LOCAL_DIR="/home/chuck/AIS-OS"
ERRORS=()

echo "🔄 Loading shared AIS-OS data..."

# Ensure TrueNAS directory exists
if [ ! -d "$TRUENAS_DIR" ]; then
  ERRORS+=("❌ TrueNAS AIS-OS directory not found: $TRUENAS_DIR")
fi

# Sync each critical file from TrueNAS to local (TrueNAS is the source of truth)
CRITICAL_FILES=(
  "references/3ms-framework.md"
  "references/voice.md" 
  "references/email-api.md"
  "references/kanban-board.md"
  "decisions/log.md"
  "connections.md"
  "aios-intake.md"
)

for f in "${CRITICAL_FILES[@]}"; do
  truenas_path="$TRUENAS_DIR/$f"
  local_path="$LOCAL_DIR/$f"
  
  if [ ! -e "$truenas_path" ]; then
    ERRORS+=("❌ TrueNAS source missing: $f")
    continue
  fi
  
  # If local doesn't exist OR TrueNAS is newer, sync TrueNAS → local
  if [ ! -e "$local_path" ] || [ "$truenas_path" -nt "$local_path" ]; then
    rsync -av "$truenas_path" "$local_path"
    DIRECTION="↻ TrueNAS → local"
  else
    DIRECTION="✓ local up to date"
  fi
  echo "   $DIRECTION $f"
done

# Report
echo ""
ERROR_COUNT=${#ERRORS[@]}
if [ $ERROR_COUNT -gt 0 ]; then
  for e in "${ERRORS[@]}"; do
    echo "$e"
  done
  echo ""
  echo "⚠️  Shared data load completed with $ERROR_COUNT error(s)"
  exit 1
else
  echo "✅ Shared data loaded successfully"
  echo "   • $(ls "$LOCAL_DIR/references/" | wc -l) reference files ready"
  echo "   • $(wc -l < "$LOCAL_DIR/decisions/log.md") decisions logged"
  echo "   • connections.md ready (domain registry: $(grep -c '|' "$LOCAL_DIR/connections.md") domains)"
  exit 0
fi
