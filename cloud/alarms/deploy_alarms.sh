#!/bin/bash
set -e

echo "[syswatch-pro] Deploying CloudWatch alarms..."

aws cloudwatch put-metric-alarm --cli-input-json file://cpu-high.json
aws cloudwatch put-metric-alarm --cli-input-json file://memory-high.json
aws cloudwatch put-metric-alarm --cli-input-json file://disk-high.json

echo "[syswatch-pro] All alarms deployed!"
