resource "aws_s3_bucket" "s3-backend" {
  bucket = "marwan-s3-backend-depi"
#   region = "us-east-1"
  
force_destroy = true
  tags = {
    Name        = "marwan-s3-backend-depi"
  }
}
resource "aws_dynamodb_table" "s3-bakcend-dynamo" {
  name             = "s3-backend"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "LockID"
    type = "S"
  }

}