generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"
  profile = "personal-dev"
}
EOF
}

remote_state {
  backend = "s3"

  config = {
    profile        = "personal-dev"
    region         = "eu-west-1"
    encrypt        = true
    bucket         = "dev-asessment-24-terraform-state"
    dynamodb_table = "s3-lock-mech"
    key            = "${path_relative_to_include()}/terraform.tfstate"

    #    known issue: tags don't update after resource creation - https://github.com/gruntwork-io/terragrunt/issues/1242
    // s3_bucket_tags      = merge(local.default_tags_block.default_tags, local.application_tags_auto_create_remote_state_overrides)
    // dynamodb_table_tags = merge(local.default_tags_block.default_tags, local.application_tags_auto_create_remote_state_overrides)
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "dev-asessment-24-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}
EOF
}