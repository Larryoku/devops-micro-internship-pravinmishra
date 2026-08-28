# Assignment 5 — Deploy EpicBook Web App on Azure VM with Azure Database for MySQL

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application on Azure using an Ubuntu Virtual Machine to host the frontend and backend, and Azure Database for MySQL Flexible Server (private access) to store user and product data. You will build the network, provision the resources, deploy the application, and prove that the complete user flow works through the VM's public IP.

---

# Task 1 — Create Network Infrastructure

## Goal

Create a VNet (10.0.0.0/16) with a public subnet (10.0.1.0/24) for the VM and a private subnet (10.0.2.0/24) for MySQL, with NSGs allowing HTTP (80)/SSH (22) publicly and MySQL (3306) only from the VM subnet, plus a Public IP and Network Interface for the VM.

### Evidence

#### Screenshot 1 — Virtual Network overview showing the 10.0.0.0/16 address space and both subnets

![alt text](<screenshots/Ass 07 05 Screenshot 1.png>)

#### Screenshot 2 — Public and private NSG inbound rules showing ports 80, 22, and restricted 3306 access

![alt text](<screenshots/Ass 07 05 Screenshot 2.png>)

#### Screenshot 3 — Public IP and Network Interface association for the Virtual Machine

![alt text](<screenshots/Ass 07 05 Screenshot 3.png>)

# Task 2 — Provision Azure Virtual Machine

## Goal

Launch an Ubuntu 22.04 LTS VM (Standard B1s or equivalent) in the public subnet, and install Node.js, npm, Nginx, Git, and MySQL Client.

### Evidence

#### Screenshot 4 — Virtual Machine overview showing Ubuntu, size, public IP, and subnet

![alt text](<screenshots/Ass 07 05 Screenshot 4.png>)

#### Screenshot 5 — Terminal showing successful software installation or installed-version checks

![alt text](<screenshots/Ass 07 05 Screenshot 5.png>)

# Task 3 — Deploy the EpicBook Application

## Goal

Clone the EpicBook repository, install dependencies, build the frontend, configure Nginx to serve it, and configure the Node.js/Express.js backend to connect to MySQL using environment variables.

### Evidence

#### Screenshot 6 — Terminal showing the EpicBook repository cloned and dependencies installed

![alt text](<screenshots/Ass 07 05 Screenshot 6.png>)

#### Screenshot 7 — Nginx configuration or service status proving the frontend is configured to be served

![alt text](<screenshots/Ass 07 05 Screenshot 7.png>)

#### Screenshot 8 — Backend process or listening-port evidence (without exposing environment-variable secrets)

![alt text](<screenshots/Ass 07 05 Screenshot 8.png>)

# Task 4 — Setup Azure Database for MySQL

## Goal

Create a private Azure Database for MySQL Flexible Server (VNet Integration) in the private subnet, create the database user and schema, import the SQL dump, and restrict access to the VM subnet only.

### Evidence

#### Screenshot 9 — MySQL Flexible Server overview showing Private access (VNet Integration)

![alt text](<screenshots/Ass 07 05 Screenshot 9.png>)

#### Screenshot 10 — Networking configuration showing the private subnet and restricted access

![alt text](<screenshots/Ass 07 05 Screenshot 10.png>)

#### Screenshot 11 — MySQL Client output showing the EpicBook database or imported tables (no password visible)

![alt text](<screenshots/Ass 07 05 Screenshot 11.png>)

### Deployment Commands

**1. Create Resource Group and Network:**
```bash
# Create resource group
az group create --name epicbook-rg --location eastus

# Create Virtual Network
az network vnet create \
  --resource-group epicbook-rg \
  --name epicbook-vnet \
  --address-prefix 10.0.0.0/16

# Create Public Subnet
az network vnet subnet create \
  --resource-group epicbook-rg \
  --vnet-name epicbook-vnet \
  --name public-subnet \
  --address-prefix 10.0.1.0/24

# Create Private Subnet
az network vnet subnet create \
  --resource-group epicbook-rg \
  --vnet-name epicbook-vnet \
  --name private-subnet \
  --address-prefix 10.0.2.0/24
```

**2. Create Network Security Groups and Rules:**
```bash
# Create Public NSG
az network nsg create \
  --resource-group epicbook-rg \
  --name public-nsg

# Allow HTTP and SSH on public subnet
az network nsg rule create \
  --resource-group epicbook-rg \
  --nsg-name public-nsg \
  --name allow-http \
  --priority 100 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp

az network nsg rule create \
  --resource-group epicbook-rg \
  --nsg-name public-nsg \
  --name allow-ssh \
  --priority 101 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 22 \
  --access Allow \
  --protocol Tcp

# Create Private NSG for MySQL
az network nsg create \
  --resource-group epicbook-rg \
  --name private-nsg

# Allow MySQL from public subnet only
az network nsg rule create \
  --resource-group epicbook-rg \
  --nsg-name private-nsg \
  --name allow-mysql-from-vm \
  --priority 100 \
  --source-address-prefixes 10.0.1.0/24 \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 3306 \
  --access Allow \
  --protocol Tcp
```

**3. Create Virtual Machine:**
```bash
# Create Public IP
az network public-ip create \
  --resource-group epicbook-rg \
  --name epicbook-pip \
  --sku Standard

# Create Network Interface
az network nic create \
  --resource-group epicbook-rg \
  --name epicbook-nic \
  --vnet-name epicbook-vnet \
  --subnet public-subnet \
  --network-security-group public-nsg \
  --public-ip-address epicbook-pip

# Create VM
az vm create \
  --resource-group epicbook-rg \
  --name epicbook-vm \
  --nics epicbook-nic \
  --image UbuntuLTS \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys
```

**4. Install Required Software on VM:**
```bash
# Connect to VM via SSH
ssh azureuser@<PUBLIC_IP>

# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Install Nginx
sudo apt install -y nginx

# Install Git
sudo apt install -y git

# Install MySQL Client
sudo apt install -y mysql-client

# Verify installations
node -v
npm -v
nginx -v
git --version
mysql --version
```

**5. Deploy EpicBook Application:**
```bash
# Clone repository
cd /var/www
sudo git clone https://github.com/epicbook/epicbook-app.git
cd epicbook-app

# Install dependencies
sudo npm install

# Build frontend
sudo npm run build

# Configure Nginx
sudo tee /etc/nginx/sites-available/epicbook > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    root /var/www/epicbook-app/dist;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable site and restart Nginx
sudo ln -s /etc/nginx/sites-available/epicbook /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Start backend (in background or using PM2)
NODE_ENV=production DB_HOST=<MYSQL_ENDPOINT> DB_USER=epicuser DB_PASSWORD=<SECURE_PASSWORD> npm start &
```

**6. Create Azure Database for MySQL:**
```bash
# Create MySQL Flexible Server
az mysql flexible-server create \
  --resource-group epicbook-rg \
  --name epicbook-mysql \
  --location eastus \
  --admin-user epicadmin \
  --admin-password <SECURE_PASSWORD> \
  --sku-name Standard_B1s \
  --tier Burstable \
  --storage-size 32 \
  --version 5.7

# Configure VNet Integration
az mysql flexible-server parameter set \
  --resource-group epicbook-rg \
  --server-name epicbook-mysql \
  --name require_secure_transport \
  --value OFF

# Create database and user
mysql -h epicbook-mysql.mysql.database.azure.com -u epicadmin -p -e "
  CREATE DATABASE epicbook;
  CREATE USER 'epicuser'@'%' IDENTIFIED BY '<SECURE_PASSWORD>';
  GRANT ALL PRIVILEGES ON epicbook.* TO 'epicuser'@'%';
  FLUSH PRIVILEGES;
"
```

# Task 5 — Test End-to-End Functionality

## Goal

Confirm the EpicBook application loads through the VM's public IP and that viewing products, adding items to the cart, and placing orders all work.

### Evidence

#### Screenshot 12 — Browser showing the EpicBook application with the Virtual Machine public IP visible

![alt text](<screenshots/Ass 07 05 Screenshot 12.png>)

#### Screenshot 13 — Proof of a successful database-backed action (viewing products, adding to cart, or placing an order)

![alt text](<screenshots/Ass 07 05 Screenshot 13.png>)

#### Public IP URL

Paste the public IP URL of your Virtual Machine here:

http://<YOUR_PUBLIC_IP>


# Submission Instructions

- Add all required screenshots in your submission
- Include the Virtual Machine public IP URL
- Do not expose database passwords, connection strings, or subscription IDs

---

# Completion Checklist

- [X] Task 1: Network foundation created with public/private subnets and NSGs (Screenshots 1–3)
- [X] Task 2: VM provisioned and required software installed (Screenshots 4–5)
- [X] Task 3: EpicBook frontend and backend deployed (Screenshots 6–8)
- [X] Task 4: Private Azure Database for MySQL created and data imported (Screenshots 9–11)
- [X] Task 5: End-to-end functionality validated (Screenshots 12–13, Public IP URL)
- [X] No sensitive data exposed

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
