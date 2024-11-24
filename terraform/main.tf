terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


backend "s3" {
  bucket         = "lab6-my-tf-state"
  key            = "terraform.tfstate"
  region         = "eu-north-1"
  dynamodb_table = "lab6-my-tf-lockid"
}


provider "aws" {
  region = "eu-north-1"
}


resource "random_id" "suffix" {
  byte_length = 8
}

resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg-${random_id.suffix.hex}"
  description = "Security group for web app"

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app_sg"
  }
}


resource "aws_instance" "webapp_instance" {
  ami           = "ami-08eb150f611ca277f"
  instance_type = "t3.micro"

  
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]

  tags = {
    Name = "webapp_instance"
  }
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
