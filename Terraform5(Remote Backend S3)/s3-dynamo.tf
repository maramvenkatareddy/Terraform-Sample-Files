resource "aws_s3_bucket" "bucket" {
  bucket = "apr-23-04"
  tags = {
    Name = "mys3_buck"
  }
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_dynamodb_table" "name" {
  name           = "tf-dynamo"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
