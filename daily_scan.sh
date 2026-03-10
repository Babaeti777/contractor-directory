#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Daily Contractor Photo Scanner
# Runs auto_scan.py to process images in the "new" folder,
# updates contractors.xlsx, then moves scanned photos to "scanned".
#
# Schedule with cron (runs every day at 6 AM):
#   crontab -e
#   0 6 * * * /home/user/contractor-directory/daily_scan.sh >> /home/user/contractor-directory/cron.log 2>&1
# ──────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NEW_DIR="$SCRIPT_DIR/new"
SCANNED_DIR="$SCRIPT_DIR/scanned"
EXCEL_FILE="$SCRIPT_DIR/contractors.xlsx"
LOG_FILE="$SCRIPT_DIR/cron.log"

echo "────────────────────────────────────────"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Daily scan started"

# Ensure folders exist
mkdir -p "$NEW_DIR" "$SCANNED_DIR"

# Count images waiting
IMG_COUNT=$(find "$NEW_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.tif' -o -iname '*.webp' -o -iname '*.heic' \) 2>/dev/null | wc -l)

if [ "$IMG_COUNT" -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No new images found in $NEW_DIR. Skipping."
    exit 0
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Found $IMG_COUNT new image(s) to process"

# Run the scanner
python3 "$SCRIPT_DIR/auto_scan.py" \
    --folder "$NEW_DIR" \
    --scanned "$SCANNED_DIR" \
    --excel "$EXCEL_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Daily scan completed"
