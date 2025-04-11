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

dependency "tg_be" {
  config_path = "../../target_group/be"
}

dependency "ec2_be" {
  config_path = "../../ec2/be"
}


inputs = {  
  target_group_arn = dependency.tg_be.outputs.target_group_arn
  target_ids       = dependency.ec2_be.outputs.instance_ids
  port             = 8080
}
