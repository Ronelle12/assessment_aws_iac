variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "assign_generated_ipv6_cidr_block" {
  type    = bool
  default = false
}

variable "vpc_tags" {
  type = map(string)
}
