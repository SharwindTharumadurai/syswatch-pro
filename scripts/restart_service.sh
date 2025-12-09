#!/bin/bash
set -e

SERVICE_NAME="syswatch"

echo "[syswatch-pro] Restarting ${SERVICE_NAME} service..."
sudo systemctl restart ${SERVICE_NAME}
sudo systemctl status ${SERVICE_NAME} --no-pager
