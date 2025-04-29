terraform {
  backend "s3" {
    bucket = "apr-23-04"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-2"
    #dynamodb_table = "tf-dynamo"
  }
}