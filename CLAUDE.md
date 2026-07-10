# CLAUDE.md — Project Guidelines

## 1. Project Overview
A cloud-native static website hosting architecture built for high availability and secure content delivery.

## 2. Build & Deployment Commands
- **Infrastructure Provisioning:** `terraform init && terraform apply`
- **Local Preview:** Use VS Code Live Server or `python3 -m http.server 8080`

## 3. Technology Stack & Architecture
- **Infrastructure as Code:** Terraform
- **Storage:** Amazon S3 (Static Website Hosting configuration)
- **Content Delivery Network:** Amazon CloudFront (with OAC for secure S3 access)
- **DNS & SSL:** Route 53 & AWS Certificate Manager (ACM)

## 4. Code Style & Tech Conventions
- **TypeScript Only:** All application/front-end scripting must be written in TypeScript.
- **NO PLAIN JAVASCRIPT:** Do not write, accept, or inject any hand-authored plain JavaScript. Author in TypeScript and let it compile to JS.
- **IaC Standards:** Modular Terraform code with strict variable definitions and state locks.

## 5. Verification & Testing
- Type-check TypeScript (`tsc --noEmit`) and validate HTML/CSS formatting before committing.
- Run `terraform validate` and `terraform plan` to verify cloud infrastructure states.