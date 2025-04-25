resource "aws_vpc" "main" {
  count = length(var.vpc_tags)
  cidr_block = var.vpc_cidr[count.index] #"10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_tags[count.index]#"myvpc1"
  }
}
resource "aws_subnet" "subnet" {
  count = length(var.subnet_tags)
  cidr_block = cidrsubnet(var.vpc_cidr[0],8,count.index)#var.subnet_cidr[count.index]
  vpc_id = aws_vpc.main[0].id
  availability_zone = var.availability_zone[count.index]
  tags = {
     Name = var.subnet_tags[count.index]
  }
  
}
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.main[0].id
    tags = {
        Name = var.igw_tags
    }
  
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main[0].id
    route {
        cidr_block = var.cidr_block
        gateway_id = aws_internet_gateway.gateway.id
    }
   tags = {
    Name = var.route_table_tags
   }
}
resource "aws_route_table_association" "name" {
      subnet_id = aws_subnet.subnet[0].id
    route_table_id = aws_route_table.public.id
  
}
resource "aws_key_pair" "key" {
  key_name = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
  tags = {
    Name = "deploy"
  }
}
resource "aws_security_group" "sec_grp" {
  for_each = { for k, value in var.sg : k => value }
  vpc_id = aws_vpc.main[0].id
  name = each.value.sg_name
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
resource "aws_instance" "instance" {
  for_each = { for k, v in var.ec2 : k => v }
  ami = each.value.ami
  instance_type = each.value.instance_type
  key_name = aws_key_pair.key.key_name #"deploy-key"
  vpc_security_group_ids = [ aws_security_group.sec_grp["sg1"].id ] 
  associate_public_ip_address = each.value.associate_public_ip_address
  subnet_id = aws_subnet.subnet[0].id
  root_block_device {
    delete_on_termination = each.value.delete_on_termination
    volume_size  = each.value.volume_size
  }
  user_data = file("user-data.sh")
  tags = {
    Name = each.value.ec2_tags
  }
  
}


