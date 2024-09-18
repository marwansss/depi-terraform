resource "aws_key_pair" "aws-keys" {
  key_name   = "depi"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1Aqlf4JW2nIncNCzwvcz20wM3R04t0bixnF4JrdU84hyBidHMKNsLyGPx7dSc2CfgTyXxcqwIcm55CcagGswJ72/JH2FGwjvrTRS74vv8XMO9lFE8dFqUaEZWvTikfipN4sqEe6bZQZm4k9AlJcE4UXhBhVSqESjV0sl6UPNLT/8JbaYpcHV0BNJ5m3IKZNlYVGmnjnAm0vZn5m2AxlUn42yaOC9I675WzL0W0nrZKF0PrWzHASf82fOtxsIwsodIQ5BRsFUQ+IgyGF63VixWBlz1jFeAI+05FTMFtbf9UgsDQVSlSKv4SXGZgzj7Vuk0w0FfGdDFb5Txv0WJaGrYp6MzmQXLExgpUNPoo6Y+jEsF3FdzRsCMzou8tPnjhGLjZMtSygqdozI18jUQb+v1HKjXJiAj4R/miwPRyUw+DRynYBV8BSmIzrXq9Fh/flt300vgpx0F7PqXyBeHAF96gpOOb0PipDI9MNii/eKnrr3JXuGGVcaAQP/zAwgLR28= marwan@Lenovo-IdeaPad-L340-15IWL"
}

#-----------------------------------------------------------------------------------
resource "aws_security_group" "basion-sg" {
  name        = "basion-sg"
  description = "basion-sg"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "basion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.basion-sg.id
  cidr_ipv4         = var.route-cidr
  from_port         = var.http
  ip_protocol       = "tcp"
  to_port           = var.http
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.basion-sg.id
  cidr_ipv4         = var.route-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.basion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


#-----------------------------------------------------------------------------------

resource "aws_instance" "basion-host" {
  ami           = var.ec2-ami
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "depi"
  user_data = file("./bash.sh")
  vpc_security_group_ids = [aws_security_group.basion-sg.id]
  subnet_id = aws_subnet.public-subnet.id
  
  provisioner "file" {
    source      = "/home/marwan/depi-tf/bash.sh"
    destination = "/home/ubuntu/bash.sh"
  }
   provisioner "file" {
    source      = "/home/marwan/depi-tf/provider.tf"
    destination = "/home/ubuntu/provider.tf"
  }
  
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/depi")
    host     = self.public_ip
  }
  

  tags = {
    Name = "basion-host"
  }
}

#-----------------------------------------------------------------------------------

resource "aws_instance" "nginx-host" {
  ami           = var.ec2-ami
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "depi"
  vpc_security_group_ids = [aws_security_group.basion-sg.id]
  subnet_id = aws_subnet.public-subnet.id
  

  tags = {
    Name = "nginx-host"
  }
    connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/depi")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"
    ]
  }
}

#-----------------------------------------------------------------------------------


resource "aws_instance" "private-host" {
  ami           = var.ec2-ami
  instance_type = "t2.micro"
  associate_public_ip_address = false
  key_name = "depi"
  user_data = file("./bash.sh")
  vpc_security_group_ids = [aws_security_group.basion-sg.id]
  subnet_id = aws_subnet.private-subnet.id

  tags = {
    Name = "private-host"
  }
}