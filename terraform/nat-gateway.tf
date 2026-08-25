resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "employee-mgmt-nat-eip"
  }
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "employee-mgmt-nat"
  }
}