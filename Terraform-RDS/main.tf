provider "aws" {

region = "ap-south-1"

}

resource "aws_vpc" "main" {
cidr_block = "192.168.0.0/16"
enable_dns_support = true
enable_dns_hostnames = true
tags = {
Name = "main-vpc"
}
}
resource "aws_subnet" "public" {
vpc_id = aws_vpc.main.id
cidr_block = "192.168.1.0/24"
map_public_ip_on_launch = true
availability_zone = "ap-south-1a"
tags = {
Name = "public-subnet"
}
}
resource "aws_subnet" "private" {
vpc_id = aws_vpc.main.id
cidr_block = "192.168.2.0/24"
availability_zone = "ap-south-1a"
tags = {
Name = "private-subnet"
}
}
resource "aws_db_subnet_group" "db_subnet_group" {
name = "db-subnet-group"
subnet_ids = [aws_subnet.private.id]
tags = {
Name = "db-subnet-group"
}
}
resource "aws_security_group" "db_sg" {
vpc_id = aws_vpc.main.id
name = "db-sg"
description = "Security group for RDS instance"
ingress {
from_port = 3306
to_port = 3306
protocol = "tcp"  
cidr_blocks = ["0.0.0.0/0"]
}
egress {  
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {  
Name = "db-sg"
}
}
resource "aws_db_instance" "db_instance" {
allocated_storage = 20
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
db_name = "mydb"
username = "admin"
password = "root123456"
db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
vpc_security_group_ids = [aws_security_group.db_sg.id]
publicly_accessible = true
skip_final_snapshot = false
tags = {
Name = "db-instance"
}
}

output "db_instance_endpoint" {
value = aws_db_instance.db_instance.endpoint
description = "The endpoint of the RDS instance"
}
output "db_instance_id" {
value = aws_db_instance.db_instance.id
description = "The ID of the RDS instance"
}
output "db_instance_arn" {
value = aws_db_instance.db_instance.arn
description = "The ARN of the RDS instance"
}
output "db_instance_address" {
value = aws_db_instance.db_instance.address
description = "The address of the RDS instance"
}
output "db_instance_port" {
value = aws_db_instance.db_instance.port
description = "The port of the RDS instance"
}