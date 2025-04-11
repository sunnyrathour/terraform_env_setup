include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/network_lb"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "subnet" {
  config_path = "../subnet"
}

dependency "sg_fe_alb" {
  config_path = "../sg/fe_alb"
}

dependency "be_tg" {
  config_path = "../target_group/fe"
}

inputs = { 
  name            = "be-alb"
  private_subnet_ids = [
    dependency.subnet.outputs.subnet_ids.be
  ]
  vpc_id          = dependency.vpc.outputs.vpc_id
  security_groups = [dependency.sg_fe_alb.outputs.security_group_id]
  target_group_arn = dependency.be_tg.outputs.target_group_arn
}
