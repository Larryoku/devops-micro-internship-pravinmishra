# Assignment 2 — Deploy a Virtual Machine on AWS with Public Network Using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to create a custom AWS network (VPC, public and private subnets, Internet Gateway, route table) and launch an EC2 instance into the public subnet with a public IP, a Security Group allowing SSH and HTTP, and Nginx installed for validation.

---

# Task 1 — Create a New Terraform Project

## Goal

Create a `terraform-aws-vm` project directory for the AWS Terraform configuration.

### Evidence

#### Screenshot 1 — File Explorer, VS Code, or terminal showing the `terraform-aws-vm` project directory

![alt text](<screenshots/Ass 08 02 screenshot 1.png>)

# Task 2 — Create main.tf with the Required AWS Resources

## Goal

Define the AWS provider, a VPC (10.0.0.0/16) with a public subnet (10.0.1.0/24) and private subnet (10.0.2.0/24), an Internet Gateway with public routing, a Security Group (SSH 22, HTTP 80), an EC2 instance in the public subnet with a public IP, and a public IP output.

### Evidence

#### Screenshot 2 (optional) — `main.tf` showing the VPC and EC2 resource blocks

![alt text](<screenshots/Ass 08 02 screenshot 2.png>)

# Task 3 — Initialize Terraform

## Goal

Run `terraform init` and confirm the working directory initializes successfully.

### Evidence

#### Screenshot 3 — Terminal showing successful `terraform init` output

![alt text](<screenshots/Ass 08 02 screenshot 3.png>)

# Task 4 — Plan and Apply the Configuration

## Goal

Review `terraform plan`, run `terraform apply`, and record the EC2 instance's public IP from the Terraform output.

### Evidence

#### Screenshot 4 — Terraform apply output showing successful completion

![alt text](<screenshots/Ass 08 02 screenshot 4.png>)

#### Screenshot 5 — Terraform output showing the EC2 public IP


![alt text](<screenshots/Ass 08 02 screenshot 5.png>)
# Task 5 — Verify the Deployment

## Goal

Confirm the EC2 instance is running in the public subnet with a public IP, install Nginx, and confirm it is accessible by browser or SSH.

### Evidence

#### Screenshot 6 — EC2 instance running in the AWS Console, with the subnet and public IP visible

![alt text](<screenshots/Ass 08 02 screenshot 6.png>)

#### Screenshot 7 — Browser showing the Nginx page through the EC2 public IP, or terminal showing a successful SSH connection

![alt text](<screenshots/Ass 08 02 screenshot 7.png>)

# Task 6 — Destroy Resources

## Goal

Run `terraform destroy` to remove the Terraform-managed AWS resources after testing.

### Evidence

#### Screenshot 8 — Terminal showing successful `terraform destroy` completion

![alt text](<screenshots/Ass 08 02 screenshot 8.png>)
### Notes

This assignment reinforced AWS networking fundamentals through Infrastructure as Code. Key challenges included: (1) correctly configuring the route table association to ensure traffic from the EC2 instance reaches the Internet Gateway for outbound connectivity, (2) managing security group ingress rules to allow SSH (port 22) and HTTP (port 80) while restricting unwanted access, and (3) ensuring the public IP was properly attached to the EC2 instance. These were resolved by carefully reviewing the AWS security group documentation and verifying the route table associations in the Terraform plan output. The exercise highlighted the importance of explicit routing configuration in VPCs — even with an Internet Gateway present, without a proper route table entry, traffic will not flow as expected. Using Terraform's `-detailed-exitcode` flag in the plan step provided clear feedback on what resources would be created.

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the EC2 public IP
- Do not expose AWS credentials, private keys, or account IDs

---

# Completion Checklist

- [X] Task 1: `terraform-aws-vm` project created (Screenshot 1)
- [X] Task 2: `main.tf` defines VPC, subnets, IGW, Security Group, and EC2 (Screenshot 2, optional)
- [X] Task 3: `terraform init` completed successfully (Screenshot 3)
- [X] Task 4: Plan reviewed and `terraform apply` completed, public IP recorded (Screenshots 4–5)
- [X] Task 5: EC2 instance verified running and accessible (Screenshots 6–7)
- [X] Task 6: `terraform destroy` completed successfully (Screenshot 8)
- [X] Challenges/solutions paragraph written (Notes)
- [X] No sensitive information exposed

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
