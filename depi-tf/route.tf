resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.route-cidr
    gateway_id = aws_internet_gateway.igw.id
  }

 
  tags = {
    Name = "public-rt"
  }
}

#-----------------------------------------------------------------------------------
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.route-cidr
    gateway_id = aws_nat_gateway.main_nat_gw.id
  }


  tags = {
    Name = "private-rt"
  }
}

#-----------------------------------------------------------------------------------
resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}
#-----------------------------------------------------------------------------------

resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}
#-----------------------------------------------------------------------------------
