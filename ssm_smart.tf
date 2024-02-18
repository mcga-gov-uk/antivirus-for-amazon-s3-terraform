resource "aws_secretsmanager_secret" "css_password" {
  name                    = "${local.environment}/css/password"
  description             = "password for cloudstoragesecapp"
  recovery_window_in_days = 0
  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}/css/password"
    }
  )
}

resource "aws_secretsmanager_secret_version" "css_password" {
  secret_id     = aws_secretsmanager_secret.css_password.id
  secret_string = "dummy"
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_ssm_parameter" "css_token_url" {
  name           = "/${local.environment}/css/token_url"
  insecure_value = "https://${local.aws_account}-${aws_appconfig_application.AppConfigAgentApplication.id}-api.cloudstoragesecapp.com/api/Token"
  type           = "String"
}

resource "aws_ssm_parameter" "css_api_url" {
  name           = "/${local.environment}/css/api_url"
  insecure_value = "https://${local.aws_account}-${aws_appconfig_application.AppConfigAgentApplication.id}-api.cloudstoragesecapp.com/api/Scan/Existing"
  type           = "String"
}

resource "aws_ssm_parameter" "css_username" {
  name           = "/${local.environment}/css/username"
  insecure_value = "admin"
  type           = "String"
}