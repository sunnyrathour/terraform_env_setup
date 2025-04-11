# variable "route_table_ids" {
#   description = "List of subnet names"
#   type        = list(string)
# }
variable "public_rt_id" {
  description = "public route table id"
  type = string
}
variable "private_rt_id" {
  description = "private route table id"
  type = string
}

variable "fe_subnet_ids" {
  description = "fe subnets ids"
  type        = list(string)
}
variable "be_subnet_ids" {
  description = "be subnets ids"
  type        = list(string)
}