![CI](https://github.com/SharwindTharumadurai/syswatch-pro/actions/workflows/deploy.yml/badge.svg)

# syswatch-pro

Production-grade EC2 monitoring agent built with Python, CloudWatch, and Bash.
Includes automated CI/CD deployment using GitHub Actions and AWS SSM (no SSH).

## 🔧 Features
- Collects CPU, memory, and disk metrics
- Pushes custom metrics to Amazon CloudWatch
- Runs as a systemd service on EC2
- CloudWatch dashboards and alarms
- Automated remediation via SSM
- CI/CD deployment via GitHub Actions (SSM-based)

## 🏗 Architecture
![Architecture](architecture-diagram.png)

## 🚀 CI/CD
- Triggered on every push to `main`
- GitHub Actions → AWS SSM RunCommand
- EC2 pulls latest code and restarts service
- No SSH keys, no inbound access

## 📌 Status
This project is actively maintained and deployed automatically.
