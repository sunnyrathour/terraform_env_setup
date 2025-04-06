resource "aws_route_table_association" "fe_assoc" {
  for_each = toset(var.fe_subnet_ids)

  subnet_id      = each.value
  route_table_id = var.public_rt_id 
}

resource "aws_route_table_association" "be_assoc" {
  for_each = toset(var.be_subnet_ids)

  subnet_id      = each.value
  route_table_id = var.private_rt_id 
}
