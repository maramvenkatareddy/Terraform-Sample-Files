variable "vpc_cidr" {
    type = list(string)
    #default = "10.0.0.0/16"
}
variable "vpc_tags" {
    type = list(string)
    #default = "myvpc101"
}
variable "region" {
    type = string
    default = "ap-south-2"
}
/*variable "subnet_cidr" {
  type = list(string)
}*/
variable "availability_zone" {
    type = list(string)
  
}
variable "subnet_tags" {
    type = list(string)
  
}
variable "igw_tags" {
  type = string
}
variable "cidr_block" {
    type = string
  
}
variable "route_table_tags" {
  type = string
}
variable "key_name" {
    type = string
  
}
variable "sg" {
    type = map(object({
      sg_name = string
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = string
     sg_tags      = string 
    }))
  
}
variable "ec2" {
  type = map(object({
    ami = string
    instance_type = string
    associate_public_ip_address = bool
    delete_on_termination = bool
    volume_size = number
    ec2_tags   = string 
  }))
}
