include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../../modules/target_attachment"
}

dependency "tg_fe" {
  config_path = "../../target_group/fe"
}

dependency "ec2_fe1" {
  config_path = "../../ec2/fe1"
}

dependency "ec2_fe2" {
  config_path = "../../ec2/fe2"
}

inputs = {  
  target_group_arn = dependency.tg_fe.outputs.target_group_arn
  target_ids       = concat(dependency.ec2_fe1.outputs.instance_ids,dependency.ec2_fe2.outputs.instance_ids)
  port             = 80
}