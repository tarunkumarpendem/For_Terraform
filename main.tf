# create Auto Scaling Group
#--------------------------

# Create VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpc-tf"
  }
}


# Create Subnets
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


# Create Route to Route Table
resource "aws_route" "tf_route" {
  route_table_id         = aws_route_table.tf_Rtb.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.tf_IGW.id
  depends_on = [
    aws_route_table.tf_Rtb
  ]
}

# Associate Subnet1 to Route Table
resource "aws_route_table_association" "assc_subnet1" {
  subnet_id      = aws_subnet.tf_subnet[0].id
  route_table_id = aws_route_table.tf_Rtb.id
  depends_on = [
    aws_route_table.tf_Rtb
  ]
}


# Associate Subnet2 to Route Table
resource "aws_route_table_association" "assc_subnet2" {
  subnet_id      = aws_subnet.tf_subnet[1].id
  route_table_id = aws_route_table.tf_Rtb.id
  depends_on = [
    aws_route_table.tf_Rtb
  ]
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

# Create Launch Template 
/*resource "aws_launch_template" "tf_lt" {
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
}*/


# Auto sclaing Group
/*resource "aws_autoscaling_group" "tf_ASG" {
  name                      = "ASG_TF"
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
}*/

# create EC2 Instance
resource "aws_instance" "tf_ec2" {
  ami                         = var.launch_template.ami_id
  instance_type               = var.launch_template.instance_type
  key_name                    = var.launch_template.keypair
  subnet_id                   = aws_subnet.tf_subnet[0].id
  availability_zone           = var.availability_zone[0]
  associate_public_ip_address = true
  security_groups             = [aws_security_group.tf_sg.id]
  tags = {
    "Name" = "Terraform_EC2_Instance"
  }
  depends_on = [
    aws_security_group.tf_sg
  ]
}


# create TargetGroup
resource "aws_lb_target_group" "tf_tg" {
  name        = "TerraformTargetGroup"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf_vpc.id
  target_type = "instance"
  health_check {
    enabled  = true
    protocol = "HTTP"
    port     = "80"
    path     = "/"
  }
  tags = {
    "Name" = "Terraform_TargetGroup"
  }
  depends_on = [
    aws_vpc.tf_vpc
  ]
}


# Attach instance Target Group
resource "aws_lb_target_group_attachment" "TF_TG_Attach" {
  target_group_arn  = aws_lb_target_group.tf_tg.arn
  target_id         = aws_instance.tf_ec2.id
  port              = "80"
  #availability_zone = var.availability_zone[0]
  depends_on = [
    aws_lb_target_group.tf_tg
  ]
}


# create application load balancer
resource "aws_lb" "tf_alb" {
  name               = "Tf-ApplicationLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_sg.id]
  subnets            = [aws_subnet.tf_subnet[0].id, aws_subnet.tf_subnet[1].id]
  tags = {
    "Environment" = "Dev"
  }
  depends_on = [
    aws_lb_target_group.tf_tg
  ]
}

# create listener
resource "aws_lb_listener" "tf_alb_listener" {
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_tg.arn
  }
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = "80"
  protocol          = "HTTP"
  tags = {
    "Name" = "Listener-1"
  }
}


