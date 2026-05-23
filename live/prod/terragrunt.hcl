include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/_base"
}

inputs = {
  environment   = "prod"
  vpc_cidr      = "10.2.0.0/16"
  instance_type = "t3.micro"
  key_name      = "terraform-lab-key"
}
