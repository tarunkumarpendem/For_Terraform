# create Auto Scaling Group
#--------------------------

# Create VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "Dev_Vpc"
  }
}


# Create Subnets
resource "aws_subnet" "dev_subnet" {
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.dev_vpc.id
  tags = {
    "Name" = "Dev_App_Subnet"
  }
  depends_on = [
    aws_vpc.dev_vpc
  ]
}

# Create Internet Gateway
resource "aws_internet_gateway" "dev_IGW" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    "Name" = "Dev_IGW"
  }
  depends_on = [
    aws_vpc.dev_vpc
  ]
}



# Create Route Table
resource "aws_route_table" "dev_Rtb" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    "Name" = "Dev_Rtb"
  }
  depends_on = [
    aws_vpc.dev_vpc
  ]
}


# Create Route to Route Table
resource "aws_route" "dev_rtb_route" {
  route_table_id         = aws_route_table.dev_Rtb.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.dev_IGW.id
  depends_on = [
    aws_route_table.dev_Rtb
  ]
}

# Associate Subnet to Route Table
resource "aws_route_table_association" "assc_subnet" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_Rtb.id
  depends_on = [
    aws_route_table.dev_Rtb
  ]
}


# Create Security Group
resource "aws_security_group" "dev_sg" {
  description = "This is the sg from terraform for dev environment"
  vpc_id      = aws_vpc.dev_vpc.id
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
  ingress {
    cidr_blocks = [var.destination_cidr]
    description = "open 8080"
    from_port   = "8080"
    protocol    = "tcp"
    to_port     = "8080"
  }
  ingress {
    cidr_blocks = [var.destination_cidr]
    description = "open 8081"
    from_port   = "8081"
    protocol    = "tcp"
    to_port     = "8081"
  }
  ingress {
    cidr_blocks = [var.destination_cidr]
    description = "open 4200"
    from_port   = "4200"
    protocol    = "tcp"
    to_port     = "4200"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "dev_sg"
  }
}


# create EC2 Instance
resource "aws_instance" "dev_ec2" {
  ami                         = var.ec2_details.ami_id
  instance_type               = var.ec2_details.instance_type
  key_name                    = var.ec2_details.keypair
  subnet_id                   = aws_subnet.dev_subnet.id
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  security_groups             = [aws_security_group.dev_sg.id]
  tags = {
    "Name" = "Dev_EC2_Instnace"
  }
  depends_on = [
    aws_security_group.dev_sg
  ]
}

# null resource 
resource "null_resource" "dev_null" {
  triggers = {
    "trigger_number" = var.trigger_number
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.dev_ec2.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "sudo apt update",
      "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -",
      "sudo apt -y install nodejs",
      "sudo -i"
      /*"git clone https://github.com/gothinkster/angular-realworld-example-app.git",
      "cd angular-realworld-example-app/",
      "npm install -g @angular/cli@8",
      "npm install",
      "ng serve"*/
    ]
  }
}


