variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "target_ids" {
  description = "List of instance IDs to attach"
  type        = list(string)
}

variable "port" {
  description = "Port on which targets receive traffic"
  type        = number
}
