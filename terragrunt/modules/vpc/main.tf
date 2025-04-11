# VPC create 
resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.cidr_start}.0.0/16"

  tags = {
    Name = "${var.client}-vpc-${var.environment}-${var.aws_region}"
  }
}
