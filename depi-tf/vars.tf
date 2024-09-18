variable "vpc-cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "public-subnet-cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "private-subnet-cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "route-cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "ec2-ami" {
  type = string
  default = "ami-0e86e20dae9224db8"
}

variable "http" {
  type = number
  default = 80
}