resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
  }
}
#-----------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}
#-----------------------------------------------------------------------------------
resource "aws_eip" "Elb" {
  domain   = "vpc"
}
#-----------------------------------------------------------------------------------
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private-subnet-cidr

  tags = {
    Name = "private-subnet"
  }
}
#-----------------------------------------------------------------------------------

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public-subnet-cidr

  tags = {
    Name = "public-subnet"
  }
}
#-----------------------------------------------------------------------------------
resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.Elb.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


