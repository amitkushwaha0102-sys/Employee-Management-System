# Employee-Management-System
A production-style Employee Management System built to learn real-world AWS architecture, DevOps practices, and Infrastructure as Code — not just to deploy an app, but to understand why every AWS service is used.

# Employee Management System — AWS DevOps Learning Project

A production-style **Employee Management System** built to learn real-world AWS
architecture, DevOps practices, and Infrastructure as Code — not just to deploy
an app, but to understand *why* every AWS service is used.

> 🎯 **Goal:** Practically implement VPC, EC2, ALB, Auto Scaling, RDS, S3, IAM,
> Lambda, SQS/SNS, CloudWatch, CloudTrail, Route 53, ACM, Docker, ECR,
> ECS/Fargate, Terraform, and CI/CD — in a single coherent, realistic project.

---

## 📌 Project Status

**Current Phase:** Phase 1 — Project Planning & Architecture ✅

| Phase | Topic | Status |
|---|---|---|
| 1 | Project Planning & Architecture | ✅ Done |
| 2 | AWS Account Safety & Billing Protection | ✅ Done |
| 3 | VPC | ✅ Done  |
| 4 | EC2 | ✅ Done  |
| 5 | Node.js Application | ✅ Done |
| 6 | RDS MySQL |✅ Done |
| 7 | S3 | ✅ Done |
| 8 | Application Load Balancer | ✅ Done |
| 9 | Auto Scaling | ✅ Done |
| 10 | IAM | ✅ Done |
| 11 | Secrets Manager | ✅ Done|
| 12 | Lambda | ✅ Done |
| 13 | SQS / SNS | ⬜ Pending |
| 14 | CloudWatch | ⬜ Pending |
| 15 | CloudTrail | ⬜ Pending |
| 16 | Route 53 + ACM | ⬜ Pending |
| 17 | Docker + ECR | ⬜ Pending |
| 18 | ECS / Fargate | ⬜ Pending |
| 19 | Terraform (full IaC) | ⬜ Pending |
| 20 | GitHub Actions CI/CD | ⬜ Pending |
| 21 | Security Hardening | ⬜ Pending |
| 22 | Disaster Recovery | ⬜ Pending |
| 23 | Final Production Architecture | ⬜ Pending |
| 24 | Interview Preparation | ⬜ Pending |

---

## 🏗️ Application Overview

**Employee Management System** — Node.js + Express REST API backed by MySQL (RDS),
with employee CRUD, department management, photo/document upload (S3), role-based
access, and an admin dashboard.

### Core Features
- Employee registration & login
- Employee CRUD + search
- Department management
- Profile photo & document upload
- Employee status & joining date tracking
- Role-based access control
- Admin dashboard
- API health check
- Application logging

---

## ☁️ Target AWS Architecture

```
                    Internet Users
                          |
                      Route 53 (DNS)
                          |
                    ACM (HTTPS Cert)
                          |
              Application Load Balancer (Public Subnet)
                          |
        ┌─────────────────┴─────────────────┐
        |                                    |
   EC2 Instance (AZ-A)                EC2 Instance (AZ-B)
   Private App Subnet                 Private App Subnet
   (Auto Scaling Group)               (Auto Scaling Group)
        |                                    |
        └─────────────────┬─────────────────┘
                          |
                   RDS MySQL (Multi-AZ)
                   Private DB Subnet
```

**Supporting services:** S3 (files) · Lambda (async processing) · SQS/SNS
(events & notifications) · Secrets Manager (credentials) · IAM (access control) ·
CloudWatch (monitoring) · CloudTrail (audit)

Full architecture explanation: see [`docs/phase-1-architecture.md`](docs/phase-1-architecture.md)
*(added as each phase's notes are written up)*

---

## 📂 Repository Structure

```
employee-management/
│
├── backend/            # Node.js + Express REST API
├── frontend/           # Lightweight web UI
├── terraform/           # Infrastructure as Code
├── docker/              # Dockerfile, docker-compose
├── lambda/              # Lambda function source
├── tests/               # Application tests
├── docs/                 # Phase-wise notes & architecture docs
│
└── .github/
    └── workflows/        # CI/CD pipelines (ci.yml, build.yml, deploy.yml, security-scan.yml)
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Node.js, Express.js |
| Database | MySQL (AWS RDS) |
| File Storage | AWS S3 |
| Compute | EC2 → ECS/Fargate |
| IaC | Terraform |
| Containerization | Docker, Amazon ECR |
| CI/CD | GitHub Actions |
| Monitoring | CloudWatch, CloudTrail |

---

## 💰 Cost Awareness

This is a **learning project** — cost control is a first-class concern, not an
afterthought. Every phase documents:
- Free-tier eligibility
- What generates charges
- What to destroy after practicing

Special attention: **NAT Gateway, RDS, ALB, EC2, EBS, Elastic IP** — these are the
most common sources of unexpected AWS bills.

---

## 📖 Documentation

Each phase gets its own notes file under `docs/`, following this format for every
AWS service touched:

**What it is → Why we use it → Real-world analogy → Architecture placement →
AWS Console steps → Terraform code → CLI commands → Verification →
Troubleshooting → Interview questions**

---

## 📅 Progress Log

- **Aug 11, 2026** — Phase 1 complete: architecture planned, AWS services finalized,
  repo scaffolded.
- **Aug 11, 2026** — Phase 2 complete: root account secured (MFA), IAM admin user
  created, AWS CLI configured, billing budget & alerts set up.
- **Aug 20, 2026** — Phase 3 complete: VPC Created (6 subnets, 3-tier architecture),
  Internet Gateway, Route Tables, chained Security Groups (ALB→App→RDS),
  NAT Gateway — poori infrastructure Terraform se automated.

## 🎓 Author's Note

Built as a hands-on learning project to go from "I know AWS service names" to
"I can design, build, secure, and monitor a real multi-tier AWS architecture."


##  VPC Architecture (Phase 3) ✅

A custom VPC was created in the AWS `ap-south-1` (Mumbai) region entirely using Terraform. No resources were created manually through the AWS Management Console.

### VPC

| Property | Value |
|---|---|
| CIDR Block | `10.0.0.0/16` |
| DNS Support | Enabled |
| DNS Hostnames | Enabled |

### Subnets — 3-Tier Architecture Across 2 Availability Zones

| Tier | AZ | CIDR | Purpose |
|---|---|---|---|
| Public | ap-south-1a | `10.0.1.0/24` | ALB, NAT Gateway |
| Public | ap-south-1b | `10.0.2.0/24` | ALB |
| Private App | ap-south-1a | `10.0.11.0/24` | EC2 (Node.js application) |
| Private App | ap-south-1b | `10.0.12.0/24` | EC2 (Node.js application) |
| Private DB | ap-south-1a | `10.0.21.0/24` | RDS MySQL |
| Private DB | ap-south-1b | `10.0.22.0/24` | RDS MySQL standby |

### Internet Gateway

The Internet Gateway connects the VPC to the internet. Only the route tables associated with the public subnets have routes pointing to the Internet Gateway.

### Route Tables

| Route Table | Routes | Associated Subnets |
|---|---|---|
| `public-rt` | `10.0.0.0/16 → local`, `0.0.0.0/0 → Internet Gateway` | Public A, Public B |
| `private-app-rt` | `10.0.0.0/16 → local`, `0.0.0.0/0 → NAT Gateway` | Private App A, Private App B |
| `private-db-rt` | `10.0.0.0/16 → local` (no internet route) | Private DB A, Private DB B |

### NAT Gateway

The NAT Gateway is deployed in Public Subnet A and is associated with an Elastic IP address. It allows EC2 instances in the Private Application Subnets to access the internet for outbound activities such as installing npm packages and downloading OS updates, without making the instances directly accessible from the internet.


### Security Groups — Chained Access Model

Internet (0.0.0.0/0)

        │ Ports 80, 443
        ▼

ALB Security Group

        │ Port 3000 (only from ALB-SG)
        ▼

Application Security Group ─── SSH (Port 22) only from Admin IP

        │ Port 3306 (only from App-SG)
        ▼

RDS Security Group

The database cannot be accessed directly from 0.0.0.0/0. The RDS instance only accepts traffic from the Application Security Group. This design ensures that the database is never directly exposed to the internet, even if a route table is accidentally misconfigured.

Terraform Files Created in This Phase



terraform/

├── versions.tf              # Terraform and AWS provider version lock
├── provider.tf              # AWS region configuration
├── vpc.tf                   # VPC resource
├── subnets.tf               # 6 subnets (3 tiers × 2 AZs)
├── internet-gateway.tf      # Internet Gateway
├── route-tables.tf          # 3 route tables and 6 subnet associations
├── security-groups.tf       # ALB, App, and RDS security groups (chained access)
└── nat-gateway.tf           # Elastic IP and NAT Gateway



---

### EC2 Deployment (Phase 4) ✅

An EC2 instance was created in the **Private App Subnet** with no public IP address and no direct SSH access.

| Property | Value |
|---|---|
| AMI | Ubuntu 22.04 LTS (dynamically fetched using a Terraform `data` block) |
| Instance Type | `t3.micro` |
| Subnet | Private App Subnet A |
| Security Group | `app-sg` (Port 3000 allowed only from the ALB, SSH allowed only from admin IP) |

### Secure Access — AWS SSM Session Manager

Instead of using traditional SSH access, **AWS Systems Manager Session Manager** was configured:

- An IAM Role was created (`employee-mgmt-ec2-ssm-role`) with the `AmazonSSMManagedInstanceCore` policy and attached to the EC2 instance through an Instance Profile.
- The EC2 instance establishes an outbound connection to the AWS SSM service through the NAT Gateway, so no inbound port such as port 22 needs to be opened.
- Result: Secure shell access is available directly from the browser without SSH key management and without increasing the attack surface.

---

## Node.js Application (Phase 5) ✅

An Express.js REST API has been developed to perform Employee CRUD operations:

- `GET /health` — Health check endpoint
- `GET /api/employees` — Retrieve the list of all employees
- `GET /api/employees/:id` — Retrieve a specific employee
- `POST /api/employees` — Create a new employee
- `PUT /api/employees/:id` — Update an employee
- `DELETE /api/employees/:id` — Delete an employee

**Process Management:** PM2 is used so that the app auto-restarts on crash, and automatically starts again after an EC2 reboot (via systemd integration).

**Reverse Proxy:** Nginx is configured to forward requests from port 80 to port 3000 — a standard, production-style port setup.

**Full Automation:** The entire setup (Node.js install, app deployment, PM2, Nginx) is automated in a `user_data` script — whenever a new EC2 instance is created (`terraform apply`), everything configures itself automatically, without manual intervention. This makes the infrastructure "immutable."


##  RDS MySQL (Phase 6) ✅

A MySQL 8.0 database was provisioned using RDS in the Private DB Subnets,
with no public accessibility.

- **Credentials Security:** A random password is generated via Terraform's
  `random_password` provider and stored in AWS Secrets Manager — never
  hardcoded in code or state.
- **Least-Privilege IAM:** The EC2 instance's IAM Role has a custom policy
  granting access to only this specific secret (`secretsmanager:GetSecretValue`),
  verified by testing that access is denied without the policy attached.
- **Application Integration:** The Node.js app fetches credentials at runtime
  using the AWS SDK, then connects to MySQL via the `mysql2` driver.
- **Full Automation:** Terraform's `templatefile()` function dynamically
  injects the RDS endpoint into the EC2 User Data script, so a completely
  fresh EC2 instance automatically connects to the correct database on boot
  — verified end-to-end by destroying and recreating the entire stack.


##  S3 Storage (Phase 7) ✅

An S3 bucket was created for employee profile photos and documents, with:

- **Block Public Access** enabled — no object is ever publicly reachable
- **Versioning** enabled — protects against accidental overwrite/delete
- **Server-side encryption** (AES256) for data at rest
- **Least-privilege IAM policy** — the EC2 role can only PutObject/GetObject/
  DeleteObject within this specific bucket

**Application Integration:** A `POST /api/employees/:id/photo` endpoint was
added using `multer` (file upload middleware) and the AWS S3 SDK. Photos are
stored in S3; only the object key is intended to be referenced from the
database — never storing binary data in MySQL.

**Full Automation:** The S3 bucket name is injected into the EC2 instance via
`templatefile()`, alongside the RDS endpoint — verified end-to-end on a fresh
machine with zero manual configuration.

##  Application Load Balancer (Phase 8) ✅

An internet-facing ALB was deployed across both public subnets to route
traffic to the private EC2 instance.

- **Listener:** HTTP on port 80, forwarding to a Target Group on port 3000
- **Target Group Health Check:** `/health` endpoint, checked every 15
  seconds — the target is marked healthy/unhealthy automatically based on
  the app's own health-check response
- **Security:** The ALB's security group allows inbound traffic from the
  internet (0.0.0.0/0), but the EC2 instance's security group only accepts
  traffic from the ALB's security group — the EC2 instance itself still has
  no public IP address

**Verification:** The full request path — internet → ALB (public subnet) →
EC2 (private subnet) → RDS → response — was tested end-to-end directly from
a local machine using the ALB's DNS name, confirming the private compute
layer is reachable only through the load balancer.

## 📈 Auto Scaling (Phase 9) ✅

Standalone EC2 was replaced with a **Launch Template + Auto Scaling Group**
architecture, so instances are provisioned dynamically rather than being a
single fixed resource.

| Setting | Value |
|---|---|
| Min / Desired / Max | 1 / 1 / 2 |
| Subnets | Both private app subnets (Multi-AZ) |
| Health Check Type | ELB (uses the ALB's own health check, not just EC2 status) |
| Health Check Grace Period | 300 seconds |

**Debugging note:** Initially the grace period was set to 60 seconds, which
caused the ASG to continuously terminate and recreate instances — the app
was actually healthy, but User Data provisioning (Node.js install, npm
install, PM2 startup) took longer than the grace period allowed, so ASG
marked instances unhealthy before they finished booting. This was diagnosed
using `aws elbv2 describe-target-health`, which showed `DeregistrationInProgress`
across multiple rotating instance IDs — confirming a replacement loop rather
than an application bug. Increasing the grace period to 300 seconds resolved it.

**Verification:** Confirmed via the ALB's DNS name from a local machine that
a completely ASG-provisioned instance serves traffic correctly end-to-end.


## ⚡ AWS Lambda (Phase 10) ✅

### What Was Built
A Lambda function that automatically runs whenever an employee photo is
uploaded to S3 — the application never explicitly invokes it.

### Files And Their Purpose

| File | What's In It | Why |
|---|---|---|
| `lambda/index.js` | The Lambda code — extracts bucket name, object key, and file size from the S3 event, then logs them | Kept outside `terraform/` at the project root so application code and infrastructure code stay separate |
| `terraform/lambda.tf` | 4 resources: `archive_file` (zips the code), `aws_lambda_function` (deploys it), `aws_lambda_permission` (authorizes S3 to invoke it), `aws_s3_bucket_notification` (tells S3 when to call it) | All Lambda-related resources grouped in one file |
| `terraform/iam.tf` | 2 additions: `aws_iam_role.lambda_execution_role` (Lambda's own identity) and a policy attachment granting CloudWatch Logs access | Lambda gets its own minimal-permission role rather than reusing the EC2 role — each service should have its own least-privilege identity |
| `terraform/versions.tf` | Added the `archive` provider (`hashicorp/archive ~> 2.4`) | Needed specifically to zip the Lambda code — the AWS provider alone doesn't do this |

### Key Concept — Two Different Kinds of Permission

1. **IAM Role** (`lambda_execution_role`) — defines what Lambda **itself** is allowed to do (e.g., write to CloudWatch)
2. **`aws_lambda_permission`** — defines **who is allowed to call** Lambda (here: the S3 service)

These are two separate directions of trust — one is "Lambda → outward," the other is "outward → Lambda."

### Trigger Flow

Node.js app uploads a photo to S3 (PutObjectCommand)
S3 detects the new object (ObjectCreated event)
The S3 Bucket Notification (configured in lambda.tf) picks up the event
S3 invokes Lambda (allowed via aws_lambda_permission)
Lambda extracts details from the event object
Output is written to CloudWatch Log


### How It Was Verified
```bash
# Uploaded a test photo from inside the EC2 instance:
curl -X POST http://localhost:3000/api/employees/5/photo -F "photo=@test.jpg"

# Checked CloudWatch Console:
# Log group: /aws/lambda/employee-mgmt-photo-processor
# Confirmed correct bucket name, object key, and file size in the output
```

### Cost Note
Billed duration was ~200ms per invocation — far cheaper than a permanently
running EC2 instance for infrequent, event-driven tasks.