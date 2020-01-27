resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = format("%s-subnet-public-%s", var.name, element(split("-", element(var.azs, count.index)), 2)) })
}
