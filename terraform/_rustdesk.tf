#rustdesk server

#create a subnet
resource "aws_subnet" "rustdesk_subnet" {
  vpc_id     = aws_vpc.remote_vpc.id
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = var.rustdesk_subnet_name
  }
}

#associate subnet with route table
resource "aws_route_table_association" "rustdesk_route_table_association" {
  subnet_id      = aws_subnet.rustdesk_subnet.id
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
    Name = var.rustdesk_security_group_name
  }

}

#allocate an elastic ip
resource "aws_eip" "rustdesk_eip" {
  instance = aws_instance.rustdesk_instance.id
}

#create a network interface to assign private ipv4 for instance
resource "aws_network_interface" "rustdesk_network_interface" {
  subnet_id   = aws_subnet.rustdesk_subnet.id
  private_ips = ["10.0.1.69"]
  security_groups = [aws_security_group.rustdesk_security_group.id]

  attachment {
    instance = aws_instance.rustdesk_instance.id
    device_index = 1
  }
}

#create ec2 instance

resource "aws_instance" "rustdesk_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.rustdesk_subnet.id
  vpc_security_group_ids = [aws_security_group.rustdesk_security_group.id]
  key_name               = "rustdesk-key"
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name = var.rustdesk_instance_name
  }

  associate_public_ip_address = true
}