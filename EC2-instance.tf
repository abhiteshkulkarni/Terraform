provider "aws" {
  region = "us-east-1"

}


resource "aws_instance" "server" {
  ami           = "" 
  count         = 5
  instance_type = "t2.micro"
  tags = {
    Name = "My-Web-Server"
  }

}
