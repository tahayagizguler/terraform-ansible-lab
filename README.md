# Terraform + Terragrunt + Ansible: Multi-Environment Infrastructure Lab

A hands-on lab for provisioning and configuring dev/staging/prod environments on AWS using Terraform modules, Terragrunt for state isolation, and Ansible for post-provisioning configuration.

## Architecture
_base/main.tf          → single Terraform entry point
modules/vpc|ec2|sg     → reusable infrastructure components
live/dev|staging|prod  → environment-specific values via Terragrunt
ansible/               → dynamic inventory, roles, playbooks

## Prerequisites

- Terraform >= 1.9
- Terragrunt >= 0.67
- Ansible >= 2.17
- AWS CLI >= 2.x
- An AWS account with IAM credentials configured

## Usage

```bash
# Deploy dev environment
cd live/dev && terragrunt apply

# Deploy all environments
cd live && terragrunt run-all apply

# Run Ansible manually against dev
cd ansible && ansible-playbook playbooks/provision.yml -e "target_env=dev"

# Destroy everything
cd live && terragrunt run-all destroy
```

## Blog Post

Full walkthrough: [Terraform + Terragrunt + Ansible: A Hands-On Learning Journey](https://dev.to/tahayagizguler/terraform-terragrunt-ansible-a-hands-on-learning-journey-jed)
