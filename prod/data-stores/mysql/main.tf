provider "aws" {
    region = "ca-central-1"
}

terraform {
    backend "s3" {
        bucket          = "s3-bucket-amyers-terraform-state"
        key             = "stage/data-stores/mysql/terraform.tfstate"
        region          = "ca-central-1"
        dynamodb_table  = "terraform-up-and-running-locks"
        encrypt         = true
    }
}

resource "aws_db_instance" "example" {
    identifier_prefix       = "terraform-up-and-running"
    engine                  = "mysql"
    allocated_storage       = 10
    instance_class          = "db.t3.micro"
    skip_final_snapshot     = true
    db_name                 = var.db_name
    username                = var.db_username
    password                = var.db_password
}