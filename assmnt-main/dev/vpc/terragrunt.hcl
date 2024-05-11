include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/vpc"
}

inputs = {
  vpc_cidr = "172.20.0.0/16"
  vpc_name = "dev-vpc"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = false
  vpc_tags = {}
}