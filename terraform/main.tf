terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "lab6-my-tf-state"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "lab6-my-tf-lockid"
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "webapp_instance" {
  ami           = "ami-08eb150f611ca277f"
  instance_type = "t3.micro"

  user_data = <<-EOF
    #!/bin/bash
  
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu
    sudo systemctl restart docker
    sudo systemctl status docker --no-pager
    docker pull lunariiin/order_stack:latest
    docker run -d -p 80:80 lunariiin/order_stack:latest
  EOF

  # security group ID
  vpc_security_group_ids = ["sg-07ef34fd40ee02612"]

  tags = {
    Name = "webapp_instance"
  }
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
