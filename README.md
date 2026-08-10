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
| 3 | VPC | ⬜ Pending |
| 4 | EC2 | ⬜ Pending |
| 5 | Node.js Application | ⬜ Pending |
| 6 | RDS MySQL | ⬜ Pending |
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

- **[Date]** — Phase 1 complete: architecture planned, AWS services finalized,
  repo scaffolded.

  [Date] — Phase 2 complete: root account secured (MFA), IAM admin user created, AWS CLI configured, billing budget & alerts set up.

---

## 🎓 Author's Note

Built as a hands-on learning project to go from "I know AWS service names" to
"I can design, build, secure, and monitor a real multi-tier AWS architecture."
