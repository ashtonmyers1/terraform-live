provider "aws" {
    region = "ca-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "s3-bucket-amyers-terraform-state"

    # Prevent accidental deletion
    lifecycle {
        prevent_destroy = false
    }
}

# Enable versioning so you can see the full revision history of state files
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

# Enable server side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket                  = aws_s3_bucket.terraform_state.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_locks" {
    name            = "terraform-up-and-running-locks"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

resource "aws_instance" "example" {
    ami             = "ami-08355844f8bc94f55"
    instance_type   = "t2.micro"
}

terraform {
    backend "s3" {
        bucket          = "s3-bucket-amyers-terraform-state"
        key             = "global/s3/terraform.tfstate"
        region          = "ca-central-1"

        dynamodb_table  = "terraform-up-and-running-locks"
        encrypt         = true

    }
}





