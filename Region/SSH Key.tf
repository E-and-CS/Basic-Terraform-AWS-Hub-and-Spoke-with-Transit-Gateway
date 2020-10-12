## Variables
# Naming
variable "SSH_Key_Suffix" {
  default = "SSH Key"
  description = "The suffix of the key file to use, after the project prefix and a space (e.g. 'demo SSH Key')"
}

# Content
variable "SSH_Public_Key" {
  type        = string
  default     = ""
  description = "SSH Key to be added to 'Authorized Keys' on the appliance. Leave blank to omit SSH key-based authentication."
  validation {
    condition     = can(regex("^(ssh-(dss|rsa|ed25519) [\\/+=A-Za-z0-9]+( .*)|)$", var.SSH_Public_Key))
    error_message = "SSH key must either be DSA, RSA or ED25519, or left blank."
  }
}

## Resources
resource "aws_key_pair" "service" {
  count      = var.SSH_Public_Key != "" ? 1 : 0
  key_name   = "${var.Project_Prefix} ${var.SSH_Key_Suffix}"
  public_key = var.SSH_Public_Key
}