variable "nacls" {
  type = list(object({
    name   = string
    vpc_id = string
    egress = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
    ingress = list(object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
    subnet_id = string
    tags      = map(string)
  }))
}