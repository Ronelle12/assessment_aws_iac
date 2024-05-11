resource "aws_network_acl" "nacls" {
  for_each = { for nacl in var.nacls : nacl.name => nacl }

  vpc_id = each.value.vpc_id

  dynamic "egress" {
    for_each = { for rule in each.value.egress : rule.rule_no => rule }

    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  dynamic "ingress" {
    for_each = { for rule in each.value.ingress : rule.rule_no => rule }

    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_network_acl_association" "nacl_associations" {
  for_each = { for nacl in var.nacls : "${nacl.name}_${nacl.subnet_id}" => nacl }

  network_acl_id = aws_network_acl.nacls[each.value.name].id
  subnet_id      = each.value.subnet_id
}