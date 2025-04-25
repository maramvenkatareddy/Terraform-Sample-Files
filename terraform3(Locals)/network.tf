resource "aws_vpc" "main" {
  count = length(local.vpc_tags)
  cidr_block = local.vpc_cidr[count.index]
  instance_tenancy = "default"
  tags = {
    Name = local.vpc_tags[count.index]
  }
}
resource "aws_subnet" "subnet" {
  count = length(local.subnet_tags)
  cidr_block = cidrsubnet(local.vpc_cidr[0],8,count.index) #var.subnet_cidr[count.index]
  vpc_id = aws_vpc.main[0].id
  availability_zone = local.availability_zone[count.index]
  tags = {
     Name = local.subnet_tags[count.index]
  }
  
}
resource "aws_security_group" "sec_grp" {
  #for_each = { for k, sg in var.sg : k => sg}
  for_each = local.sg
  vpc_id = aws_vpc.main[0].id
  name = each.value.name
  ingress {
    from_port = each.value.from_port
    to_port = each.value.to_port
    protocol = each.value.protocol
    cidr_blocks = [ each.value.cidr_blocks ]
  }
  egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = each.value.sg_tags
  }
}
