region = "us-east-1"
availability_zone = "us-east-1a"
vpc_cidr = "10.10.0.0/16"
subnet_cidr = "10.10.0.0/24"
destination_cidr = "0.0.0.0/0"
trigger_number  = "1.2"
ec2_details = {
  ami_id = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  keypair = "standard"
}
