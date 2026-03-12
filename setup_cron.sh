#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Setup script: installs the daily 6 AM cron job for auto-scanning
#
# Usage:  ./setup_cron.sh
# Remove: ./setup_cron.sh --remove
# ──────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_CMD="0 6 * * * $SCRIPT_DIR/daily_scan.sh >> $SCRIPT_DIR/cron.log 2>&1"

if [ "${1:-}" = "--remove" ]; then
    crontab -l 2>/dev/null | grep -v "daily_scan.sh" | crontab -
    echo "Cron job removed."
    exit 0
fi

# Add cron job (remove old one first to avoid duplicates)
(crontab -l 2>/dev/null | grep -v "daily_scan.sh"; echo "$CRON_CMD") | crontab -

echo "Cron job installed! The scanner will run daily at 6:00 AM."
echo ""
echo "Verify with:  crontab -l"
echo "Remove with:  $0 --remove"
echo ""
echo "Workflow:"
echo "  1. Drop business card photos into: $SCRIPT_DIR/new/"
echo "  2. At 6 AM daily, photos are scanned and added to contractors.xlsx"
echo "  3. Processed photos are moved to: $SCRIPT_DIR/scanned/"
