terraform {

  backend "s3" {

    bucket         = "backend-tf-state-bkt"
    key            = "vpc/terraform-tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true

  }

}
# This is the backend configuration for Terraform. It specifies that the state file will be stored in an S3 bucket.
# The bucket name is "backend-tf-state-bkt", and the key (path) for the state file is "vpc/terraform-tfstate".