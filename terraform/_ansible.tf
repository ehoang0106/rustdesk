#ansible server

resource "aws_subnet" "ansible_subnet" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.second_cidr_block.vpc_id
  cidr_block = "10.1.0.0/20"
  tags = {
    Name = "ansible_subnet"
  }
}

#allocate eip for ansible server
resource "aws_eip" "ansible_eip" {
  instance = aws_instance.ansible_server.id
}

resource "aws_security_group" "ansible_sg" {
  vpc_id = aws_vpc.remote_vpc.id

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
    Name = "ansible_sg"
  }
}
#associate subnet with route table
resource "aws_route_table_association" "ansible_route_table_association" {
  subnet_id      = aws_subnet.ansible_subnet.id
  route_table_id = aws_route_table.remote_route_table.id
}

#create a network interface to assign private ipv4 for instance
resource "aws_network_interface" "ansible_network_interface" {
  subnet_id   = aws_subnet.ansible_subnet.id
  private_ips = ["10.1.1.69"]
  security_groups = [aws_security_group.ansible_sg.id]

  attachment {
    instance = aws_instance.ansible_server.id
    device_index = 1
  }

  tags = {
    Name = "ansible_network_interface"
  }
}


#create ec2 instance
resource "aws_instance" "ansible_server" {
  ami             = var.ami_id #ubuntu
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.ansible_subnet.id
  security_groups = [aws_security_group.ansible_sg.id]
  key_name        = "ansible-kp"
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }
  
  user_data = base64encode(data.template_file.user_data.rendered)
  tags = {
    Name = "ansible_server"
  }

  associate_public_ip_address = true
}


output "ansible_ec2_name" {
  value = aws_instance.ansible_server.tags.Name
}

output "ansible_subnet_name" {
  value = aws_subnet.ansible_subnet.tags.Name
}

output "ansible_security_group" {
  value = aws_security_group.ansible_sg.tags.Name
}

output "ansible_instance_ip" {
  value = aws_instance.ansible_server.public_ip
}