include "root" {
  path = find_in_parent_folders()
  # live/terragrunt.hcl'yi otomatik buluyor
  # S3 backend, provider — hepsini oradan devralıyor
}

terraform {
  source = "../../_base"
  # hangi main.tf'i kullanacağını söylüyor
}

inputs = {
  environment   = "dev"
  vpc_cidr      = "10.0.0.0/16"
  instance_type = "t3.micro"
  key_name      = "terraform-lab-key"
}
