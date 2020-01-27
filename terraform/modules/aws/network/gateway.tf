resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.common_tags, { Name = format("%s-igw", var.name) })
}

resource "aws_eip" "nat_gateway" {
  count = length(var.azs)

  vpc = true

  tags = merge(var.common_tags, { Name = format("%s-nat-%s", var.name, element(split("-", element(var.azs, count.index)), 2)) })

  depends_on = ["aws_internet_gateway.internet_gateway"]
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.azs)

  subnet_id     = element(aws_subnet.public[*].id, count.index)
  allocation_id = element(aws_eip.nat_gateway[*].id, count.index)

  tags = merge(var.common_tags, { Name = format("%s-gw-%s", var.name, element(split("-", element(var.azs, count.index)), 2)) })
}
