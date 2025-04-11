include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/internet_gw"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id                        = dependency.vpc.outputs.vpc_id
  aws_region                    = include.root.locals.region
  environment                   = include.env.locals.env
  client                        = include.root.locals.client
}

