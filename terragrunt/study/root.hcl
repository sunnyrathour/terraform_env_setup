# Root Terragrunt configuration

locals {
  client = "study"
  region     = "eu-north-1"
}

# Define remote state backend for all inherited modules
# remote_state {
#   backend = "s3"
#   config = {
#     bucket         = "your-terraform-state-bucket"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

# Auto-generate a provider block for consistency
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "eu-north-1"
  access_key = "enter your access_key"
  secret_key = "enter your secret_key"
}
EOF
}
