
# 🏗️ AWS Terraform Infrastructure for Grocerymate App

This project sets up a cloud infrastructure for the shopping application using **Terraform** on **AWS**. The infrastructure is designed for learning and demonstration purposes, but incorporates real-world practices for modularity, security, and maintainability.

---

## 📐 Architecture Overview

The infrastructure consists of the following integrated AWS services:

### 🔹 **1. EC2 (Elastic Compute Cloud)**
- Hosts the Dockerized backend of the application.
- Docker container is started with runtime environment variables, including connection to RDS and S3.
- IAM role attached to the instance provides secure access to S3 without using credentials.

### 🔹 **2. RDS (Relational Database Service)**
- PostgreSQL database (engine version 14.12) for storing app data.
- Deployed into a public subnet (for simplicity) with security groups restricting access to EC2 only.
- Sensitive credentials (username, password) injected via `.env`.
- terraform rds configuration optimized for free-tier use.

### 🔹 **3. S3 (Simple Storage Service)**
- Stores user-uploaded avatars.
- Bucket name is dynamically suffixed using a `random_id` Terraform resource to ensure uniqueness.
- Bucket is created and destroyed via Terraform (with manual emptying required before destroy).

### 🔹 **4. IAM (Identity and Access Management)**
- A custom IAM Role allows the EC2 instance to access only necessary AWS services.
- Principle of Least Privilege enforced with a custom policy (instead of broad `FullAccess`).
- The IAM role is assumed by EC2, not attached to a user.

![Image](https://github.com/user-attachments/assets/a981dfad-0661-449d-9f36-4acae95044e0)

---

## 🔧 Technologies & Tools

| Tool       | Purpose                            |
|------------|------------------------------------|
| Terraform  | Infrastructure as Code             |
| AWS        | Cloud provider                     |
| Docker     | Containerized deployment           |
| PostgreSQL | Managed database                   |
| S3         | Object storage for avatars         |

---

## 🔐 Security Considerations

| Concern               | Mitigation                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| Credentials leakage   | No secrets are hardcoded; passed via `.env` or Docker environment vars.     |
| Access control        | IAM roles with fine-grained permissions (not full-access)                   |
| DB exposure           | RDS is accessible only from EC2 via security group rules                     |
| Least privilege       | EC2 instance uses an IAM role with just enough permissions                  |
| S3 bucket name        | Uniquely generated to prevent collisions with existing buckets              |

---

## 💰 Cost Considerations

| Service | Notes                                                                                   |
|---------|------------------------------------------------------------------------------------------|
| EC2     | `t2.micro` or `t3.micro` eligible for Free Tier (for low-usage/testing)                 |
| RDS     | Not Free Tier by default — remember to destroy to avoid charges                        |
| S3      | Low cost unless storing large/large numbers of files; still must be emptied before destroy |
| Terraform | No cost, but misconfigured resources can incur AWS charges                           |

**Tip**: Always run `terraform destroy` when you're done.

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com<...>.git
cd <...>
```

### 2. Setup `terraform.tfvars`

Create `terraform.tfvars` with required variables:

```hcl
aws_region         = "eu-central-1"
aws_availability_zone = "eu-central-1a"
ami_id             = "ami-xxxxxxxx"   # Amazon Linux 2
key_name           = "your-keypair"
local_ip           = "your.ip.address/32"
db_username        = "your-username"
db_password        = "your-supersecret-password"
db_name            = "your-db-name"	
```

> To find your current IP: `curl ifconfig.me`

### 3. Initialize & Deploy

```bash
terraform init
terraform apply
```

> Output will show auto-generated S3 bucket name like: `shop-avatars-8f4d3a1b`
> Output will show rds-endpoint.

### 4. SSH into EC2

```bash
ssh -i path/to/key.pem ec2-user@<public-ec2-ip> # for an Amazon Linux 2 ami
```

### 5. Run the Docker App

```bash
docker run -p 8000:5000   -e POSTGRES_USER=admin   -e POSTGRES_PASSWORD=supersecret   -e POSTGRES_HOST=<rds-endpoint>   -e POSTGRES_DB=grocerymate_db   -e POSTGRES_URI=postgresql://admin:supersecret@<rds-endpoint>:5432/grocerymate_db   -e S3_BUCKET_NAME=shop-avatars-8f4d3a1b   -e S3_REGION=eu-central-1   -e USE_S3_STORAGE=true   -e JWT_SECRET_KEY=myjwtsecret   myapp
```

> Set-up details for JWT_SECRET_KEY and DB see application README.md
---

## 🧹 Tear Down Infrastructure

Before destroying, empty your S3 bucket:

```bash
aws s3 rm s3://shop-avatars-8f4d3a1b --recursive
```

Then destroy:

```bash
terraform destroy
```

---