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
| 6 | RDS MySQL | ⬜ Underwork |
| 7 | S3 | ⬜ Pending |
| 8 | Application Load Balancer | ⬜ Pending |
| 9 | Auto Scaling | ⬜ Pending |
| 10 | IAM | ⬜ Pending |
| 11 | Secrets Manager | ⬜ Pending |
| 12 | Lambda | ⬜ Pending |
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

```text
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

###  EC2 Deployment (Phase 4) ✅

An EC2 instance was created in the **Private App Subnet** with no public IP address and no direct SSH access.

| Property | Value |
|---|---|
| AMI | Ubuntu 22.04 LTS (dynamically fetched using a Terraform `data` block) |
| Instance Type | `t3.micro` |
| Subnet | Private App Subnet A |
| Security Group | `app-sg` (Port 3000 allowed only from the ALB, SSH allowed only from the admin IP) |

### Secure Access — AWS SSM Session Manager

Instead of using traditional SSH access, **AWS Systems Manager Session Manager** was configured:

- An IAM Role was created (`employee-mgmt-ec2-ssm-role`) with the `AmazonSSMManagedInstanceCore` policy and attached to the EC2 instance through an Instance Profile.
- The EC2 instance establishes an outbound connection to the AWS SSM service through the NAT Gateway, so no inbound port such as port 22 needs to be opened.
- Result: Secure shell access is available directly from the browser without SSH key management and without increasing the attack surface..

##  Node.js Application (Phase 5) ✅

An Express.js REST API has been developed to perform Employee CRUD operations:

* `GET /health` — Health check endpoint
* `GET /api/employees` — Retrieve the list of all employees
* `GET /api/employees/:id` — Retrieve a specific employee
* `POST /api/employees` — Create a new employee
* `PUT /api/employees/:id` — Update an existing employee
* `DELETE /api/employees/:id` — Delete an employee

### Process Management

PM2 has been configured to manage the Node.js application. If the application crashes, PM2 automatically restarts it. It is also integrated with systemd, ensuring that the application automatically starts when the EC2 instance reboots.

### Reverse Proxy

Nginx has been configured as a reverse proxy to forward incoming requests from port `80` to the Node.js application running on port `3000`. This follows a standard production-style application deployment architecture.

### Full Automation

The complete application setup—including Node.js installation, application deployment, PM2 configuration, and Nginx setup—has been automated using a `user_data` script.

Whenever a new EC2 instance is created using `terraform apply`, the entire application environment is automatically configured without any manual intervention. This approach helps make the infrastructure more consistent and immutable.

Full write-up: [`docs/phase-5-nodejs.md`](docs/phase-5-nodejs.md)
