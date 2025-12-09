#!/bin/bash
set -e

TOPIC_NAME="syswatch-alerts"

TOPIC_ARN=$(aws sns list-topics --query "Topics[?contains(TopicArn, '${TOPIC_NAME}')].TopicArn" --output text)

if [ -z "$TOPIC_ARN" ]; then
  echo "Topic not found!"
  exit 1
fi

aws sns publish \
  --topic-arn "$TOPIC_ARN" \
  --subject "syswatch-pro manual test alert" \
  --message "This is a test alert from syswatch-pro."
