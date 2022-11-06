region             = "us-east-1"
vpc_cidr           = "10.10.0.0/16"
subnet_cidr        = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
availability_zone  = ["us-east-1a", "us-east-1b", "us-east-1c"]
destination_cidr   = "0.0.0.0/0"
launch_template_id = "lt-0821cc4e36f845ee6"
subnet_tags        = ["tf-subnet-1", "tf-subnet-2", "tf-subnet-3"]
Keypair            = "standard"
launch_template = {
  ami_id = "ami-0169e00b74f2bb482"
  instance_type = "t2.micro"
}
