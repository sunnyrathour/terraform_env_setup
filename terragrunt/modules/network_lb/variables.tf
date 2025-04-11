variable "private_subnet_ids" {
    description = "private subnet of be"
    type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "name" {
  type = string
}