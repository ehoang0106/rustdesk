#create a vpc
resource "aws_vpc" "remote_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

#second cidr block for second subnet
resource "aws_vpc_ipv4_cidr_block_association" "second_cidr_block" {
  vpc_id     = aws_vpc.remote_vpc.id
  cidr_block = "10.1.0.0/16"
}

#create a internet gateway
resource "aws_internet_gateway" "remote_igw" {
  vpc_id = aws_vpc.remote_vpc.id

  tags = {
    Name = "remote_igw"
  }
}

#create a route table
resource "aws_route_table" "remote_route_table" {
  vpc_id = aws_vpc.remote_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.remote_igw.id
  }
}

#create a network acl
resource "aws_network_acl" "remote_nacl" {
  vpc_id = aws_vpc.remote_vpc.id

  #inbound rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  #outbound rules

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "remote_nacl"
  }
}

#print out the ec2 name, subnet name, security group, vpc name, and elastic ip
output "rustdesk_ec2_name" {
  value = aws_instance.rustdesk_instance.tags.Name
}

output "rustdesk_subnet_name" {
  value = aws_subnet.rustdesk_subnet.tags.Name
}

output "rustdesk_security_group" {
  value = aws_security_group.rustdesk_security_group.tags.Name
}

output "vpc_name" {
  value = aws_vpc.remote_vpc.tags.Name
}

output "rustdesk_instance_ip" {
  value = aws_instance.rustdesk_instance.public_ip
}


######################################
######################################

