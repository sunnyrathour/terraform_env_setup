include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/subnets"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id                        = dependency.vpc.outputs.vpc_id
  aws_region                    = include.root.locals.region
  environment                   = include.env.locals.env
  cidr_start                    = "10.25"
  subnets                       = [
                                    {
                                      name = "bastion"
                                      availability_zone = "eu-north-1a"
                                    },
                                        {
                                      name = "fe1"
                                      availability_zone = "eu-north-1a"
                                    },
                                        {
                                      name = "fe2"
                                      availability_zone = "eu-north-1b"
                                    },
                                        {
                                      name = "be"
                                      availability_zone = "eu-north-1a"
                                    },
                                        {
                                      name = "db"
                                      availability_zone = "eu-north-1a"
                                    },
                                  ]
  client                        = include.root.locals.client
}

