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

# Associate Subnet to Route Table
resource "aws_route_table_association" "assc_subnet" {
  subnet_id      = aws_subnet.tf_subnet[0].id
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



# create EC2 Instance
resource "aws_instance" "tf_ec2" {
  ami                         = var.ec2_details.ami_id
  instance_type               = var.ec2_details.instance_type
  key_name                    = var.ec2_details.keypair
  subnet_id                   = aws_subnet.tf_subnet[0].id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.tf_sg.id]
  tags = {
    "Name" = "Terraform_EC2_Instance"
  }
  depends_on = [
    aws_security_group.tf_sg
  ]
}


resource "null_resource" "nullresource" {
  triggers = {
    trigger_number = var.ec2_details.trigger
  }
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.tf_ec2.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo apt install tree unzip -y"
    ]
  }
  depends_on = [
    aws_instance.tf_ec2
  ]  
}


