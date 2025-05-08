variable "cidr" {

  type    = string
  default = ""

}

variable "public_subnet_cidrs" {

  type    = list(string)
  default = []

}

variable "private_subnet_cidrs" {

  type    = list(string)
  default = []

}

variable "availability_zones" {

  type    = list(string)
  default = []

}

variable "instance_ami" {

  type    = string
  default = ""

}

variable "key_name" {

  type    = string
  default = ""

}

