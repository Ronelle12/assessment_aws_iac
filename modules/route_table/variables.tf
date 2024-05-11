variable "route_tables" {
  type = list(object({
    name      = string
    vpc_id    = string
    is_igw_rt = bool

    routes = list(object({
      cidr_block = string
      igw_id     = optional(string)
      nat_gw_id  = optional(string)
    }))

    tags = map(string)
  }))
}