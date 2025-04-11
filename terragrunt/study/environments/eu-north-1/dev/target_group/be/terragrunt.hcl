include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../../modules/target_group"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {  
  name       = "be-tg"
  port       = 8080
  protocol   = "TCP"
  vpc_id     = dependency.vpc.outputs.vpc_id
}
