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

resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-west-2a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}