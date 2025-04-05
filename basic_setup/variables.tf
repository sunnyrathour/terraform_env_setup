variable "region" {
  description = "Region for the setup"
  type = string
  default = "us-east-1"
}

variable "client_name" {
  description = "Name of the client in small."
  type = string
  default = "study"
}

variable "dc_type" {
  description = "DC type"
  type = string
  default = "dc"
}