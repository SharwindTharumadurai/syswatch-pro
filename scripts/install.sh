#!/bin/bash
set -e

SERVICE_NAME="syswatch"
APP_DIR="/opt/syswatch-pro"
REPO_URL="https://github.com/SharwindTharumadurai/syswatch-pro"
EC2_USER="ec2-user"
PYTHON_VENV="/home/${EC2_USER}/syswatch-pro-venv"
SYSTEMD_SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

echo "[syswatch-pro] Starting installation..."

# 1) Update system packages
echo "[syswatch-pro] Updating system packages..."
sudo yum update -y

# 2) Install dependencies
echo "[syswatch-pro] Installing Python3, Git..."
sudo yum install -y python3 git

# 3) Create Python virtual environment (in home directory)
if [ ! -d "$PYTHON_VENV" ]; then
  echo "[syswatch-pro] Creating Python virtual environment at ${PYTHON_VENV}..."
  python3 -m venv "$PYTHON_VENV"
fi

# 4) Activate venv and install Python requirements
echo "[syswatch-pro] Installing Python dependencies..."
source "${PYTHON_VENV}/bin/activate"

# If repo already cloned in /tmp, remove it
TMP_DIR="/tmp/syswatch-pro"
rm -rf "$TMP_DIR"

echo "[syswatch-pro] Cloning repository from ${REPO_URL}..."
git clone "$REPO_URL" "$TMP_DIR"

# Install requirements
pip install -r "${TMP_DIR}/agent/requirements.txt"

# 5) Copy project to /opt/syswatch-pro
echo "[syswatch-pro] Installing application to ${APP_DIR}..."
sudo rm -rf "$APP_DIR"
sudo mkdir -p "$APP_DIR"
sudo cp -r "$TMP_DIR"/* "$APP_DIR"

# Fix permissions
echo "[syswatch-pro] Setting permissions..."
sudo chown -R "${EC2_USER}:${EC2_USER}" "$APP_DIR"

# 6) Create systemd service file
echo "[syswatch-pro] Creating systemd service at ${SYSTEMD_SERVICE_PATH}..."

sudo bash -c "cat > ${SYSTEMD_SERVICE_PATH}" <<EOF
[Unit]
Description=syswatch-pro monitoring agent
After=network.target

[Service]
Type=simple
ExecStart=${PYTHON_VENV}/bin/python ${APP_DIR}/agent/syswatch.py
WorkingDirectory=${APP_DIR}
Restart=always
User=${EC2_USER}
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

# 7) Reload systemd and start service
echo "[syswatch-pro] Reloading systemd..."
sudo systemctl daemon-reload

echo "[syswatch-pro] Enabling service on boot..."
sudo systemctl enable ${SERVICE_NAME}

echo "[syswatch-pro] Starting service..."
sudo systemctl restart ${SERVICE_NAME}

echo "[syswatch-pro] Installation complete!"
sudo systemctl status ${SERVICE_NAME} --no-pager
