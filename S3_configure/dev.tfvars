region            = "us-east-1"
vpc_cidr          = "10.10.0.0/16"
subnet_cidr       = ["10.10.0.0/24", "10.10.1.0/24"]
availability_zone = ["us-east-1a", "us-east-1b"]
destination_cidr  = "0.0.0.0/0"
subnet_tags       = ["tf-subnet-1", "tf-subnet-2"]
ec2_details = {
  ami_id        = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  keypair       = "standard"
  trigger       = "1.0"
}
