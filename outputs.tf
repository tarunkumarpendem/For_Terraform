# Vpc_Id
output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

# Subnet_Id's
output "subnet1_id" {
  value = aws_subnet.tf_subnet[0].id
}
output "subnet2_id" {
  value = aws_subnet.tf_subnet[1].id
}
output "subnet3_id" {
  value = aws_subnet.tf_subnet[2].id
}

# Internet_Gateway_Id
output "InternetGateway_id" {
  value = aws_internet_gateway.tf_IGW.id
}

# Route_Table_Id
output "RouteTable_id" {
  value = aws_route_table.tf_Rtb.id
}

# Route_Table_association_Id1
output "RouteTable_association_id1" {
  value = aws_route_table_association.assc_subnet1.id
}

# Route_Table_association_Id2
output "RouteTable_association_id2" {
  value = aws_route_table_association.assc_subnet2.id
}

# Security_Group_Id
output "SecurityGroup_id" {
  value = aws_security_group.tf_sg.id
}


# Launch_Template_Id
/*output "LaunchTemplate_id" {
  value = aws_launch_template.tf_lt.id
}*/


# AutoScalingGroup_Id
/*output "ASG_id" {
  value = aws_autoscaling_group.tf_ASG.id
}*/

# Instance_Id
output "Instance_Id" {
  value = aws_instance.tf_ec2.id
}

# Instance_url
output "Instance_url" {
  value = format("http://%s", aws_instance.tf_ec2.public_ip)
}


# TargetGroup_ARN
output "TargetGroup_ARN" {
  value = aws_lb_target_group.tf_tg.arn
}


# TargetGroupAttachment_Id
output "TG_Attach_Id" {
  value = aws_lb_target_group_attachment.TF_TG_Attach.id
}

# Application_Load_Balancer_Id
output "ALB_arn" {
  value = aws_lb.tf_alb.id 
}

# Application load balancer DNS Name    
output "ALB_DNS" {
  value = aws_lb.tf_alb.dns_name
}                            

# Listener_Id
output "Listener_arn" {
  value = aws_lb_listener.tf_alb_listener.id  
}

# Subnet Group Id
output "SubentGroup_Id" {
  value = aws_db_subnet_group.tf_subnetgroup.id
}

# Subnet Group Name
output "SubentGroup_Name" {
  value = aws_db_subnet_group.tf_subnetgroup.name
}

# mysql db id
output "mysql_db_Id" {
  value = aws_db_instance.tf_mysql_db.id
}