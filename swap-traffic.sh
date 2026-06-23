#!/bin/bash
# --- Config (Paste your AWS Details Here) ---
LISTENER_ARN="PASTE_YOUR_HTTP_LISTENER_ARN_HERE"
TARGET_TG_ARN="PASTE_YOUR_GREEN_TARGET_GROUP_ARN_HERE"

echo "🔀 Swapping traffic directly to the new deployment group..."
aws elbv2 modify-listener \
    --listener-arn "$LISTENER_ARN" \
    --default-actions Type=forward,TargetGroupArn="$TARGET_TG_ARN"

echo "✅ Traffic shifted successfully. Refresh your browser to verify!"
