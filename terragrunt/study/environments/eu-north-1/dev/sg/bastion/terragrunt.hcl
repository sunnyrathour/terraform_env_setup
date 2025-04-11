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
  name        = "bastion-sg"
  description = "Security group for bastion"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = [
      dependency.subnet.outputs.subnet_cidrs.be,
      dependency.subnet.outputs.subnet_cidrs.fe1,
      dependency.subnet.outputs.subnet_cidrs.fe2,
      dependency.subnet.outputs.subnet_cidrs.db
    ]
    }
  ]
}