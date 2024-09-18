# terraform {
#   backend "s3" {
#     bucket = "marwan-s3-backend-depi"
#     key    = "s3-backend/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "s3-backend"
#   }
# }