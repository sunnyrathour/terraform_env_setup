include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/vpc"
}

inputs = {
  aws_region                    = include.root.locals.region
  environment                   = include.env.locals.env
  cidr_start                     = "10.25"
  client                        = include.root.locals.client
}

