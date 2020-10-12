## Variables
variable "Spokes" {
  type        = map(map(string))
  default     = {}
  description = "A map of maps of strings, like this {spoke1 = {VPC_CIDR = '192.0.2.0/24'}, spoke2 = {VPC_CIDR = '198.51.100.0/24', AZ1_CIDR = '198.51.100.0/28', AZ2_CIDR = '198.51.100.16/28'}, another_spoke = {VPC_CIDR = '203.0.113.0/24', Subnet_Suffix = 'realm'}}"
}
variable "Subnet_Suffix" {
  type        = string
  default     = "subnet"
  description = "The string to add to the name of the Subnets after the project prefix and a hyphen, but before the AZ (e.g. 'demo-subnet_aza')"
}

## Modules
module "spoke" {
  for_each = var.Spokes

  source                                        = "./Spoke"
  # General
  Project_Prefix                                = lookup(each.value, "Project_Prefix", var.Project_Prefix)
  AZ1                                           = lookup(each.value, "AZ1", var.AZ1)
  AZ2                                           = lookup(each.value, "AZ2", var.AZ2)
  # VPC
  VPC_Suffix                                    = each.key
  IAM_Role_VPC_Flow_Logs_ARN                    = lookup(each.value, "IAM_Role_VPC_Flow_Logs_ARN", var.IAM_Role_VPC_Flow_Logs_ARN)
  VPC_CIDR                                      = each.value.VPC_CIDR
  Enable_VPC_Flow_Logs                          = lookup(each.value, "Enable_VPC_Flow_Logs", var.Enable_VPC_Flow_Logs)
  # Subnets
  Subnet_Suffix                                 = lookup(each.value, "Subnet_Suffix", var.Subnet_Suffix)
  Subnet_CIDR_AZ1                               = lookup(each.value, "AZ1_CIDR", null)
  Subnet_CIDR_AZ2                               = lookup(each.value, "AZ2_CIDR", null)
  # Transit Gateway
  Transit_Gateway                               = module.hub_and_gateway.aws_ec2_transit_gateway_defined
  Transit_Gateway_Spoke_to_Hub_Routing_Table_ID = module.hub_and_gateway.aws_ec2_transit_gateway_route_table_spokes_to_hub_id
  Transit_Gateway_Hub_to_Spoke_Routing_Table_ID = module.hub_and_gateway.aws_ec2_transit_gateway_route_table_hub_to_spokes_id
  Transit_Gateway_Hub_To_Gateway_Attachment_ID  = module.hub_and_gateway.aws_ec2_transit_gateway_vpc_attachment_hub_id
  Hub_Inspect_Routing_Table_ID                  = module.hub_and_gateway.aws_route_table_inspect_id
  Create_Demo_VMs                               = lookup(each.value, "Create_Demo_VMs", false)
  Key_Name                                      = lookup(each.value, "Key_Name", var.SSH_Public_Key != "" ? aws_key_pair.service[0].id : null)
}