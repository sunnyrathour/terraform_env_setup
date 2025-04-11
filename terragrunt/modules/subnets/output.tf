output "subnet_ids" {
  description = "Map of subnet name to subnet ID"
  value = {
    for index in range(length(var.subnets)) :
    var.subnets[index].name => aws_subnet.subnets[index].id
  }
}
output "subnet_cidrs" {
  description = "Map of subnet name to subnet ID"
  value = {
    for index in range(length(var.subnets)) :
    var.subnets[index].name => aws_subnet.subnets[index].cidr_block
  }
}