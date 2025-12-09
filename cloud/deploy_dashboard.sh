#!/bin/bash
set -e

DASHBOARD_NAME="syswatch-pro-dashboard"
DASHBOARD_FILE="dashboard.json"

if [ ! -f "$DASHBOARD_FILE" ]; then
  echo "dashboard.json not found!"
  exit 1
fi

aws cloudwatch put-dashboard \
  --dashboard-name "$DASHBOARD_NAME" \
  --dashboard-body file://"$DASHBOARD_FILE"

echo "Dashboard deployed successfully!"
