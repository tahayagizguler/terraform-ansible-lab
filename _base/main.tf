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
  default     = "us-east-1"
}

variable "environment" {
  description = "Ortam adi (dev/staging/prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR blogu"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair adi"
  type        = string
  default     = "terraform-lab-key"
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

resource "null_resource" "ansible_provision" {
  depends_on = [module.ec2]

  triggers = {
    instance_id = module.ec2.instance_id
    # instance_id değişince tekrar çalışır
    # aynı instance varsa tekrar çalışmaz — idempotent
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Instance ayaga kalkiyor, 30 saniye bekleniyor..."
      sleep 30
      cd /home/lenovo/terraform-ansible/ansible && \
      ansible-playbook playbooks/provision.yml --limit env_${var.environment}
    EOT
  }
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

locals {
  common_tags = {
    ManagedBy = "terraform"
    Project   = "terraform-lab"
  }
}
