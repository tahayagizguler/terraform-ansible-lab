locals {
  env = basename(get_terragrunt_dir())
  # get_terragrunt_dir() bu dosyanın bulunduğu klasörü döner
  # live/dev klasöründen çalışırken → "/home/lenovo/terraform-ansible/live/dev"
  # basename() sadece son kısmı alır → "dev"
  # yani env değişkeni otomatik olarak klasör adından geliyor
}

remote_state {
  backend = "s3" # Terraform durum dosyalarını S3'te saklamak için
  config = {
    bucket         = "terraform-lab-tfstate-yagiz"
    key            = "${local.env}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lab-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
    # backend.tf'i elle yazmana gerek yok
    # Terragrunt her apply öncesi bu dosyayı otomatik üretiyor
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-PROVIDER
    provider "aws" {
      region = "us-east-1"
    }
  PROVIDER
  # provider.tf de otomatik üretiliyor
  # _base/main.tf içinde provider tanımlamana gerek kalmıyor
}
