# Create public subnets
resource "aws_subnet" "public_subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if subnet.is_public }

  vpc_id                              = each.value.vpc_id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  map_public_ip_on_launch             = each.value.map_public_ip_on_launch
  private_dns_hostname_type_on_launch = each.value.private_dns_hostname_type_on_launch

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

# Associate public subnets with their route table
resource "aws_route_table_association" "public_subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if subnet.is_public }

  subnet_id      = aws_subnet.public_subnets[each.value.name].id
  route_table_id = each.value.route_table_id
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if !subnet.is_public }

  vpc_id                              = each.value.vpc_id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  private_dns_hostname_type_on_launch = each.value.private_dns_hostname_type_on_launch

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

# Associate private subnets with their route table
resource "aws_route_table_association" "private_subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet if !subnet.is_public }

  subnet_id      = aws_subnet.private_subnets[each.value.name].id
  route_table_id = each.value.route_table_id
}