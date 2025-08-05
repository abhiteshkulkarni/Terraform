provider "aws"{
  region = "ap-south-1"
}

resource "aws_security_group" "datacenter-sg"{
name =  "datacenter-sg"
description = "Security group for Nautilus App Servers"
vpc_id = data.aws_vpc.default.id


ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    description = "Allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    description = "Allow HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
}
}

data "aws_vpc" "default"{
    default = true
}
