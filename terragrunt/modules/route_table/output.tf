output "public_route_table_id" {
  description = "public route table id"
  value = aws_route_table.public_rt.id
}
output "private_route_table_id" {
  description = "private route table id"
  value = aws_route_table.private_rt.id
}