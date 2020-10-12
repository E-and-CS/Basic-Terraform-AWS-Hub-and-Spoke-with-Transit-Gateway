## Providers
terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
  }
}

## Data
data "null_data_source" "loaded_files" {
  inputs = {
    SSH_Key = "${var.SSH_Key_File != "" ? trimspace(file(var.SSH_Key_File)) : ""}"
  }
}

## Variables
variable "SSH_Key_File" {
  default     = "id_rsa.pub"
  description = "Path to the SSH public key to use"
}