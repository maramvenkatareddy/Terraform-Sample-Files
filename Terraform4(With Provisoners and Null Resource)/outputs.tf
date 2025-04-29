output "vpcids" {
    value = [ aws_vpc.main[0].id,aws_vpc.main[1].id ]
}
output "subnet_ids" {
  value = [for i, subnet in aws_subnet.subnet : subnet.id if i == 1 || i == 3]
}
output "sg_ids" {
  value = { for k, sg in aws_security_group.sec_grp : k => sg.id }
}
output "ec2_ids" {
  value = { for k, ec2 in aws_instance.instance : k => ec2.id }
}