variable "db_remote_state_bucket" {
    description = "Name of S3 bucket used for the database's remote state storage"
    type        = string
}

variable "db_remote_state_key" {
    description = "Name of key in the S3 bucket used for the database's remote state storage"
    type        = string
}

variable "cluster_name" {
    description = "Name to use to namespace all resources in the cluster"
    type        = string
    default     = "webservers-prod"
}