output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value = aws_subnet.public.id
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for user avatars"
  value       = aws_s3_bucket.avatars.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket for user avatars"
  value       = aws_s3_bucket.avatars.arn
}

output "iam_role_name" {
  value = aws_iam_role.ec2_s3_access_role.name
}