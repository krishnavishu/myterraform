# main.tf

provider "aws" {
region = "eu-west-2"
}

#VPC
resource "aws_vpc" "krishmain_vpc" {
cidr_block = "10.0.0.0/16"
tags = {
Name = "my-vpc"
}
}

# Submit
resource "aws_subnet" "krishmain_subnet" {
vpc_id = aws_vpc.krishmain_vpc.id
cidr_block = "10.0.1.0/24"
availability_zone = "eu-west-2a"

tags = {
Name = "my-subnet"
}
}

# Security Group
resource "aws_security_group" "allow_ssh" {
vpc_id = aws_vpc.krishmain_vpc.id

ingress {
from_port = 22
to_port = 22
protocol ="tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "allow_ssh"
}
}

#EC 2 instatnce
resource "aws_instance" "webkrish" {
ami = "ami-0cfd0973db26b893b" #Amazon linux 2 ami
instance_type = "t2.micro"

subnet_id = aws_subnet.krishmain_subnet.id
security_groups = [aws_security_group.allow_ssh.id]

tags ={
Name = "my-ec2-instance"
}
}
