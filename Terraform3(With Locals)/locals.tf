locals {
  vpc_cidr = [ "192.168.0.0/16","192.168.0.0/20" ]
  vpc_tags  = [ "MYVPC1","MYVPC2" ]
  availability_zone = [ "ap-south-2a", "ap-south-2b" ]
  subnet_tags  = [ "pubsub1","pubsub2" ]
  sg = {
     "sg-1" = {
         name = "sg1"
         from_port = 0
         to_port   = 65535
         protocol  = "tcp"
         cidr_blocks = "0.0.0.0/0"
         sg_tags     = "mysg1"
     }
  }

}