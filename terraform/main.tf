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
  vpc_id        = aws_vpc.remote_vpc.id
  cidr_block    = "10.1.0.0/16"
}

#create a subnet
resource "aws_subnet" "rustdesk-subnet" {
  vpc_id     = aws_vpc.remote_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = var.subnet_name
  }
}

#create a internet gateway
resource "aws_internet_gateway" "rustdesk_igw" {
  vpc_id = aws_vpc.remote_vpc.id

  tags = {
    Name = "rustdesk-internet-gateway"
  }
}

#create a route table
resource "aws_route_table" "remote_route_table" {
  vpc_id = aws_vpc.remote_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rustdesk_igw.id
  }
}

#associate subnet with vpc
resource "aws_route_table_association" "remote_route_table_association" {
  subnet_id      = aws_subnet.rustdesk-subnet.id
  route_table_id = aws_route_table.remote_route_table.id
}

#create a security group
resource "aws_security_group" "rustdesk_security_group" {
  vpc_id = aws_vpc.remote_vpc.id

  #inboudn rules

  ingress {
    from_port   = 21115
    to_port     = 21119
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 21116
    to_port     = 21116
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }

}

#create a network acl
resource "aws_network_acl" "rustdesk_network_acl" {
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
    Name = "rustdesk-network-acl"
  }
}

#allocate an elastic ip
resource "aws_eip" "rustdesk_eip" {
  instance = aws_instance.rustdesk_instance.id
}

#print out the ec2 name, subnet name, security group, vpc name, and elastic ip
output "ec2_name" {
  value = aws_instance.rustdesk_instance.tags.Name
}

output "subnet_name" {
  value = aws_subnet.rustdesk-subnet.tags.Name
}

output "security_group" {
  value = aws_security_group.rustdesk_security_group.tags.Name
}

output "vpc_name" {
  value = aws_vpc.remote_vpc.tags.Name
}

output "elastic_ip" {
  value = aws_eip.rustdesk_eip.public_ip
}

output "instance_ip" {
  value = aws_instance.rustdesk_instance.public_ip
}

#create ec2 instance
resource "aws_instance" "rustdesk_instance" {
  ami                    = "ami-07d2649d67dbe8900" #ubuntu
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.rustdesk-subnet.id
  vpc_security_group_ids = [aws_security_group.rustdesk_security_group.id]
  key_name = "rustdesk-kp"
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }

  associate_public_ip_address = true
}