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
  name        = "fe-sg"
  description = "Security group for fe"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"  
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"  
      cidr_blocks = ["0.0.0.0/0"]
    },
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