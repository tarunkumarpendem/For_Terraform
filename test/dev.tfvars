region = "us-east-1"
network_details = {
  azs                 = ["us-east-1a", "us-east-1b"]
  cidr_block          = "10.10.0.0/16"
  destination_cidr    = "0.0.0.0/0"
  igw_tag             = "test-igw"
  protocol            = "TCP"
  route_table_tag     = "test-rt"
  security_group_name = "test-sg"
  security_group_tag  = "sg-test"
  subnet_cidrs        = ["10.10.0.0/24", "10.10.1.0/24"]
  subnet_tags         = ["subnet-1", "subnet-2"]
  vpc_tag             = "test-vpc"
}
instance_details = {
  ami_id        = "ami-0778521d914d23bc1"
  instance_tag  = "kaaju"
  instance_type = "t2.micro"
  key_pair      = "kaaju"
} 
