# providers.tf — Provider and backend configuration

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state with locking (uncomment and configure before use).
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "static-website/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locks"
  #   encrypt        = true
  # }
}

# Primary region provider.
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# CloudFront and ACM certificates for it must live in us-east-1.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}
