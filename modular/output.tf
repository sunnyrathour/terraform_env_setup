output "vpc_id" {
  description = "Subnet id"
  value = module.vpc_setup.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs from vpc_setup module"
  value       = module.subnets_setup.subnet_ids
}

output "subnet_cidrs" {
  description = "Subnet CIDRs from vpc_setup module"
  value       = module.subnets_setup.subnet_cidrs
}

output "public_route_table_id" {
  description = "public route table id"
  value = module.route_table.public_route_table_id
}

output "private_route_table_id" {
  description = "private route table id"
  value = module.route_table.private_route_table_id
}

output "igw_id" {
  description = "private route table id"
  value = module.internet_gateway.igw_id
}
output "bastion_sg_id" {
  description = "bastion rg id"
  value = module.bastion_sg.security_group_id
}

output "bastion_ec2" {
  description = "bastion ec2"
  value = module.bastion_ec2.instance_ids
}
output "fe1_ec2" {
  description = "fe1 ec2"
  value = module.fe1_ec2.instance_ids
}
output "fe2_ec2" {
  description = "fe2 ec2"
  value = module.fe2_ec2.instance_ids
}
output "be_ec2" {
  description = "be ec2"
  value = module.be_ec2.instance_ids
}
output "db_ec2" {
  description = "db ec2"
  value = module.db_ec2.instance_ids
}


output "fe_target_group_arn" {
  value = module.fe_target_group.target_group_arn
}
