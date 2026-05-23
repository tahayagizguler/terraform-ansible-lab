terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = "terraform-lab-key"
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "sg" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = var.instance_type
  environment   = var.environment
  subnet_id     = module.vpc.subnet_id
  sg_id         = module.sg.sg_id
  key_name      = var.key_name
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
