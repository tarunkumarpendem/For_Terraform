# create Auto Scaling Group
#--------------------------

# Create VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpc-tf"
  }
}
output "vpc_id" {
    value = aws_vpc.tf_vpc.id
  }


# Create Subnet
resource "aws_subnet" "tf_subnet" {
  count             = length(var.availability_zone)
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id            = aws_vpc.tf_vpc.id
  tags = {
    "Name" = var.subnet_tags[count.index]
  }
  depends_on = [
    aws_vpc.tf_vpc
  ]
}
output "subnet1_id" {
  value = aws_subnet.tf_subnet[0].id
}
output "subnet2_id" {
  value = aws_subnet.tf_subnet[1].id
}
output "subnet3_id" {
  value = aws_subnet.tf_subnet[2].id
}


# Create Internet Gateway
resource "aws_internet_gateway" "tf_IGW" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    "Name" = "IGW-tf"
  }
  depends_on = [
    aws_vpc.tf_vpc
  ]
}
output "InternetGateway_id" {
  value = aws_internet_gateway.tf_IGW.id 
}

/*resource "aws_internet_gateway_attachment" "IGW-VPC" {
  internet_gateway_id = aws_internet_gateway.tf-IGW.id
  vpc_id              = aws_vpc.tf-vpc.id
}*/


# Create Route Table
resource "aws_route_table" "tf_Rtb" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    "Name" = "Rtb-tf"
  }
  depends_on = [
    aws_vpc.tf_vpc
  ]
}
output "RouteTable_id" {
  value = aws_route_table.tf_Rtb.id
}


# Create Route to Route Table
resource "aws_route" "tf_route" {
  route_table_id         = aws_route_table.tf_Rtb.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.tf_IGW.id
  depends_on = [
    aws_route_table.tf_Rtb
  ]
}

# Associate Subnet to Route Table
resource "aws_route_table_association" "assc_subnet" {
  subnet_id      = aws_subnet.tf_subnet[0].id
  route_table_id = aws_route_table.tf_Rtb.id
  depends_on = [
    aws_route_table.tf_Rtb
  ]
}
output "RouteTable_association_id" {
  value = aws_route_table_association.assc_subnet.id
}


# Create Security Group
resource "aws_security_group" "tf_sg" {
  description = "This is the sg from terraform"
  vpc_id      = aws_vpc.tf_vpc.id
  ingress {
    cidr_blocks = [var.destination_cidr]
    description = "open ssh"
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }
  ingress {
    cidr_blocks = [var.destination_cidr]
    description = "open http"
    from_port   = "80"
    protocol    = "tcp"
    to_port     = "80"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "SG-tf"
  }
}
output "SecurityGroup_id" {
  value = aws_security_group.tf_sg.id
}


# Create Launch Template 
resource "aws_launch_template" "tf_lt" {
  name     = "Terraform-launch-template"
  key_name = var.Keypair
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
    }
  }
  image_id      = var.launch_template.ami_id
  instance_type = var.launch_template.instance_type
  placement {
    availability_zone = "var.availability_zone[0]"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "LaunchTemplate-Tf"
    }
  }
  network_interfaces {
    subnet_id                   = aws_subnet.tf_subnet[0].id
    security_groups             = [aws_security_group.tf_sg.id]
    associate_public_ip_address = true
  }
  depends_on = [
    aws_security_group.tf_sg
  ]
}
output "LaunchTemplate_id" {
  value = aws_launch_template.tf_lt.id
}


# Auto sclaing Group
resource "aws_autoscaling_group" "tf_ASG" {
  name                      = "ASG-TF"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  min_size                  = "1"
  max_size                  = "3"
  availability_zones        = [var.availability_zone[0]]
  desired_capacity          = "1"
  launch_template {
    id      = aws_launch_template.tf_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Teffaform_ASG"
    propagate_at_launch = true
  }
}
output "ASG_id" {
  value = aws_autoscaling_group.tf_ASG.id  
}




