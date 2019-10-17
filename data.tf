data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region = var.vpc_state_region
    bucket = var.vpc_bucket
    key    = var.vpc_state_key
  }
}

data "vault_generic_secret" "rds_credentials" {
  path = var.vault_generic_secret_rds_credentials_path
}