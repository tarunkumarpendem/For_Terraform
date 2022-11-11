# Vpc_Id
output "vpc_id" {
  value = aws_vpc.qa_vpc.id
}

# Subnet_Id'
output "subnet1_id" {
  value = aws_subnet.qa_subnet[0].id
}
output "subnet2_id" {
  value = aws_subnet.qa_subnet[1].id
}

# Route_Table_Id
output "RouteTable_id" {
  value = aws_route_table.qa_Rtb.id
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
  value = aws_security_group.qa_sg.id
}



# Instance_Id
output "Instance1_Id" {
  value = aws_instance.qa_ec2[0].id
}
output "Instance2_Id" {
  value = aws_instance.qa_ec2[1].id
}

# Elastic ip
output "elastic_ip" {
  value = aws_eip.elastic_ip.allocation_id 
}

# TargetGroup_ARN
output "TargetGroup_ARN" {
  value = aws_lb_target_group.qa_tg.arn
}


# TargetGroupAttachment_Id
output "TG_Attach_Id" {
  value = aws_lb_target_group_attachment.QA_TG_Attach.id
}

# Application_Load_Balancer_Id
output "ALB_arn" {
  value = aws_lb.qa_alb.id 
}

# Application load balancer DNS Name    
output "ALB_DNS" {
  value = aws_lb.qa_alb.dns_name
}                            

# Listener_Id
output "Listener_arn" {
  value = aws_lb_listener.qa_alb_listener.id  
}
