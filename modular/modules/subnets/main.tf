
# Subnet create
resource "aws_subnet" "subnets" {
  count             = length(var.subnets)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("${var.cidr_start}.0.0/16", 4, count.index)
  availability_zone = var.subnets[count.index].availability_zone

  tags = {
    Name = "sub-${var.client}-${var.subnets[count.index].name}-${var.environment}-${var.aws_region}"
  }
}
