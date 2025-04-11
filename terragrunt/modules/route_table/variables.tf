variable "aws_region" {
    description = "aws region"
    type = string
}
variable "environment" {
    description = "environment name"
    type = string
}
variable "client" {
  description = "Name of the client in small."
  type = string
}
variable "vpc_id" {
  description = "vpc id."
  type = string
}
variable "igw_id" {
  description = "igw id"
  type = string
}