resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.client}-public-rt-${var.environment}-${var.aws_region}"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.client}-private-rt-${var.environment}-${var.aws_region}"
  }
}
