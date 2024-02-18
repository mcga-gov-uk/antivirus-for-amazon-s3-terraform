locals {

  environment  = terraform.workspace
  name_prefix  = "${var.organisation}-${var.project}-${local.environment}"
  vpc_name     = "${local.name_prefix}-vpc"
  cluster_name = "${local.name_prefix}-eks"
  aws_region   = data.aws_region.current.name
  aws_account  = data.aws_caller_identity.current.account_id
  whitelist_ips_restricted = [for addr in jsondecode(data.aws_ssm_parameter.ui_alb_allow_ips.insecure_value) : addr.ip]
  cidr         = concat(formatlist(data.aws_vpc.vpc.cidr_block), local.whitelist_ips_restricted, formatlist("${data.aws_nat_gateway.vpc.public_ip}/32"))
  subnet_a_id  = data.aws_subnets.private.ids[0]
  subnet_b_id  = data.aws_subnets.private.ids[1]
  common_tags = {
    Organisation = var.organisation
    Project      = var.project
    Environment  = local.environment
  }

  # Terraform module and the associated app version are tightly coupled for compatibility.
  # Specified 'image_version' corresponds to a tested combination of Terraform and app release.
  # Avoid manually changing the 'image_version' unless you have explicit instructions to do so.
  image_version_console = "v7.05.001"
  image_version_agent   = "v7.05.000"
  console_image_url     = "${var.ecr_account}.dkr.ecr.${var.aws_region}.amazonaws.com/cloudstoragesecurity/console:${local.image_version_console}"
  agent_image_url       = "${var.ecr_account}.dkr.ecr.${var.aws_region}.amazonaws.com/cloudstoragesecurity/agent:${local.image_version_agent}"

  URL = "${var.configure_load_balancer}" ? "https://${aws_lb.LoadBalancer[0].dns_name}" : "https://${local.aws_account}-${aws_appconfig_application.AppConfigAgentApplication.id}.cloudstoragesecapp.com"

  custom_tags                       = [for tag, val in local.common_tags : { key = tag, value = val }]
  blanket_kms_access                = var.allow_access_to_all_kms_keys == "Yes"
  create_event_bridge_role          = var.event_bridge_role_name == "Created by TF"
  eventbridge_notifications_enabled = var.eventbridge_notifications_bus_name != "default"
  use_proxy                         = var.proxy_host != "none"
  is_antivirus                      = var.product_mode == "AV"
  use_dynamo_cmk                    = var.dynamo_cmk_key_arn != null
  use_sns_cmk                       = var.sns_cmk_key_arn != null
  custom_key_list = compact([
    var.dynamo_cmk_key_arn,
    var.sns_cmk_key_arn
  ])
  ecs_service_name = var.configure_load_balancer ? aws_ecs_service.ServiceWithLB[0].name : aws_ecs_service.Service[0].name
}
