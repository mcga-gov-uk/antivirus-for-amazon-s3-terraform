output "ConsoleWebAddress" {
  description = "Public DNS address of Console Web Interface"
  sensitive   = false
  value       = "${var.configure_load_balancer}" ? null : "https://${local.aws_account}-${aws_appconfig_application.AppConfigAgentApplication.id}.cloudstoragesecapp.com"
}

output "LBWebAddress" {
  description = "Public DNS address of Console Web Interface"
  value       = "${var.configure_load_balancer}" ? ["https://${aws_lb.LoadBalancer[0].dns_name}"] : null
}

output "Username" {
  description = "User Name used to log in to console"
  value       = var.username
}

output "Password" {
  description = "Temporary password used to log in to console"
  value       = "Password was emailed to ${var.email}"
}

output "ProactiveNotificationsTopicArn" {
  description = "ARN for the proactive notifications topic"
  value       = aws_sns_topic.NotificationsTopic.arn
}
