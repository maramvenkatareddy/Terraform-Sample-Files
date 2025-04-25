resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "myvpc1"
  }
}
resource "aws_subnet" "sub1" {
  cidr_block = "10.0.0.0/24"
  vpc_id =  aws_vpc.main.id #"vpc-0501eb73973a32e44"
  availability_zone = "ap-south-2a"
  tags = {
    Name = "subnet1"
  }
  depends_on = [ aws_subnet.sub2 ]
}
resource "aws_subnet" "sub2" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id #"vpc-0501eb73973a32e44"
  availability_zone = "ap-south-2b"
  tags = {
    Name = "subnet2"
  }
}
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "internet-gateway"
    }
  
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }
   tags = {
    Name = "pubRT"
   }
}
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.public.id
  
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    
   tags = {
    Name = "pvtRT"
   }
}
resource "aws_route_table_association" "name1" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.private.id
  
}
resource "aws_eip" "elastic" {
  domain = "vpc"
  tags = {
    Name = "EIP1"
  }
  
}
resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.sub1.id
  allocation_id = aws_eip.elastic.id
  tags = {
    Name = "myvpc-nat"
  }  
}
resource "aws_route" "name" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat.id
  
}
resource "aws_key_pair" "key" {
  key_name = "deploy-key111"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6DTlVcEt5Z7vv0V+bN/Op/cRL3wx51rurgTGIigqa/ljS4fSFxTZ4DkwOIzkq7Mfiub+R7A4iEZ7ChSg2Qc3oXrNVlVLn54v0fjTaZFYSxxPdIHvN0uHaiZu8mZDxUan/pTfA4RUt79ChRTpc+cLec3dWr4d8kiXhZv5rQKQqnkvTy/IK4b+Ke32VQZx9Btu1QV3N9tfQoYYhyCsugxPOpn0LId2SWj4uKbSQ2nVSM6UTMxBtHNbov3jGJYepiPZcs3HIcRjSiTYHZr1P4vB8z5udw9kKujPa8qE9wubYzYt2UAZ0rEL3B6qMNLp4mssNetccDR9CJa/NXkfX37N+k/kCxmlUFseTi+oKq0tkO/je39+sYPFxuxVzIhe9uvqQmTTAyAuSvepJ7k/ktFw7B7LqSQxqZz+2GZMtW4PjY39VfqhnQfnjc/Kp0iJ8BT3wxarHbjZru4Z9iEAup49iwaSdHp3GKi/flySUGEgS+3/gImU7/zSI4eN9MBGQzGc= namga@NAMGADDASATISH"
  tags = {
    Name = "deploy"
  }
}
resource "aws_security_group" "sec_grp" {
  vpc_id = aws_vpc.main.id
  name = "myvpc1-sg"
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "sg1"
  }
}
resource "aws_instance" "instance" {
  ami = "ami-053a0835435bf4f45"
  instance_type = "t3.micro"
  key_name = aws_key_pair.key.key_name #"deploy-key"
  vpc_security_group_ids = [ aws_security_group.sec_grp.id ] 
  associate_public_ip_address = true
  subnet_id = aws_subnet.sub1.id
  root_block_device {
    delete_on_termination = true
    volume_size  = 20
  }
  user_data = file("user-data.sh")
  tags = {
    Name = "myvm11"
  }
}