## Data
data "null_data_source" "Hub_Subnets" {
  inputs = {
    Subnet_Inspect_AZ1_CIDR          = var.Subnet_Inspect_AZ1_CIDR != null && var.Subnet_Inspect_AZ1_CIDR != "" ? var.Subnet_Inspect_AZ1_CIDR : cidrsubnet(var.Security_Hub_VPC_CIDR, 3, 0)
    Subnet_Inspect_AZ2_CIDR          = var.Subnet_Inspect_AZ2_CIDR != null && var.Subnet_Inspect_AZ2_CIDR != "" ? var.Subnet_Inspect_AZ2_CIDR : cidrsubnet(var.Security_Hub_VPC_CIDR, 3, 1)
    Subnet_Internal_Transit_AZ1_CIDR = var.Subnet_Internal_Transit_AZ1_CIDR != null && var.Subnet_Internal_Transit_AZ1_CIDR != "" ? var.Subnet_Internal_Transit_AZ1_CIDR : cidrsubnet(var.Security_Hub_VPC_CIDR, 3, 2)
    Subnet_Internal_Transit_AZ2_CIDR = var.Subnet_Internal_Transit_AZ2_CIDR != null && var.Subnet_Internal_Transit_AZ2_CIDR != "" ? var.Subnet_Internal_Transit_AZ2_CIDR : cidrsubnet(var.Security_Hub_VPC_CIDR, 3, 3)
  }
}

## Variables
variable "Security_Hub_VPC_Suffix" {
  type        = string
  default     = "sechub"
  description = "The string to add to the name of the VPC after the project prefix and a hyphen (e.g. 'demo-sechub')"
}
variable "Security_Hub_VPC_CIDR" {
  type        = string
  default     = "192.0.2.0/24"
  description = "The CIDR for the VPC which must be large enough to support 4 subnets."
}
variable "InternetGateway_Suffix" {
  type        = string
  default     = "igw"
  description = "The string to add to the name of the Internet Gateway after the project prefix and a hyphen (e.g. 'demo-igw')"
}
variable "TransitGateway_Suffix" {
  type        = string
  default     = "Transit_Gateway"
  description = "The string to add to the name of the Transit Gateway after the project prefix and a hyphen (e.g. 'demo-Transit_Gateway')"
}
variable "Inspect_Suffix" {
  type        = string
  default     = "inspect"
  description = "The string to add to the name of the Inspect Subnets after the project prefix and a hyphen, but before the AZ (e.g. 'demo-inspect_aza')"
}
variable "Int_Transit_Suffix" {
  type        = string
  default     = "int_transit"
  description = "The string to add to the name of the Internal Transit Subnets after the project prefix and a hyphen, but before the AZ (e.g. 'demo-int_transit_aza')"
}
variable "Subnet_Inspect_AZ1_CIDR" {
  type        = string
  default     = null
  description = "The CIDR for the 'Inspect' subnet in AZ1. If left blank, this will provision ⅛th of the VPC CIDR."
}
variable "Subnet_Inspect_AZ2_CIDR" {
  type        = string
  default     = null
  description = "The CIDR for the 'Inspect' subnet in AZ2. If left blank, this will provision ⅛th of the VPC CIDR."
}
variable "Subnet_Internal_Transit_AZ1_CIDR" {
  type        = string
  default     = null
  description = "The CIDR for the 'Transit' subnet in AZ1. If left blank, this will provision ⅛th of the VPC CIDR."
}
variable "Subnet_Internal_Transit_AZ2_CIDR" {
  type        = string
  default     = null
  description = "The CIDR for the 'Transit' subnet in AZ2. If left blank, this will provision ⅛th of the VPC CIDR."
}

## Modules
module "hub_and_gateway" {
  source                           = "./Hub and Transit Gateway"
  # General
  Project_Prefix                   = var.Project_Prefix
  AZ1                              = var.AZ1
  AZ2                              = var.AZ2
  # VPC
  VPC_Suffix                       = var.Security_Hub_VPC_Suffix
  IAM_Role_VPC_Flow_Logs_ARN       = var.IAM_Role_VPC_Flow_Logs_ARN
  Enable_VPC_Flow_Logs             = var.Enable_VPC_Flow_Logs
  VPC_CIDR                         = var.Security_Hub_VPC_CIDR
  # Internet Gateway
  InternetGateway_Suffix           = var.InternetGateway_Suffix
  # Subnets
  Inspect_Suffix                   = var.Inspect_Suffix
  Int_Transit_Suffix               = var.Int_Transit_Suffix
  Subnet_Inspect_AZ1_CIDR          = data.null_data_source.Hub_Subnets.outputs["Subnet_Inspect_AZ1_CIDR"]
  Subnet_Inspect_AZ2_CIDR          = data.null_data_source.Hub_Subnets.outputs["Subnet_Inspect_AZ2_CIDR"]
  Subnet_Internal_Transit_AZ1_CIDR = data.null_data_source.Hub_Subnets.outputs["Subnet_Internal_Transit_AZ1_CIDR"]
  Subnet_Internal_Transit_AZ2_CIDR = data.null_data_source.Hub_Subnets.outputs["Subnet_Internal_Transit_AZ2_CIDR"]
  South_North_Gateway_ENI          = null # TODO: Note this is for the Active Security Gateway
                                          # next-hop. It will be Internal to this region.
  # Transit Gateway
  TransitGateway_Suffix            = var.TransitGateway_Suffix
}