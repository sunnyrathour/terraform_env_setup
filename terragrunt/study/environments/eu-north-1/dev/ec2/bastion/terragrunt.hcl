include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../../modules/ec2"
}

dependency "sg" {
  config_path = "../../sg/bastion"
}

dependency "subnet" {
  config_path = "../../subnet"
}

inputs = {  
  instance_count      = 1
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = dependency.subnet.outputs.subnet_ids.bastion
  security_group_ids  = [dependency.sg.outputs.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "bastion"
    client = include.root.locals.client
    region = include.root.locals.region
    created_by = "Terraform"
  }

}