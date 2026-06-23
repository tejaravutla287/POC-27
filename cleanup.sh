#!/bin/bash
# --- Resource Configuration ---
ALB_ARN="PASTE_YOUR_ALB_ARN"
TG_BLUE_ARN="PASTE_YOUR_BLUE_TG_ARN"
TG_GREEN_ARN="PASTE_YOUR_GREEN_TG_ARN"
INSTANCE_BLUE="PASTE_YOUR_BLUE_INSTANCE_ID"
INSTANCE_GREEN="PASTE_YOUR_GREEN_INSTANCE_ID"
SG_ID="PASTE_YOUR_SECURITY_GROUP_ID"

echo "💥 Cleaning up temporary testing infrastructure..."
[ "$ALB_ARN" != "PASTE_YOUR_ALB_ARN" ] && aws elbv2 delete-load-balancer --load-balancer-arn "$ALB_ARN" && echo "Deleted ALB." && sleep 15
[ "$TG_BLUE_ARN" != "PASTE_YOUR_BLUE_TG_ARN" ] && aws elbv2 delete-target-group --target-group-arn "$TG_BLUE_ARN"
[ "$TG_GREEN_ARN" != "PASTE_YOUR_GREEN_TG_ARN" ] && aws elbv2 delete-target-group --target-group-arn "$TG_GREEN_ARN" && echo "Deleted target groups."
aws ec2 terminate-instances --instance-ids "$INSTANCE_BLUE" "$INSTANCE_GREEN" && echo "Terminated EC2 instances."
echo "⏳ Waiting for instances to terminate before removing the Security Group..."
aws ec2 wait instance-terminated --instance-ids "$INSTANCE_BLUE" "$INSTANCE_GREEN"
aws ec2 delete-security-group --group-id "$SG_ID" && echo "Deleted Security Group."
echo "🎉 Cleanup finished successfully. Free tier safe."
