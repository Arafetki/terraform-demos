terraform {
  backend "s3" {
    bucket         = "terrastatedemo"
    key            = "s3_backend.tfstate"
    dynamodb_table = "terraform-state-lock"
    region         = "eu-west-3"
  }
}

