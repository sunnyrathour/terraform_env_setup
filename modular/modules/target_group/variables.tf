variable "name" {
  description = "Name of the target group"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
}

variable "protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID where target group is created"
  type        = string
}

variable "target_type" {
  description = "Type of targets (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    enabled             = bool
    path                = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
    matcher             = string
  })
  default = {
    enabled             = true
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}
