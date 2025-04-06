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
variable "client" {
  description = "Name of the client in small."
  type = string
  default = "study"
}