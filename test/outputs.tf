output "Vpc_Id" {
  value = aws_vpc.test_vpc.id
}

output "Subnet_1_Id" {
  value = aws_subnet.test_subnets[0].id
}

output "Subnet_2_Id" {
  value = aws_subnet.test_subnets[1].id
}

output "Igw_Id" {
  value = aws_internet_gateway.test_igw.id
}

output "Route_Table_Id" {
  value = aws_route_table.test_rt.id
}

output "Route_Table_assc_Id_1" {
  value = aws_route_table_association.rt_subnet_assc[0].id
}

output "Route_Table_assc_Id_2" {
  value = aws_route_table_association.rt_subnet_assc[1].id
}

output "Security_Group_Id" {
  value = aws_security_group.test_sg.id
}

output "Instance_Id" {
  value = aws_instance.test_instance.id
}

output "instance_public_ip" {
    value = aws_instance.test_instance.public_ip
}

/*output "instance_credentials" {
    value = format("http://%s", aws_instance.test_instance.public_ip)
}*/

# output "instance_credentials" {
#     value = format("ssh%s", "ubuntu@aws_instance.test_instance.public_ip")
# }
