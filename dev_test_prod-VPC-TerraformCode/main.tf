provider "aws" {

  alias  = "ap-south-1"
  region = "ap-south-2"

}

locals {

  instance_type = {

    dev  = "t2.micro"
    test = "t2.small"
    prod = "t2.medium"

  }
}
resource "aws_vpc" "main" {

  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {

    Name = "${terraform.workspace}-vpc"

  }
}

resource "aws_subnet" "public" {

  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {

    Name = "${terraform.workspace}-public_subnet-${count.index + 1}"

  }

}

resource "aws_subnet" "private" {

  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {

    Name = "${terraform.workspace}-private_subnet-${count.index + 1}"

  }

}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {

    Name = "${terraform.workspace}-igw"

  }

}


resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {

    Name = "${terraform.workspace}-public-rt"

  }

}



resource "aws_route_table_association" "public" {

  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {

    Name = "${terraform.workspace}-nat-eip"

  }
}

resource "aws_nat_gateway" "public" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

}


resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public.id

  }

  tags = {

    Name = "${terraform.workspace}-private-route-table"

  }
}

resource "aws_route_table_association" "private" {

  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id

}

resource "aws_security_group" "web-sg" {

  description = "Allow ssh and http protocol"
  vpc_id      = aws_vpc.main.id
  name        = "${terraform.workspace}-web-sg"


  ingress {

    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {

    Name = "${terraform.workspace}-web-sg"

  }
}



resource "aws_instance" "pubinstance" {

  ami                    = var.instance_ami
  instance_type          = local.instance_type[terraform.workspace]
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = var.key_name


  tags = {

    Name = "${terraform.workspace}-bastion"

  }
}

resource "aws_instance" "pvtinstance" {
  ami                    = var.instance_ami
  instance_type          = local.instance_type[terraform.workspace]
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = var.key_name

  tags = {

    Name = "${terraform.workspace}-DB-Server"

  }
}
