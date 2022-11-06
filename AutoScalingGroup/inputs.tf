variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
}

variable "availability_zone" {
  type = list(string)
}

variable "destination_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "launch_template_id" {
  type = string
}

variable "subnet_tags" {
  type = list(string)
}

variable "Keypair" {
  type    = string
  default = "srandard"
}


variable "launch_template" {
  type = object({
    ami_id        = string
    instance_type = string
  })
}
