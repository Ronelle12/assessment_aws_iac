resource "aws_route_table" "route_tables" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  vpc_id = each.value.vpc_id

  dynamic "route" {
    for_each = { for route in each.value.routes : route.cidr_block => route if each.value.is_igw_rt }

    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.igw_id
    }
  }

  dynamic "route" {
    for_each = { for route in each.value.routes : route.cidr_block => route if !each.value.is_igw_rt }

    content {
      cidr_block     = route.value.cidr_block
      nat_gateway_id = route.value.nat_gw_id
    }
  }

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

