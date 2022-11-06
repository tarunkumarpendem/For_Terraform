resource "aws_vpc" "main" {
  cidr_block       = var.Required_cidr
  
    tags = {
    Name = "Terraform-vpc"
  }
}
