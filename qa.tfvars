region = "us-west-2"
availability_zone = ["us-west-2a", "us-west-2b"]
vpc_cidr = "172.168.0.0/16"
subnet_cidr = ["172.168.0.0/24", "172.168.1.0/24"]
destination_cidr = "0.0.0.0/0"
trigger_number  = "1.2"
ec2_details = {
  ami_id = "ami-0c09c7eb16d3e8e70"
  instance_type = "t2.micro"
  keypair = "standard"
}
