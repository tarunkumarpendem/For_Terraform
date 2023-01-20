variable "region" {
  type = string
}

variable "network_details" {
  type = object({
    cidr_block          = string
    vpc_tag             = string
    subnet_cidrs        = list(string)
    subnet_tags         = list(string)
    azs                 = list(string)
    igw_tag             = string
    route_table_tag     = string
    destination_cidr    = string
    security_group_name = string
    security_group_tag  = string
    protocol            = string
  })
}

variable "instance_details" {
  type = object({
    ami_id        = string
    instance_type = string
    key_pair      = string
    instance_tag  = string
  })
}
