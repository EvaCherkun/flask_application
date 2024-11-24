backend "s3" {
  bucket         = "lab6-my-tf-state"
  key            = "terraform.tfstate"
  region         = "eu-north-1"
  dynamodb_table = "lab6-my-tf-lockid"
}