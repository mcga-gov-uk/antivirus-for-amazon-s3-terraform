variable "organisation" {
  default = "mcauk"
}

variable "project" {
  default = "smart"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "tags" {
  description = "Custom tags to apply to all resources."
  type        = map(string)
  default     = {}
}

