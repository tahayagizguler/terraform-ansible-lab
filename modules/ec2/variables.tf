variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "key_name" {
  description = "SSH key pair adi"
  type        = string
}
