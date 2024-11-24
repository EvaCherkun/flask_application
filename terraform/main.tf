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

# Create random ID for uniqueness
resource "random_id" "suffix" {
  byte_length = 8
}

# Create a new Security Group with a unique name
resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg-${random_id.suffix.hex}"
  description = "Security group for web app"

  # Allow HTTP traffic (порт 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic 
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
    Name = "web_app_sg"
  }
}

# Create EC2 instance
resource "aws_instance" "webapp_instance" {
  ami           = "ami-08eb150f611ca277f" 
  instance_type = "t3.micro"

  # Use the created Security Group
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]

  tags = {
    Name = "webapp_instance"
  }
}

# Output instance public IP
output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
