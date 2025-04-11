variable "aws_region" {
    description = "aws region"
    type = string
}
variable "environment" {
    description = "environment name"
    type = string
}
variable "cidr_start" {
    description = "CIDR start"
    type = string
}
variable "subnets" {
  description = "All subnets name,"
  type = list(object({
    name = string
    availability_zone = string
  }))
}
variable "client" {
  description = "Name of the client in small."
  type = string
}
variable "vpc_id" {
  description = "Name of the client in small."
  type = string
}