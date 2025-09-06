provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "buckets" {
  bucket = "my-unique-bucket-name-12345" #Must be Globally Unique
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.buckets.id
  acl = "private"
}
