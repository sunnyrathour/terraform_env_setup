resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.client}-igw-${var.environment}-${var.aws_region}"
  }
}