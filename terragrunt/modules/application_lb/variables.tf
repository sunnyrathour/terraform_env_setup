variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to associate with the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}
variable "target_group_arn" {
  description = "target group arn"
  type        = string
}
