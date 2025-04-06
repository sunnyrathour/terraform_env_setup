resource "aws_lb" "internal_nlb" {
  name               = var.name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  enable_cross_zone_load_balancing = true
  ip_address_type    = "ipv4"
  tags = {
    Name = "internal-nlb"
  }
}
