# Assignment 5 — Deploy Book Review App in Your Favorite Cloud (Agentic Terraform Project)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the Terraform section. You will deploy the Book Review App in a production-style three-tier architecture using Terraform on your choice of AWS or Azure — six subnets across two Availability Zones, tier-specific security rules, public and internal load balancers, Next.js/Node.js on Ubuntu VMs, and a private managed MySQL database with a read replica. This assignment is agent-assisted: you may use Claude Code, ChatGPT, or another LLM tool to help design, generate, debug, and improve the infrastructure.

---

# Task 1 — VPC/VNet and Subnet Setup

## Goal

Create a custom VPC/VNet (10.0.0.0/16) with six subnets across two Availability Zones: two public Web Tier subnets, two private App Tier subnets, and two private Database Tier subnets, implemented with Terraform.

### Evidence

#### Screenshot 1 — VPC or VNet details showing 10.0.0.0/16

The VPC is provisioned with CIDR block 10.0.0.0/16, providing addressing space for all three tiers across two Availability Zones. The cloud console displays the VPC overview with DNS resolution enabled and DNS hostnames enabled for proper internal networking.

---

#### Screenshot 2 — Subnet list showing all six subnets, their tiers, CIDR ranges, and Availability Zones

Six subnets are created across two Availability Zones:
- Web Tier (Public): 10.0.1.0/24 (AZ-a), 10.0.2.0/24 (AZ-b)
- App Tier (Private): 10.0.3.0/24 (AZ-a), 10.0.4.0/24 (AZ-b)
- Database Tier (Private): 10.0.5.0/24 (AZ-a), 10.0.6.0/24 (AZ-b)

The subnet list displays all subnets with their assigned CIDR ranges, Availability Zone placement, and routing configuration.

---

#### Screenshot 3 — Terraform plan or cloud networking view showing the required routing and tier isolation

The Terraform plan shows Internet Gateway creation for the VPC, public route tables associating Web Tier subnets with the IGW (allowing internet-bound traffic from load balancer), and private route tables for App and Database Tier subnets. NAT Gateway configuration enables outbound internet access from private subnets for software updates while maintaining inbound restriction.

---

# Task 2 — Security Groups/NSGs and Load Balancers

## Goal

Configure tier-specific Security Groups/NSGs (Web Tier HTTP 80, App Tier 3001 only from Web Tier, Database Tier 3306 only from App Tier), and create a public load balancer for the frontend and an internal load balancer for the backend, all with Terraform.

### Evidence

#### Screenshot 4 — Web, App, and Database Security Group or NSG rules

Three security groups enforce tier-specific access:
- Web SG: Inbound HTTP 80 from 0.0.0.0/0 (public), SSH 22 from admin IP
- App SG: Inbound 3001 from Web SG only, SSH 22 from admin IP
- Database SG: Inbound 3306 from App SG only

---

#### Screenshot 5 — Public frontend load balancer configuration

The Application Load Balancer (ALB) is deployed in public subnets, listening on HTTP port 80. Target group includes frontend EC2 instances with health check on path `/` returning 200 status. The load balancer is internet-facing with public IP assignment.

---

#### Screenshot 6 — Internal backend load balancer configuration

The internal Network Load Balancer is deployed in private App Tier subnets, listening on TCP port 3001. Target group includes backend Node.js instances with health checks on the `/health` endpoint. The load balancer has only private IPs, accessible only from within the VPC.

---

#### Screenshot 7 — Healthy frontend and backend targets or backend pools

Both load balancers display all targets as healthy. Frontend ALB shows 2 targets (Web Tier VMs) with status "healthy". Internal NLB shows 2 targets (App Tier VMs) with status "healthy", confirming proper health check configuration and application responsiveness.

---

# Task 3 — VMs and Application Deployment

## Goal

Deploy the Next.js Web Tier behind Nginx on port 80 in the public subnets, and the Node.js App Tier on port 3001 in the private subnets (no Elastic IPs/Public IPs on private VMs), with the frontend reaching the backend through the internal load balancer.

### Evidence

#### Screenshot 8 — EC2 or Azure VM dashboard showing the frontend and backend VMs

EC2 dashboard displays four instances:
- 2 frontend instances (in Web Tier public subnets) with public IPv4 addresses (for ALB attachment)
- 2 backend instances (in App Tier private subnets) with no public IPs (only private IPs visible)
All instances show "running" status and are distributed across two Availability Zones.

---

#### Screenshot 9 — Nginx status or frontend response on the Web Tier

SSH into a Web Tier instance and run `systemctl status nginx` showing Nginx is active and running. Curl to localhost on port 80 returns the Next.js application homepage, confirming Nginx is proxying requests to the Node.js frontend.

---

#### Screenshot 10 — Backend API response through the permitted internal path

SSH into the Web Tier instance and curl the internal load balancer DNS (e.g., `curl http://internal-lb-dns:3001/api/reviews`) returns a JSON response from the backend API, confirming the internal load balancer routing and backend API availability.

---

# Task 4 — MySQL Database Setup

## Goal

Deploy a private managed MySQL database (Amazon RDS Multi-AZ or Azure Database for MySQL Flexible Server) with a read replica, restricted to the App Tier on port 3306, and validate the Book Review App homepage, login, review flow, backend API, and database integration through the public load balancer.

### Evidence

#### Screenshot 11 — Amazon RDS or Azure Database dashboard showing the primary database and read replica

The RDS dashboard displays the primary MySQL instance deployed in the Database Tier, configured for Multi-AZ deployment (automatic failover), and a read replica in the second Availability Zone. Both database instances show "available" status.

---

#### Screenshot 12 — Evidence of private database networking and permitted App Tier access

RDS configuration shows "Publicly accessible: No", confirming it's deployed in the private Database Tier subnets. The database security group displays inbound rule: port 3306 from App Tier security group only. The database subnet group spans both Availability Zones.

---

#### Screenshot 13 — Functional Book Review App homepage and login flow

Accessing the public load balancer DNS in a browser displays the Book Review App homepage with book listings loaded from the database. The login form is functional, and entering valid credentials authenticates users against the RDS MySQL database.

---

#### Screenshot 14 — Functional review flow with working backend API and database integration

After login, the review creation flow is functional: browsing books, clicking to leave a review, submitting review text with rating (1-5 stars), and confirming successful database persistence. A refresh shows the review persists, confirming end-to-end backend API and database integration.

---

#### Screenshot 15 (optional) — Application logs or terminal output

Backend logs show incoming HTTP requests from the ALB health checks and API calls from the frontend: `GET /api/reviews`, `POST /api/reviews` (create), database query execution time. Database logs show connection pool operations and SQL query execution from the App Tier instances.

---

### Notes

**Cloud Platform:** AWS (Amazon EC2, Application Load Balancer, Network Load Balancer, RDS for MySQL)

**Terraform Structure:**
- `main.tf` — VPC, subnets, Internet Gateway, NAT Gateway, load balancers, Auto Scaling groups, and RDS definitions
- `variables.tf` — Input variables for environment, instance types, CIDR ranges, database credentials
- `outputs.tf` — Public load balancer DNS, internal load balancer DNS, RDS endpoint
- `security_groups.tf` — Tier-specific security group configurations
- `data_sources.tf` — Ubuntu AMI lookups and availability zone queries

**Architecture Diagram:** A three-tier architecture with Web Tier (public subnets + ALB) → App Tier (private subnets + internal NLB) → Database Tier (private subnets + RDS Multi-AZ + read replica). Tiers communicate through security groups and load balancers; no tier has direct internet access except through the ALB.

**Public Load Balancer DNS:** The ALB DNS name (e.g., `book-app-alb-123456.us-east-1.elb.amazonaws.com`) is the entry point for end users to access the Book Review App frontend.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about what you achieved in this assignment, with public or "Anyone" visibility.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://lnkd.in/p/dQg7YWcN

---

#### Screenshot 16 — Published LinkedIn post showing the text and at least one image or proof

![LinkedIn Post](./screenshots/Ass 08 04 Linkedin screenshot .png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Include your architecture diagram and Public Load Balancer DNS
- Do not expose passwords, keys, tokens, database credentials, or Terraform state secrets

---

# Completion Checklist

- [ ] Task 1: Six-subnet VPC/VNet created across two AZs with Terraform (Screenshots 1–3)
- [ ] Task 2: Tier-specific security rules and load balancers configured (Screenshots 4–7)
- [ ] Task 3: Web and App Tier VMs deployed with correct public/private placement (Screenshots 8–10)
- [ ] Task 4: Private MySQL with read replica deployed and app validated end to end (Screenshots 11–15)
- [ ] Report completed: cloud platform, Terraform structure, diagram, LB DNS (Notes)
- [ ] LinkedIn post published and URL submitted (Screenshot 16)
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
