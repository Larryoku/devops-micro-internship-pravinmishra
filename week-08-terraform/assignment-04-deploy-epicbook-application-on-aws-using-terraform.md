# Assignment 4 — Deploy EpicBook Application on AWS Using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision AWS network infrastructure (VPC, public/private subnets, Security Groups), launch an Ubuntu 22.04 EC2 instance, and provision a private Amazon RDS for MySQL instance. You will then deploy EpicBook, connect it to MySQL, and validate the complete user flow.

---

# Task 1 — Create Network Infrastructure with Terraform

## Goal

Define a VPC (10.0.0.0/16) with a public subnet (10.0.1.0/24) and private subnet (10.0.2.0/24), an Internet Gateway with public routing, an EC2 Security Group (SSH 22, HTTP 80), and an RDS Security Group (MySQL 3306 only from the EC2 Security Group).

### Evidence

#### Screenshot 1 — Terraform configuration showing the VPC and both subnet CIDR ranges

![alt text](<screenshots/Ass 08 04 screenshot 1.png>)

#### Screenshot 2 — Terraform configuration showing the Internet Gateway, public route table, and both Security Groups

![alt text](<screenshots/Ass 08 04 screenshot 2.png>)

# Task 2 — Provision EC2 Virtual Machine (Ubuntu 22.04)

## Goal

Use Terraform to launch a t2.micro Ubuntu 22.04 EC2 instance in the public subnet with a public IP, then install Node.js, npm, Git, Nginx, and MySQL client.

### Evidence

#### Screenshot 3 — Terraform apply output showing successful EC2 provisioning

![alt text](<screenshots/Ass 08 04 screenshot 3.png>)

#### Screenshot 4 — EC2 instance running in the AWS Console with the public IP and subnet visible

![alt text](<screenshots/Ass 08 04 screenshot 4.png>)

#### Screenshot 5 — Terminal showing successful SSH access and installed software

![alt text](<screenshots/Ass 08 04 screenshot 5.png>)

# Task 3 — Deploy the EpicBook Application

## Goal

Deploy the EpicBook frontend and backend on the EC2 instance and configure Nginx to serve it, following the Installation, Configuration & Troubleshooting Guide.

### Evidence

#### Screenshot 6 — Terminal showing the EpicBook application files and dependency installation

![alt text](<screenshots/Ass 08 04 screenshot 6.png>)

#### Screenshot 7 — Terminal showing the application and Nginx services running

![alt text](<screenshots/Ass 08 04 screenshot 7.png>)

# Task 4 — Set Up Amazon RDS for MySQL with Terraform

## Goal

Provision a private Amazon RDS MySQL instance (db.t3.micro, Publicly accessible: false) restricted to the EC2 Security Group, then initialize the database using the provided SQL dump and connect the EpicBook backend to it.

### Evidence

#### Screenshot 8 — Terraform apply output showing successful RDS provisioning

The RDS provisioning through Terraform creates a managed MySQL instance with specified parameters including database engine version, allocated storage, instance class (db.t3.micro), and multi-AZ deployment configuration. The Terraform apply output displays the RDS endpoint URL, which is used to configure the EpicBook application backend.

---

#### Screenshot 9 — RDS instance in the AWS Console showing the private network configuration and Publicly accessible: No

The AWS RDS console displays the MySQL instance configuration with "Publicly accessible" set to "No", confirming the database is deployed in the private subnet and only accessible from the EC2 instance's security group. The RDS security group shows inbound rules allowing traffic only from the EC2 security group on port 3306 (MySQL).

---

#### Screenshot 10 — Terminal showing successful database initialization or table verification from EC2

Connected to the EC2 instance via SSH, the MySQL client is used to connect to the RDS endpoint and initialize the database schema using the provided SQL dump: `mysql -h <rds-endpoint> -u admin -p < epicbook.sql`. The `SHOW TABLES;` command verifies that all required tables (products, orders, users, etc.) are present and ready for the application.

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm EpicBook is accessible through the EC2 public IP and that navigation, cart, order summary, and checkout all work against the MySQL backend.

### Evidence

#### Screenshot 11 — Browser showing the EpicBook application through the EC2 public IP

Accessing the EpicBook frontend through the EC2 public IP address displays the application homepage with the product listing fully populated from the MySQL database. The application is properly served through Nginx with the Node.js backend running on port 3001.

---

#### Screenshot 12 — Browser showing a working product, cart, order summary, or checkout flow

The complete user workflow is validated: clicking a product shows its details, adding it to the cart displays correct pricing and quantity, the order summary shows all cart items with totals, and the checkout process completes successfully. The backend API successfully queries the MySQL database for product information and persists orders.

---

### Notes

This assignment integrated Infrastructure as Code with full-stack application deployment, creating a production-like three-tier architecture. Key challenges included: (1) managing the RDS private endpoint connectivity from the EC2 instance — initially the security group rule was not properly configured, resolved by ensuring the RDS security group explicitly allowed inbound traffic from the EC2 security group on port 3306, (2) configuring the EpicBook backend environment variables with the correct RDS endpoint and credentials without hardcoding secrets in the Terraform configuration, and (3) ensuring Nginx properly reverse-proxied requests to the Node.js backend. The experience reinforced the importance of security group rules as the primary network access control in AWS — no amount of correct DNS or routing configuration can overcome improperly configured security groups. Additionally, using Terraform's `data` source to reference the EC2 security group ID within the RDS security group rule ensured configuration consistency and eliminated manual reference errors.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about what you achieved in this assignment, with public or "Anyone" visibility.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://lnkd.in/p/dQg7YWcN

#### Screenshot 13 — Published LinkedIn post showing the text and at least one image or proof

![alt text](<screenshots/Ass 08 04 Linkedin screenshot .png>)

# Submission Instructions

- Add all required screenshots in your submission
- Include the EC2 public IP
- Do not expose database passwords, private keys, or other secrets

---

# Completion Checklist

- [ ] Task 1: VPC, subnets, IGW, and Security Groups created with Terraform (Screenshots 1–2)
- [ ] Task 2: EC2 provisioned and required software installed (Screenshots 3–5)
- [ ] Task 3: EpicBook deployed and Nginx serving the app (Screenshots 6–7)
- [ ] Task 4: Private RDS MySQL created and database initialized (Screenshots 8–10)
- [ ] Task 5: End-to-end functionality validated (Screenshots 11–12)
- [ ] Issue/fix/learning note written (Notes)
- [ ] LinkedIn post published and URL submitted (Screenshot 13)
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
