#!/bin/bash
set -e

SERVICE_NAME="syswatch"
APP_DIR="/opt/syswatch-pro"
PYTHON_VENV="/home/ec2-user/syswatch-pro-venv"
SYSTEMD_SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

echo "[syswatch-pro] Stopping service..."
sudo systemctl stop ${SERVICE_NAME} || true
sudo systemctl disable ${SERVICE_NAME} || true

echo "[syswatch-pro] Removing systemd service..."
sudo rm -f "${SYSTEMD_SERVICE_PATH}"
sudo systemctl daemon-reload

echo "[syswatch-pro] Removing application directory ${APP_DIR}..."
sudo rm -rf "${APP_DIR}"

echo "[syswatch-pro] Removing Python virtual environment ${PYTHON_VENV}..."
rm -rf "${PYTHON_VENV}"

echo "[syswatch-pro] Uninstallation complete."
