terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "react_sg" {
  name        = "react-app-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "react_vm" {
  ami           = "ami-092cce4a19b438926" # Ubuntu 22.04 LTS in eu-north-1
  instance_type = "t3.micro"            # t3.micro is standard for eu-north-1 free tier
  key_name      = "epicreads-key"

  vpc_security_group_ids = [aws_security_group.react_sg.id]

  tags = {
    Name = "React-Deploy-VM"
  }
}

output "public_ip" {
  value       = aws_instance.react_vm.public_ip
  description = "Public IP of the deployed EC2 instance"
}
