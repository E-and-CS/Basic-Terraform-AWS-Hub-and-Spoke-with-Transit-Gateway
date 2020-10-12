provider "aws" {
  alias  = "Ireland"
  region = "eu-west-1"
}

module "Ireland" {
  source = "./Region"
  providers = {
    aws = aws.Ireland
  }
  # General
  Project_Prefix             = "jseuwest1"
  IAM_Role_VPC_Flow_Logs_ARN = module.Global.vpc_flow_logs_role_defined_arn
  SSH_Public_Key             = data.null_data_source.loaded_files.outputs["SSH_Key"]
  # Hub and Transit
  Security_Hub_VPC_CIDR      = "192.0.2.0/24" # RFC5737
  # Spoke
  Spokes = {
    demo = {
      VPC_CIDR        = "198.51.100.0/24" # RFC5737
    }
  }
}