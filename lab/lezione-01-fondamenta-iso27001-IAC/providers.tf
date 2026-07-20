terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider AWS puntato su floci (emulatore locale).
# Nessuna credenziale reale: chiavi finte e tutti i check disabilitati
# perché stiamo parlando con un endpoint fake su localhost.
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    iam = var.floci_endpoint
    s3  = var.floci_endpoint
    ssm = var.floci_endpoint
    sts = var.floci_endpoint
  }
}
