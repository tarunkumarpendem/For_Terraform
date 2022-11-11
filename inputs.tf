variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "subnet_cidr" {
  type    = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "destination_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "Keypair" {
  type    = string
  default = "srandard"
}


variable "ec2_details" {
  type = object({
    ami_id        = string
    instance_type = string
    keypair       = string
  })
}

variable "trigger_number" {
  type = string
}
