# Vpc_Id
output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

# Subnets_Id
output "subnet1_id" {
  value = aws_subnet.tf_subnet[0].id
}
output "subnet2_id" {
  value = aws_subnet.tf_subnet[1].id
}

# Internet_Gateway_Id
output "InternetGateway_id" {
  value = aws_internet_gateway.tf_IGW.id
}


# RouteTable_id
output "RouteTable_id" {
  value = aws_route_table.tf_Rtb.id
}

# RouteTable_Association_Id
output "RouteTable_association_id" {
  value = aws_route_table_association.assc_subnet.id
}

# Security_Group_Id
output "SecurityGroup_id" {
  value = aws_security_group.tf_sg.id
}


# EC2_Instance_Id
output "Instance_Id" {
  value = aws_instance.tf_ec2.id
}

# EC2_Instance_url
output "Instance_url" {
    value = format("http://%s", aws_instance.tf_ec2.public_ip)
}