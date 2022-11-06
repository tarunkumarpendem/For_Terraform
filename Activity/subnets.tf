resource "aws_vpc" "tfvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "terraform-vpc"
  }
}

resource "aws_subnet" "tfsubnets" {
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.tfvpc.id
  depends_on = [
    aws_vpc.tfvpc
  ]
  tags = {
    "Name" = "subnet1"
  }
}
