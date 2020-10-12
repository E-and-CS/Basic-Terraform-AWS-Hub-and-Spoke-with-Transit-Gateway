## Variables
# Naming
variable "Project_Prefix" {
  type        = string
  default     = "demo"
  description = "The prefix before all project created resources, including Transit Gateways, attachments and routing tables."
}

# HA/AZ Targetting
variable "AZ1" {
  type        = string
  default     = "a"
  description = "The Availability Zone character (e.g. eu-west-1a = a or eu-west-1b = b) for all assets targetting this AZ (one of each of the subnets, one for each of the firewalls, etc.)"
  validation {
    condition     = can(regex("^[a-z]$", var.AZ1))
    error_message = "Availability Zones are indicated by a single, lower case, letter."
  }
}

variable "AZ2" {
  type        = string
  default     = "b"
  description = "The Availability Zone character (e.g. eu-west-1a = a or eu-west-1b = b) for all assets targetting this AZ (one of each of the subnets, one for each of the firewalls, etc.)"
  validation {
    condition     = can(regex("^[a-z]$", var.AZ2))
    error_message = "Availability Zones are indicated by a single, lower case, letter."
  }
}

# VPC Flow Logs
variable "IAM_Role_VPC_Flow_Logs_ARN" {
  type        = string
  default     = null
  description = "The ARN of the IAM role which has been created to work with VPC Flow Logs."
}

variable "Enable_VPC_Flow_Logs" {
  type        = bool
  default     = false
  description = "Explicitly enable this to permit VPC flow logs to be created."
}