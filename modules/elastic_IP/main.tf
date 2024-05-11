resource "aws_eip" "eip" {
  vpc = var.in_vpc

  tags = merge(var.tags, {})
}
