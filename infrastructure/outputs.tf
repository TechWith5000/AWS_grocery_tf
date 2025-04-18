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
