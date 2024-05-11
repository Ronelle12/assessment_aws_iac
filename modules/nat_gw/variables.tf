variable "name" {
  type = string
}

variable "eip_id" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "The ID of the public subnet in which the NAT Gateway should be placed"
}

variable "tags" {
  type = map(string)
}