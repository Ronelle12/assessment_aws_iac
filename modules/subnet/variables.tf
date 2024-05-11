variable "subnets" {
  type = list(object({
    name                                = string
    vpc_id                              = string
    cidr_block                          = string
    availability_zone                   = optional(string)
    map_public_ip_on_launch             = optional(bool, true)
    private_dns_hostname_type_on_launch = optional(string, "resource-name")
    is_public                           = optional(bool, true)
    route_table_id                      = string
    tags                                = map(string)
  }))
}