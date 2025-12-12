#!/bin/bash
set -e

TOPIC_NAME="syswatch-alerts"
EMAIL="sharwindtharuma@gmail.com"

echo "Creating SNS Topic: $TOPIC_NAME"

TOPIC_ARN=$(aws sns create-topic --name "$TOPIC_NAME" --query 'TopicArn' --output text)
echo "Topic ARN: $TOPIC_ARN"

echo "Creating email subscription..."
aws sns subscribe \
  --topic-arn "$TOPIC_ARN" \
  --protocol email \
  --notification-endpoint "$EMAIL"

echo "SNS setup complete. Check your email to confirm subscription!"
