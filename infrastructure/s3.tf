resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}