variable "aws_region" {
  description = "Region for the setup"
  type = string
  default = "us-east-1"
}

variable "client" {
  description = "Name of the client in small."
  type = string
  default = "study"
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "proddc" # proddc, proddr, dev, qa etc
}




# Variables for vpc/subnet 

variable "cidr_start" {
  description = "vnet range"
  type = string
  default = "10.24"  
}

variable "subnets" {
  description = "All subnets name,"
  type = list(object({
    name = string
    availability_zone = string
  }))

  default     = [
    {
      name = "bastion"
      availability_zone = "eu-north-1a"
    },
        {
      name = "fe1"
      availability_zone = "eu-north-1a"
    },
        {
      name = "fe2"
      availability_zone = "eu-north-1b"
    },
        {
      name = "be"
      availability_zone = "eu-north-1a"
    },
        {
      name = "db"
      availability_zone = "eu-north-1a"
    },
  ]
}


# Bastion variables 


# FE variables 

# BE variables
