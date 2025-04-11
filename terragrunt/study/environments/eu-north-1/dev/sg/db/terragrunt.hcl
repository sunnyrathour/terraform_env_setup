include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../../modules/security_group"
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "subnet" {
  config_path = "../../subnet"
}

inputs = {  
  name        = "db-sg"
  description = "Security group for db"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [
      dependency.subnet.outputs.subnet_cidrs.bastion
      ]
    }
  ]
  egress = []
}