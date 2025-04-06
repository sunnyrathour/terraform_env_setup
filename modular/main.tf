module "vpc_setup" {
  source = "./modules/vpc"
  aws_region                    = var.aws_region
  environment                   = var.environment
  cidr_start                     = var.cidr_start
  client                        = var.client
}
module "subnets_setup" {
  source = "./modules/subnets"
  vpc_id                        = module.vpc_setup.vpc_id
  aws_region                    = var.aws_region
  environment                   = var.environment
  cidr_start                    = var.cidr_start
  subnets                       = var.subnets
  client                        = var.client
}

module "internet_gateway" {
  source = "./modules/internet_gw"
  vpc_id                        = module.vpc_setup.vpc_id
  aws_region                    = var.aws_region
  environment                   = var.environment
  client                        = var.client
}

module "route_table" {
  source                        = "./modules/route_table"
  igw_id                        = module.internet_gateway.igw_id
  vpc_id                        = module.vpc_setup.vpc_id
  aws_region                    = var.aws_region
  environment                   = var.environment
  client                        = var.client
}

module "rt_assoc" {
  source = "./modules/route_table_assoc"
  public_rt_id = module.route_table.public_route_table_id
  private_rt_id = module.route_table.private_route_table_id
  fe_subnet_ids = [
    module.subnets_setup.subnet_ids.fe1,
    module.subnets_setup.subnet_ids.fe2,
    module.subnets_setup.subnet_ids.bastion
  ]
  be_subnet_ids = [
    module.subnets_setup.subnet_ids.be,
    module.subnets_setup.subnet_ids.db
  ]
}

module "bastion_sg" {
  source      = "./modules/security_group"
  name        = "bastion-sg"
  description = "Security group for bastion"
  vpc_id      = module.vpc_setup.vpc_id 
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = [
      module.subnets_setup.subnet_cidrs.be,
      module.subnets_setup.subnet_cidrs.fe1,
      module.subnets_setup.subnet_cidrs.fe2,
      module.subnets_setup.subnet_cidrs.db
    ]
    }
  ]
}

module "fe_sg" {
  source      = "./modules/security_group"
  name        = "fe-sg"
  description = "Security group for fe"
  vpc_id      = module.vpc_setup.vpc_id 
  ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"  
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"  
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [
      module.subnets_setup.subnet_cidrs.bastion
      ]
    }
  ]
  egress = []
}
module "be_sg" {
  source      = "./modules/security_group"
  name        = "be-sg"
  description = "Security group for be"
  vpc_id      = module.vpc_setup.vpc_id 
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [
      module.subnets_setup.subnet_cidrs.bastion
      ]
    }
  ]
  egress = []
}
module "db_sg" {
  source      = "./modules/security_group"
  name        = "db-sg"
  description = "Security group for db"
  vpc_id      = module.vpc_setup.vpc_id 
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [
      module.subnets_setup.subnet_cidrs.bastion
      ]
    }
  ]
  egress = []
}

module "fe_alb_sg" {
  source      = "./modules/security_group"
  name        = "fe-alb-sg"
  description = "Security group for application load-balancer"
  vpc_id      = module.vpc_setup.vpc_id 
  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "bastion_ec2" {
  source              = "./modules/ec2"
  instance_count      = 1
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = module.subnets_setup.subnet_ids.bastion
  security_group_ids  = [module.bastion_sg.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "bastion"
    client = var.client
    region = var.aws_region
    created_by = "Terraform"
  }
}
module "fe1_ec2" {
  source              = "./modules/ec2"
  instance_count      = 1
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = module.subnets_setup.subnet_ids.fe1
  security_group_ids  = [module.fe_sg.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "fe2"
    client = var.client
    region = var.aws_region
    created_by = "Terraform"
  }
}

module "fe2_ec2" {
  source              = "./modules/ec2"
  instance_count      = 1
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = module.subnets_setup.subnet_ids.fe2
  security_group_ids  = [module.fe_sg.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "fe2"
    client = var.client
    region = var.aws_region
    created_by = "Terraform"
  }
}


module "be_ec2" {
  source              = "./modules/ec2"
  instance_count      = 2
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = module.subnets_setup.subnet_ids.be
  security_group_ids  = [module.be_sg.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "be"
    client = var.client
    region = var.aws_region
    created_by = "Terraform"
  }
}
module "db_ec2" {
  source              = "./modules/ec2"
  instance_count      = 2
  ami_id              = "ami-03f71e078efdce2c9"
  instance_type       = "t3.micro"
  subnet_id           = module.subnets_setup.subnet_ids.db
  security_group_ids  = [module.db_sg.security_group_id]
  key_name            = "new"
  associate_public_ip = true
  tags = {
    app = "db"
    client = var.client
    region = var.aws_region
    created_by = "Terraform"
  }
}


module "fe_target_group" {
  source     = "./modules/target_group"
  name       = "fe-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = module.vpc_setup.vpc_id
}

module "fe_tg_attachment" {
  source           = "./modules/target_attachment"
  target_group_arn = module.fe_target_group.target_group_arn
  target_ids       = concat(module.fe1_ec2.instance_ids,module.fe2_ec2.instance_ids)
  port             = 80
}

module "fe_alb" {
  source          = "./modules/application_lb"
  name            = "fe-alb"
  subnet_ids      = [
    module.subnets_setup.subnet_ids.fe1,
    module.subnets_setup.subnet_ids.fe2
  ]
  vpc_id          = module.vpc_setup.vpc_id
  security_groups = [module.fe_alb_sg.security_group_id]
  target_group_arn = module.fe_target_group.target_group_arn
}

module "be_target_group" {
  source     = "./modules/target_group"
  name       = "be-tg"
  port       = 8080
  protocol   = "TCP"
  vpc_id     = module.vpc_setup.vpc_id
}

module "be_tg_attachment" {
  source           = "./modules/target_attachment"
  target_group_arn = module.be_target_group.target_group_arn
  target_ids       = module.be_ec2.instance_ids
  port             = 8080
}

module "be_nlb" {
  name            = "be-alb"
  source = "./modules/network_lb"
  private_subnet_ids = [
    module.subnets_setup.subnet_ids.be
  ]
  vpc_id          = module.vpc_setup.vpc_id
  security_groups = [module.fe_alb_sg.security_group_id]
  target_group_arn = module.be_target_group.target_group_arn
}
