provider "aws" {
  region = "us-east-1"
}

module "Global" {
  source = "./Global"
}