# VPC create 
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "${var.client_name}-vpc-${var.dc_type}-${var.region}"
  }
}

resource "aws_internet_gateway" "main_IGW" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.client_name}-igw-${var.dc_type}-${var.region}"
  }
}

# Subnet create
resource "aws_subnet" "sub-fe1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "sub-${var.client_name}-fe-${var.dc_type}-${var.region}"
  }
}

resource "aws_subnet" "sub-fe2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name = "sub-${var.client_name}-fe-${var.dc_type}-${var.region}"
  }
}

resource "aws_subnet" "sub-be" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "sub-${var.client_name}-be-${var.dc_type}-${var.region}"
  }
}

resource "aws_subnet" "sub-db" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.1.3.0/24"

  tags = {
    Name = "sub-${var.client_name}-db-${var.dc_type}-${var.region}"
  }
}

resource "aws_subnet" "sub-bastion" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.1.4.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "sub-${var.client_name}-bastion-${var.dc_type}-${var.region}"
  }
}



# Route Table create 
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.client_name}-public-rt-${var.dc_type}-${var.region}"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_IGW.id
}

resource "aws_route_table_association" "assoc_public_route_bastion" {
  subnet_id      = aws_subnet.sub-bastion.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "assoc_public_route_fe1" {
  subnet_id      = aws_subnet.sub-fe1.id
  route_table_id = aws_route_table.public-RT.id
}
resource "aws_route_table_association" "assoc_public_route_fe2" {
  subnet_id      = aws_subnet.sub-fe2.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table" "priate-RT" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.client_name}-private-rt-${var.dc_type}-${var.region}"
  }
}

resource "aws_route_table_association" "assoc_public_route_be" {
  subnet_id      = aws_subnet.sub-be.id
  route_table_id = aws_route_table.priate-RT.id
}
resource "aws_route_table_association" "assoc_public_route_db" {
  subnet_id      = aws_subnet.sub-db.id
  route_table_id = aws_route_table.priate-RT.id
}








#SGs create 
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "SG rules for bastion"
  vpc_id      = aws_vpc.main_vpc.id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = [aws_subnet.sub-fe1.cidr_block,aws_subnet.sub-fe2.cidr_block , aws_subnet.sub-be.cidr_block,aws_subnet.sub-db.cidr_block]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "fe_sg" {
  name        = "fe-sg"
  description = "SG rules for fe nodes"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    security_groups        = [aws_security_group.bastion_sg.id]
  }
  tags = {
    Name = "fe-sg"
  }
}

resource "aws_security_group" "be_sg" {
  name        = "be-sg"
  description = "SG rules for be nodes"
  vpc_id      = aws_vpc.main_vpc.id  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    security_groups        = [aws_security_group.bastion_sg.id]
  }
  tags = {
    Name = "be-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "SG rules for db nodes"
  vpc_id      = aws_vpc.main_vpc.id  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    security_groups        = [aws_security_group.bastion_sg.id]
  }
  tags = {
    Name = "db-sg"
  }
}





resource "aws_security_group" "fe_alb_sg" {
  name   = "fe-alb-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fe-alb-sg"
  }
}







# # Virtual machine create 

resource "aws_instance" "fe1-ec2" {
  ami        = "ami-03f71e078efdce2c9"  # AMI (Amazon Linux 2)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-fe1.id
  key_name      = "new"  
  vpc_security_group_ids = [aws_security_group.fe_sg.id]
  associate_public_ip_address = true  # Assigns a public IP automatically
  tags = {
    Name = "fe-vm1"
    app = "fe"
    client = var.client_name
    region = var.region
    created_by = "Terraform"
  }
}

resource "aws_instance" "fe2-ec2" {
  ami        = "ami-03f71e078efdce2c9"  # AMI (Amazon Linux 2)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-fe2.id
  key_name      = "new"  
  vpc_security_group_ids = [aws_security_group.fe_sg.id]
  associate_public_ip_address = true  # Assigns a public IP automatically
  tags = {
    Name = "fe-vm1"
    app = "fe"
    client = var.client_name
    region = var.region
    created_by = "Terraform"
  }
}

resource "aws_instance" "be-ec2" {
  ami        = "ami-03f71e078efdce2c9"  # Example AMI (Amazon Linux 2)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-be.id
  key_name      = "new"  
  vpc_security_group_ids = [aws_security_group.be_sg.id]
  tags = {
    Name = "be-vm-1"
    app = "be"
    client = var.client_name
    region = var.region
    created_by = "Terraform"
  }
}

resource "aws_instance" "db-ec2" {
  ami        = "ami-03f71e078efdce2c9"  # Example AMI (Amazon Linux 2)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-db.id
  key_name      = "new"  
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  tags = {
    Name ="db-vm-1"
    app = "db"
    client = var.client_name
    region = var.region
    created_by = "Terraform"
  }
}

resource "aws_instance" "bastion-ec2" {
  ami        = "ami-03f71e078efdce2c9"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-bastion.id
  key_name      = "new"  
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true  # Assigns a public IP automatically

  tags = {
    Name = "bastion-vm-1"
    app = "bastion"
    client = var.client_name
    region = var.region
    created_by = "Terraform"
  }
}











# ALB for FE

resource "aws_lb_target_group" "fe_tg" {
  name     = "fe-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Name = "fe-target-group"
  }
}


resource "aws_lb_target_group_attachment" "fe1_tg_attach" {
  target_group_arn = aws_lb_target_group.fe_tg.arn
  target_id        = aws_instance.fe1-ec2.id  # your EC2 instance ID
  port             = 80
}
resource "aws_lb_target_group_attachment" "fe2_tg_attach" {
  target_group_arn = aws_lb_target_group.fe_tg.arn
  target_id        = aws_instance.fe2-ec2.id  # your EC2 instance ID
  port             = 80
}

resource "aws_lb" "fe_alb" {
  name               = "fe-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fe_alb_sg.id]
  subnets            = [aws_subnet.sub-fe1.id,aws_subnet.sub-fe2.id] # must be public subnets

  tags = {
    Name = "fe-alb"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.fe_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fe_tg.arn
  }
}

# BE Loadbalancer

resource "aws_lb_target_group" "be_tg" {
  name     = "be-target-group"
  port     = 8080
  protocol = "TCP"                  
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    protocol            = "TCP"       
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "be-target-group"
  }
}



resource "aws_lb_target_group_attachment" "be_tg_attach" {
  target_group_arn = aws_lb_target_group.be_tg.arn
  target_id        = aws_instance.be-ec2.id  # your EC2 instance ID
  port             = 8080
}

resource "aws_lb" "be_nlb" {
  name               = "fe-alb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.fe_alb_sg.id]
  subnets            = [aws_subnet.sub-be.id] # must be public subnets

  tags = {
    Name = "be-nlb"
  }
}


resource "aws_lb_listener" "internal_port" {
  load_balancer_arn = aws_lb.be_nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.be_tg.arn
  }
}