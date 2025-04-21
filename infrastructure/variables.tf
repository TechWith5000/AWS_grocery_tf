variable "aws_region" {
  description = "AWS region to deploy to"
  type = string
}

variable "aws_availability_zone" {
  description = "AWS availability zone"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID for region eu-central-1"
  type        = string
}

variable "local_ip" {
  description = "The IP address for SSH"
  type = string
}

variable "key_name" {
  description = "key_name for key pair authentication"
  type = string
}

variable "db_username" {
  description = "Username for RDS"
  type        = string
}

variable "db_password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "myappdb"
}
