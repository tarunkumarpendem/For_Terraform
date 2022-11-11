# Vpc_Id
output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}

# Subnet_Id'
output "subnet_id" {
  value = aws_subnet.dev_subnet.id
}

# Internet_Gateway_Id
output "InternetGateway_id" {
  value = aws_internet_gateway.dev_IGW.id
}

# Route_Table_Id
output "RouteTable_id" {
  value = aws_route_table.dev_Rtb.id
}

# Route_Table_association_Id1
output "RouteTable_association_id" {
  value = aws_route_table_association.assc_subnet.id
}

# Security_Group_Id
output "SecurityGroup_id" {
  value = aws_security_group.dev_sg.id
}



# Instance_Id
output "Instance_Id" {
  value = aws_instance.dev_ec2.id
}

# Instance_url
output "Instance_url" {
  value = format("http://%s", aws_instance.dev_ec2.public_ip)
}

