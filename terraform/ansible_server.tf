resource "aws_subnet" "ansible_subnet" {
  vpc_id = aws_vpc.remote_vpc.id
  cidr_block = "10.1.0.0/24"
  tags = {
    Name = "ansible-subnet"
  }
}

