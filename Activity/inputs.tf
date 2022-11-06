variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"

}


variable "subnet_cidr" {
  type = string
}

variable "availability_zone" {
  type = string
}
