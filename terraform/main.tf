terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "eu-north-1" 
}

# Create Security Group
resource "aws_security_group" "Web_app" {
  name        = "Web_app"
  description = "Security group for web app"

  # Allow HTTP traffic (порт 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic (порт 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web_app"
  }
}

# Create EC2 instance
resource "aws_instance" "webapp_instance" {
  ami           = "ami-0915bcb5fa77e4892" 
  instance_type = "t3.micro"

  # Use the created Security Group
  vpc_security_group_ids = [aws_security_group.Web_app.id]

  tags = {
    Name = "webapp_instance"
  }
}

# Output instance public IP
output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
