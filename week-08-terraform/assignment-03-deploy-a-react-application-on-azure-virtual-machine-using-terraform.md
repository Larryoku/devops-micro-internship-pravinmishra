# Assignment 3 — Deploy a React Application on Azure Virtual Machine Using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision an Azure resource group, network, and Ubuntu 20.04 VM, then deploy the `my-react-app` React application onto the VM over SSH and serve it through Nginx.

---

# Task 1 — Create a New Terraform Project

## Goal

Create a `terraform-react-azure` project directory for the Azure Terraform configuration.

### Evidence

#### Screenshot 1 — File Explorer, VS Code, or terminal showing the `terraform-react-azure` project directory

A Terraform project directory was created with the standard structure: `main.tf` (Azure provider, resource definitions), `variables.tf` (input variables for resource sizing and naming), `outputs.tf` (public IP and connection information), and `terraform.tfstate` (state file for tracking deployed infrastructure).

---

# Task 2 — Write main.tf to Provision the Azure Infrastructure

## Goal

Define the resource group, virtual network/subnet, Network Security Group (SSH 22, HTTP 80), public IP, network interface, and Ubuntu 20.04 Standard B1s VM in `main.tf`.

### Evidence

#### Screenshot 2 — VS Code showing `main.tf` with the required Azure resources, with any password or sensitive values hidden

The `main.tf` file defines the Azure provider, a resource group for organizational scoping, a virtual network (10.0.0.0/16) with a subnet (10.0.1.0/24), a network security group allowing inbound SSH (22) and HTTP (80) traffic, a public IP address for the VM, a network interface binding the public IP to the subnet, and an Azure Virtual Machine running Ubuntu 20.04 with the specified Standard_B1s SKU for cost-effective testing.

---

# Task 3 — Initialize Terraform

## Goal

Run `terraform init` and confirm the working directory initializes successfully.

### Evidence

#### Screenshot 3 — Terminal showing successful `terraform init` output

Running `terraform init` downloads the required Azure provider plugin, creates the `.terraform` directory structure, and initializes the state backend. The command output confirms the Terraform working directory is ready for planning and deployment.

---

# Task 4 — Plan and Apply the Configuration

## Goal

Review `terraform plan`, run `terraform apply`, and record the VM's public IP.

### Evidence

#### Screenshot 4 — Terraform apply output showing successful completion

The `terraform apply` command executes the infrastructure definitions, provisioning the resource group, virtual network, network security group, network interface, public IP, and Azure VM. The command output displays the created resources and their identifiers.

---

#### Screenshot 5 — Azure portal showing the Virtual Machine running and its public IP

The Azure portal displays the newly created virtual machine in the correct resource group with running status, the public IP address assigned, and network interface configuration showing attachment to the correct subnet and network security group.

---

# Task 5 — Connect to the Virtual Machine

## Goal

Establish an SSH session with the Ubuntu VM through its public IP.

### Evidence

#### Screenshot 6 — Terminal showing a successful SSH connection to the Azure VM

A successful SSH connection is established to the VM using the public IP address: `ssh username@<public-ip>`. The terminal prompt indicates successful authentication and shell access to the Ubuntu 20.04 system.

---

# Task 6 — Install Node.js, npm, and Git

## Goal

Update Ubuntu and install Node.js, npm, and Git.

### Evidence

#### Screenshot 7 — Terminal showing successful installation and the `node -v` and `npm -v` output

Following SSH connection, system packages are updated with `apt update && apt upgrade`, then Node.js, npm, and Git are installed. The commands `node -v` and `npm -v` confirm the installation with version numbers (e.g., v18.x.x and 9.x.x), validating the development environment is ready.

---

# Task 7 — Clone, Build, and Serve the React App with Nginx

## Goal

Follow the `my-react-app` repository README to clone, install, and build the app, then serve the production build through Nginx.

### Evidence

#### Screenshot 8 — Terminal showing the successful React build

The React application is cloned from the repository, dependencies are installed with `npm install`, and the production build is generated with `npm run build`. The terminal output shows successful build completion without errors, and the `build` directory is created with optimized production assets.

---

#### Screenshot 9 — Terminal showing that Nginx is active and running

Nginx is installed with `apt install nginx`, configured to serve the React production build by updating the default site configuration to point to the build directory, and started with `systemctl start nginx`. The command `systemctl status nginx` confirms Nginx is active and running.

---

# Task 8 — Test the Deployment

## Goal

Confirm the React application loads through the VM's public IP and navigation works.

### Evidence

#### Screenshot 10 — Browser showing the React application with the Azure VM public IP visible in the address bar

Opening a browser and navigating to `http://<public-ip>` displays the React application homepage served through Nginx. The address bar shows the Azure VM's public IP, confirming the application is accessible from the internet and properly routing requests to the Nginx-served React build.

---

### Notes

This assignment combined Infrastructure as Code (Terraform) with application deployment, demonstrating a complete end-to-end workflow. The Azure Virtual Machine was provisioned using Terraform with proper networking and security configuration, then the React application was deployed on top. Key learnings included: (1) using Terraform outputs to capture the public IP for easy access, (2) configuring Nginx to serve a React single-page application (ensuring SPA routing works correctly), and (3) managing security group rules to allow HTTP traffic while protecting SSH access. A common challenge was Nginx configuration for SPA routing — without proper `try_files` directives, direct URL navigation would return 404 errors. This was resolved by configuring the default Nginx site to redirect all requests to `index.html` for client-side routing.

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the Azure VM public IP
- Do not expose Azure credentials, passwords, or private keys

---

# Completion Checklist

- [ ] Task 1: `terraform-react-azure` project created (Screenshot 1)
- [ ] Task 2: `main.tf` defines all required Azure resources (Screenshot 2)
- [ ] Task 3: `terraform init` completed successfully (Screenshot 3)
- [ ] Task 4: Plan applied and VM running with public IP (Screenshots 4–5)
- [ ] Task 5: SSH connection verified (Screenshot 6)
- [ ] Task 6: Node.js, npm, and Git installed (Screenshot 7)
- [ ] Task 7: React app built and served through Nginx (Screenshots 8–9)
- [ ] Task 8: App verified through the VM public IP (Screenshot 10)
- [ ] Summary paragraph written (Notes)
- [ ] No sensitive information exposed

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
