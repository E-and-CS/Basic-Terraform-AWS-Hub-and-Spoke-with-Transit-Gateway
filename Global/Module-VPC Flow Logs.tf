## Variables
variable "IAM_VPC_Flow_Logs_Prefix" {
  default = "VPC_Flow_Logs"
}
variable "Role_Suffix" {
  default = "role"
}
variable "Policy_Suffix" {
  default = "profile"
}

## Module
module "vpc_flow_logs" {
  source                   = "./VPC Flow Logs"
  IAM_VPC_Flow_Logs_Prefix = var.IAM_VPC_Flow_Logs_Prefix
  Role_Suffix              = var.Role_Suffix
  Policy_Suffix            = var.Policy_Suffix
}

## Outputs
output "vpc_flow_logs_role_defined" {
  value = module.vpc_flow_logs.aws_iam_role_defined
}
output "vpc_flow_logs_role_defined_arn" {
  value = module.vpc_flow_logs.aws_iam_role_defined_arn
}