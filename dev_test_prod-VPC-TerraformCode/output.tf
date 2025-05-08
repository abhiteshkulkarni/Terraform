output "active_workspace" {

  value = terraform.workspace

}

output "active_vpc" {

  value = aws_vpc.main.tags.Name

}

output "active_Public_subnet" {

  value = [for subnet in aws_subnet.public : subnet.tags["Name"]]

}

output "active_private_subnet" {

  value = [for subnet in aws_subnet.private : subnet.tags["Name"]]

}


output "instance_sg" {

  value = aws_security_group.web-sg.name

}

output "pub_instance_name" {

  value = aws_instance.pubinstance.tags.Name

}

output "Pvt_instance_name" {

  value = aws_instance.pvtinstance.tags.Name

}
