# Creating Bucket for storing state file
resource "aws_s3_bucket" "my_bucket" {
    bucket = "multi-cloud-orchestration-sf"
}

# Locking mechanism using DynamoDB
resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}