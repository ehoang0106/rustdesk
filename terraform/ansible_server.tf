resource "aws_subnet" "ansible_subnet" {
  vpc_id     = aws_vpc.remote_vpc.id
  cidr_block = "10.1.0.0/24"
  tags = {
    Name = "ansible-subnet"
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

resource "aws_route_table_association" "ansible_route_table_association" {
  subnet_id      = aws_subnet.ansible_subnet.id
  route_table_id = aws_route_table.remote_route_table.id
}

resource "aws_instance" "ansible_server" {
  ami             = "ami-07d2649d67dbe8900" #ubuntu
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.ansible_subnet.id
  security_groups = [aws_security_group.ansible_sg.id]
  key_name        = "ansible-kp"
  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name = "ansible-server"
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