vpc_cidr =  [ "192.168.0.0/16","192.168.0.0/20" ] 
vpc_tags = [ "MYVPC1","MYVPC2" ]
region = "ap-south-2"
#subnet_cidr = [ "192.168.0.0/24","192.168.1.0/24","192.168.2.0/24","192.168.3.0/24" ]
availability_zone = [ "ap-south-2a","ap-south-2a","ap-south-2b","ap-south-2b" ]
subnet_tags = [ "pubsub1","pubsub2","pvtsubnet1","pvtsubnet2" ]
igw_tags = "MYIGW"
cidr_block = "0.0.0.0/0"
route_table_tags = "pubRT"
key_name = "deploykey101"
sg = {
    "sg-1" = {
  sg_name = "new-sg"  
  from_port = 22
  to_port   = 8080
  protocol   = "tcp"
  cidr_blocks = "0.0.0.0/0"
  sg_tags     = "mysg"
},
"sg-2" = {
  sg_name = "new-sg2"  
  from_port = 22
  to_port   = 80
  protocol   = "tcp"
  cidr_blocks = "0.0.0.0/0"
  sg_tags     = "mysg1"
}
}
ec2 = {
    "ec2-1" = {
        ami = "ami-053a0835435bf4f45"
        instance_type = "t3.micro"
        associate_public_ip_address = true
        delete_on_termination = true
        volume_size          = 20
        ec2_tags             = "MYEC2"
    }
}