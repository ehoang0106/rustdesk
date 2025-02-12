variable "region" {
  default = "us-west-1"
}

variable "instance_type" {
  default = "t2.micro"
  description = "instance type"
}

variable "instance_name" {
  default = "rustdesk"
  description = "instance name"
}

variable "subnet_name" {
  default = "rustdesk-subnet"
  type = string
}

variable "security_group_name" {
  default = "rustdesk-security-group"
  type = string
}

variable "vpc_name" {
  default = "rustdesk-vpc"
  type = string
}