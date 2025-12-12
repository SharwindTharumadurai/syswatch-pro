#!/bin/bash
set -euo pipefail

APP_DIR="/opt/syswatch-pro"
SERVICE_NAME="syswatch"
VENV="/home/ec2-user/syswatch-pro-venv/bin/activate"

echo "[CI] Starting deployment on $(hostname) at $(date)"

cd "$APP_DIR"

echo "[CI] Pulling latest code..."
git pull origin main

echo "[CI] Activating virtual environment..."
source "$VENV"

echo "[CI] Installing dependencies..."
pip install -r agent/requirements.txt

echo "[CI] Restarting service..."
sudo systemctl restart "$SERVICE_NAME"

echo "[CI] Deployment completed successfully"

