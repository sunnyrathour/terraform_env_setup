include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/route_table"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "igw" {
  config_path = "../igw"
}

inputs = {
  vpc_id                        = dependency.vpc.outputs.vpc_id
  igw_id                        = dependency.igw.outputs.igw_id
  aws_region                    = include.root.locals.region
  environment                   = include.env.locals.env
  client                        = include.root.locals.client
}

