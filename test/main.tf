# vpc
resource "aws_vpc" "test_vpc" {
  cidr_block = var.network_details.cidr_block
  tags = {
    "Name" = var.network_details.vpc_tag
  }
}

#subnets
resource "aws_subnet" "test_subnets" {
  count             = length(var.network_details.azs)
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.network_details.subnet_cidrs[count.index]
  availability_zone = var.network_details.azs[count.index]
  tags = {
    "Name" = var.network_details.subnet_tags[count.index]
  }
  depends_on = [
    aws_vpc.test_vpc
  ]
}


#Internet Gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    "Name" = var.network_details.igw_tag
  }
  depends_on = [
    aws_vpc.test_vpc
  ]
}


# Route table
resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    "Name" = var.network_details.route_table_tag
  }
  depends_on = [
    aws_vpc.test_vpc
  ]
}

# Route
resource "aws_route" "test_route" {
  route_table_id         = aws_route_table.test_rt.id
  destination_cidr_block = var.network_details.destination_cidr
  gateway_id             = aws_internet_gateway.test_igw.id
}

# Associating subnets to route table
resource "aws_route_table_association" "rt_subnet_assc" {
  count          = length(var.network_details.subnet_cidrs)
  subnet_id      = aws_subnet.test_subnets[count.index].id
  route_table_id = aws_route_table.test_rt.id
  depends_on = [
    aws_route_table.test_rt
  ]
}

# Security Group
resource "aws_security_group" "test_sg" {
  vpc_id      = aws_vpc.test_vpc.id
  name        = var.network_details.security_group_name
  description = "open ssh, http"
  tags = {
    "Name" = var.network_details.security_group_tag
  }
  ingress {
    cidr_blocks = [var.network_details.destination_cidr]
    description = "open ssh"
    from_port   = 22
    protocol    = var.network_details.protocol
    to_port     = 22
  }
  ingress {
    cidr_blocks = [var.network_details.destination_cidr]
    description = "open http"
    from_port   = 80
    protocol    = var.network_details.protocol
    to_port     = 80
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.network_details.destination_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Instance
resource "aws_instance" "test_instance" {
  ami                         = var.instance_details.ami_id
  associate_public_ip_address = true
  availability_zone           = var.network_details.azs[0]
  instance_type               = var.instance_details.instance_type
  key_name                    = var.instance_details.key_pair
  security_groups             = [aws_security_group.test_sg.id]
  subnet_id                   = aws_subnet.test_subnets[0].id
  tags = {
    "Name" = var.instance_details.instance_tag
  }
}
