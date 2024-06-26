resource "aws_sns_topic" "NotificationsTopic" {
  name = "${var.service_name}NotificationsTopic-${aws_appconfig_application.AppConfigAgentApplication.id}"

  kms_master_key_id = var.sns_cmk_key_arn

  tags = merge({ (join("-", ["${var.service_name}", "${aws_appconfig_application.AppConfigAgentApplication.id}"])) = "ConsoleSnsTopic" },
    local.common_tags
  )
}

resource "aws_sns_topic_policy" "NotificationsTopicPolicy" {
  arn    = aws_sns_topic.NotificationsTopic.arn
  policy = data.aws_iam_policy_document.TopicPolicyDocument.json
}

data "aws_iam_policy_document" "TopicPolicyDocument" {
  policy_id = "2012-10-17"

  statement {
    actions = ["sns:Publish"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.AgentTaskRole.arn}",
        "${aws_iam_role.ConsoleTaskRole.arn}"
      ]
    }

    resources = [
      aws_sns_topic.NotificationsTopic.arn
    ]

    sid = "2012-10-17"
  }
}

/* https://github.com/hashicorp/terraform-provider-aws/issues/32072
resource "aws_sns_topic_subscription" "health_check_console_alarm_subscription" {
  protocol  = "email-json"
  endpoint  = var.email
  topic_arn = aws_sns_topic.NotificationsTopic.id
  filter_policy = jsonencode({
    "AlarmName" : [aws_cloudwatch_metric_alarm.health_check_console_alarm.arn]
  })
  filter_policy_scope = "MessageBody"
}
*/