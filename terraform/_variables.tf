variable "vpc_name" {
  default = "remote_vpc"
  type    = string
}

variable "region" {
  default = "us-west-1"
}

variable "ami_id" {
  default = "ami-07d2649d67dbe8900" 
}

variable "instance_type" {
  default     = "t2.micro"
  description = "instance type"
}

variable "rustdesk_instance_name" {
  default     = "rustdesk_server"
  description = "instance name"
}

variable "rustdesk_subnet_name" {
  default = "rustdesk_subnet"
  type    = string
}

variable "rustdesk_security_group_name" {
  default = "rustdesk_sg"
  type    = string
}

