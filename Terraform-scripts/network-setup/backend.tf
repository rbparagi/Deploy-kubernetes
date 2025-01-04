terraform {
  backend "s3" {
    bucket         = "rbparagi-terraform-state-bucket"
    key            = "create-ec2-instance/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = false
  }

}