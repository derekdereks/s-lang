terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "derek-key"
  public_key = file("my-key.pub")
}

resource "aws_instance" "lang-ser" {
  ami           = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "lang-server"
  }
}

ssh -i C:\Users\acer\Desktop\s-lang\terraform\my-key ec2-user@54.245.175.30