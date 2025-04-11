include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env_vars.hcl")
  expose = true
}

terraform {
  source = "../../../../../modules/route_table_assoc"
}

dependency "route_table" {
  config_path = "../route_table"
}

dependency "subnet" {
  config_path = "../subnet"
}

inputs = {
  public_rt_id = dependency.route_table.outputs.public_route_table_id
  private_rt_id = dependency.route_table.outputs.private_route_table_id
  fe_subnet_ids = [
    dependency.subnet.outputs.subnet_ids.fe1,
    dependency.subnet.outputs.subnet_ids.fe2,
    dependency.subnet.outputs.subnet_ids.bastion
  ]
  be_subnet_ids = [
    dependency.subnet.outputs.subnet_ids.be,
    dependency.subnet.outputs.subnet_ids.db
  ]
}

