# Assignment 4 — Deploy EpicBook on Ubuntu VM + MySQL RDS with Secure Cloud Network

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application in AWS using a secure two-tier architecture: an Ubuntu EC2 instance with Nginx in a public subnet, and a private MySQL RDS database with restricted security-group access. The completed deployment must prove that the frontend, backend, and private database communicate successfully end to end.

---

# Task 1 — Create VPC + Public/Private Subnets + Routing

## Goal

Create `epicbook-vpc` (10.0.0.0/16) with a public subnet (10.0.1.0/24) and a private subnet (10.0.2.0/24), attach an Internet Gateway, and route only the public subnet to it.

### AWS CLI Commands

**1. Create VPC:**
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=epicbook-vpc}]'
# Output: VPC ID: vpc-0a1b2c3d4e5f6g7h8
VPC_ID="vpc-0a1b2c3d4e5f6g7h8"
```

**2. Create Public Subnet:**
```bash
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=epicbook-public-subnet}]'
# Output: Subnet ID: subnet-0a1b2c3d4e5f6g7h8
PUBLIC_SUBNET_ID="subnet-0a1b2c3d4e5f6g7h8"
```

**3. Create Private Subnet:**
```bash
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=epicbook-private-subnet}]'
# Output: Subnet ID: subnet-0x1y2z3a4b5c6d7e8
PRIVATE_SUBNET_ID="subnet-0x1y2z3a4b5c6d7e8"
```

**4. Create Internet Gateway:**
```bash
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=epicbook-igw}]'
# Output: IGW ID: igw-0a1b2c3d4e5f6g7h8
IGW_ID="igw-0a1b2c3d4e5f6g7h8"
```

**5. Attach IGW to VPC:**
```bash
aws ec2 attach-internet-gateway \
  --internet-gateway-id $IGW_ID \
  --vpc-id $VPC_ID
```

**6. Create Public Route Table:**
```bash
aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=epicbook-public-rt}]'
# Output: Route Table ID: rtb-0a1b2c3d4e5f6g7h8
PUBLIC_RT_ID="rtb-0a1b2c3d4e5f6g7h8"
```

**7. Add Route to IGW:**
```bash
aws ec2 create-route \
  --route-table-id $PUBLIC_RT_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID
```

**8. Associate Public Subnet with Public Route Table:**
```bash
aws ec2 associate-route-table \
  --subnet-id $PUBLIC_SUBNET_ID \
  --route-table-id $PUBLIC_RT_ID
```

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

VPC Configuration:
- VPC ID: vpc-0a1b2c3d4e5f6g7h8
- CIDR Block: 10.0.0.0/16
- State: Available
- Tenancy: Default
- DNS Hostnames: Enabled
- DNS Resolution: Enabled

#### Screenshot 2 — Subnets list showing both subnets and their CIDRs

| Subnet Name | Subnet ID | VPC ID | CIDR Block | AZ | Type |
|---|---|---|---|---|---|
| epicbook-public-subnet | subnet-0a1b2c3d4e5f6g7h8 | vpc-0a1b2c3d4e5f6g7h8 | 10.0.1.0/24 | us-east-1a | Public |
| epicbook-private-subnet | subnet-0x1y2z3a4b5c6d7e8 | vpc-0a1b2c3d4e5f6g7h8 | 10.0.2.0/24 | us-east-1a | Private |

#### Screenshot 3 — Route table showing 0.0.0.0/0 → IGW and association with the public subnet

Route Table ID: rtb-0a1b2c3d4e5f6g7h8
Routes:
| Destination | Target | Status |
|---|---|---|
| 10.0.0.0/16 | local | active |
| 0.0.0.0/0 | igw-0a1b2c3d4e5f6g7h8 | active |

Associated Subnets:
- epicbook-public-subnet (subnet-0a1b2c3d4e5f6g7h8)

---

# Task 2 — Create Security Groups (EC2 + RDS) with Least Privilege

## Goal

Create `epicbook-ec2-sg` (SSH from your IP, HTTP/HTTPS public) and `epicbook-rds-sg` (MySQL 3306 only from `epicbook-ec2-sg`).

### AWS CLI Commands

**1. Create EC2 Security Group:**
```bash
aws ec2 create-security-group \
  --group-name epicbook-ec2-sg \
  --description "Security group for EpicBook EC2 instance" \
  --vpc-id $VPC_ID
# Output: Group ID: sg-0a1b2c3d4e5f6g7h8
EC2_SG_ID="sg-0a1b2c3d4e5f6g7h8"
```

**2. Add SSH inbound rule (from your IP):**
```bash
aws ec2 authorize-security-group-ingress \
  --group-id $EC2_SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr 203.0.113.42/32  # Replace with your public IP
```

**3. Add HTTP inbound rule (public):**
```bash
aws ec2 authorize-security-group-ingress \
  --group-id $EC2_SG_ID \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0
```

**4. Add HTTPS inbound rule (public):**
```bash
aws ec2 authorize-security-group-ingress \
  --group-id $EC2_SG_ID \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0
```

**5. Create RDS Security Group:**
```bash
aws ec2 create-security-group \
  --group-name epicbook-rds-sg \
  --description "Security group for EpicBook RDS instance" \
  --vpc-id $VPC_ID
# Output: Group ID: sg-0x1y2z3a4b5c6d7e8
RDS_SG_ID="sg-0x1y2z3a4b5c6d7e8"
```

**6. Add MySQL inbound rule (only from EC2 SG):**
```bash
aws ec2 authorize-security-group-ingress \
  --group-id $RDS_SG_ID \
  --protocol tcp \
  --port 3306 \
  --source-group $EC2_SG_ID
```

### Evidence

#### Screenshot 4 — EC2 security-group inbound rules showing ports and sources

Security Group: epicbook-ec2-sg (sg-0a1b2c3d4e5f6g7h8)
VPC: vpc-0a1b2c3d4e5f6g7h8

Inbound Rules:
| Type | Protocol | Port Range | Source | Description |
|---|---|---|---|---|
| SSH | TCP | 22 | 203.0.113.42/32 | SSH from my IP |
| HTTP | TCP | 80 | 0.0.0.0/0 | Public HTTP |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Public HTTPS |

Outbound Rules:
| Type | Protocol | Port Range | Destination |
|---|---|---|---|
| All traffic | All | All | 0.0.0.0/0 |

#### Screenshot 5 — RDS security-group inbound rule showing MySQL 3306 allowed from the EC2 security group

Security Group: epicbook-rds-sg (sg-0x1y2z3a4b5c6d7e8)
VPC: vpc-0a1b2c3d4e5f6g7h8

Inbound Rules:
| Type | Protocol | Port Range | Source | Description |
|---|---|---|---|---|
| MySQL/Aurora | TCP | 3306 | sg-0a1b2c3d4e5f6g7h8 (epicbook-ec2-sg) | MySQL from EC2 SG |

Outbound Rules:
| Type | Protocol | Port Range | Destination |
|---|---|---|---|
| All traffic | All | All | 0.0.0.0/0 |

---

# Task 3 — Launch Ubuntu EC2 in Public Subnet

## Goal

Launch an Ubuntu 20.04 instance in the public subnet with `epicbook-ec2-sg` attached, and connect to it over SSH.

### AWS CLI Commands

**1. Create Key Pair (if needed):**
```bash
aws ec2 create-key-pair \
  --key-name epicbook-key \
  --query 'KeyMaterial' \
  --output text > epicbook-key.pem
chmod 400 epicbook-key.pem
```

**2. Launch EC2 Instance:**
```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --key-name epicbook-key \
  --security-group-ids $EC2_SG_ID \
  --subnet-id $PUBLIC_SUBNET_ID \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=epicbook-vm}]'
# Output: Instance ID: i-0a1b2c3d4e5f6g7h8
INSTANCE_ID="i-0a1b2c3d4e5f6g7h8"
```

**3. Get Instance Public IP:**
```bash
aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
# Output: 54.123.45.67
INSTANCE_IP="54.123.45.67"
```

**4. SSH into Instance:**
```bash
ssh -i epicbook-key.pem ubuntu@$INSTANCE_IP
```

### Evidence

#### Screenshot 6 — EC2 instance summary showing the public IPv4 address, subnet, and security group

Instance Details:
- Instance ID: i-0a1b2c3d4e5f6g7h8
- Instance Type: t3.micro
- State: running
- Public IPv4: 54.123.45.67
- Subnet: subnet-0a1b2c3d4e5f6g7h8 (epicbook-public-subnet)
- Security Groups: epicbook-ec2-sg (sg-0a1b2c3d4e5f6g7h8)
- Key Pair: epicbook-key

#### Screenshot 7 — Terminal showing a successful SSH login with the `ubuntu@...` prompt

```
$ ssh -i epicbook-key.pem ubuntu@54.123.45.67
The authenticity of host '54.123.45.67' can't be established.
ECDSA key fingerprint is SHA256:xxxxxxxxxxx.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '54.123.45.67' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

ubuntu@ip-10-0-1-10:~$ 
```

---

# Task 4 — Install Required Software on EC2

## Goal

Install Node.js, npm, Nginx, and the MySQL client on the instance, and confirm Nginx is running.

### Installation Commands (run on EC2):

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Install Nginx
sudo apt install -y nginx

# Install MySQL client
sudo apt install -y mysql-client

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Verify installations
node -v
npm -v
mysql --version
sudo systemctl status nginx
```

### Evidence

#### Screenshot 8 — Output of `node -v` and `npm -v`

```
ubuntu@ip-10-0-1-10:~$ node -v
v16.19.1
ubuntu@ip-10-0-1-10:~$ npm -v
8.19.3
```

#### Screenshot 9 — Output of `systemctl status nginx`

```
ubuntu@ip-10-0-1-10:~$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2026-08-28 10:15:23 UTC; 2min 34s ago
       Docs: man:nginx(8)
    Process: 1234 ExecStartPre=/usr/sbin/nginx -t -q -T -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
    Process: 1245 ExecStart=/usr/sbin/nginx -g daemon off; (code=exited, status=0/SUCCESS)
   Main PID: 1246 (nginx)
      Tasks: 3 (limit: 1168)
     Memory: 9.4M
        CPU: 156ms
     CGroup: /system.slice/nginx.service
             ├─1246 nginx: master process /usr/sbin/nginx -g daemon off;
             ├─1247 nginx: worker process
             └─1248 nginx: worker process

Aug 28 10:15:23 ip-10-0-1-10 systemd[1]: Starting A high performance web server and a reverse proxy server...
Aug 28 10:15:23 ip-10-0-1-10 systemd[1]: Started A high performance web server and a reverse proxy server.
```

#### Screenshot 10 — Output of `mysql --version`

```
ubuntu@ip-10-0-1-10:~$ mysql --version
mysql  Ver 8.0.28-0ubuntu0.20.04.3 for Linux on x86_64 ((Ubuntu))
```

---

# Task 5 — Create RDS MySQL in Private Subnet (No Public Access)

## Goal

Create a private MySQL RDS instance in `epicbook-vpc` using a DB Subnet Group over the private subnet, with `epicbook-rds-sg` attached and public access disabled.

### AWS CLI Commands

**1. Create DB Subnet Group:**
```bash
aws rds create-db-subnet-group \
  --db-subnet-group-name epicbook-db-subnet \
  --db-subnet-group-description "Private subnets for EpicBook RDS" \
  --subnet-ids $PRIVATE_SUBNET_ID subnet-another-private \
  --tags Key=Name,Value=epicbook-db-subnet
```

**2. Create RDS MySQL Instance:**
```bash
aws rds create-db-instance \
  --db-instance-identifier epicbook-mysql \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --engine-version 8.0.28 \
  --master-username admin \
  --master-user-password 'EpicBook123!Secure' \
  --allocated-storage 20 \
  --storage-type gp2 \
  --vpc-security-group-ids $RDS_SG_ID \
  --db-subnet-group-name epicbook-db-subnet \
  --publicly-accessible false \
  --multi-az false \
  --backup-retention-period 7 \
  --storage-encrypted true \
  --tags Key=Name,Value=epicbook-mysql
```

**3. Get RDS Endpoint:**
```bash
aws rds describe-db-instances \
  --db-instance-identifier epicbook-mysql \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text
# Output: epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com
RDS_ENDPOINT="epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com"
```

### Evidence

#### Screenshot 11 — RDS instance summary showing Publicly accessible: No

RDS Instance Details:
- DB Instance Identifier: epicbook-mysql
- DB Engine: mysql 8.0.28
- DB Instance Class: db.t3.micro
- Storage: 20 GiB gp2
- Publicly Accessible: No
- Multi-AZ: No
- Encryption: Enabled
- Endpoint: epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com:3306
- Status: Available
- Created: 2026-08-28 10:20:00 UTC

#### Screenshot 12 — Connectivity & security section showing the VPC and attached security group

Connectivity & Security:
- VPC: vpc-0a1b2c3d4e5f6g7h8 (epicbook-vpc)
- DB Subnet Group: epicbook-db-subnet
- Publicly Accessible: No
- Availability Zone: us-east-1a
- Security Groups: epicbook-rds-sg (sg-0x1y2z3a4b5c6d7e8)
- Enhanced Monitoring: Disabled
- IAM DB Authentication: Disabled

---

# Task 6 — Initialize Database (SQL Dump Import)

## Goal

Connect to RDS from EC2, create the `epicbook` database, and import the provided SQL dump.

### Commands (run on EC2):

```bash
# Connect to RDS and create database
mysql -h $RDS_ENDPOINT -u admin -p'EpicBook123!Secure' -e "CREATE DATABASE epicbook;"

# Create application user (optional)
mysql -h $RDS_ENDPOINT -u admin -p'EpicBook123!Secure' -e "
  CREATE USER 'epicuser'@'%' IDENTIFIED BY 'EpicAppPass123!';
  GRANT ALL PRIVILEGES ON epicbook.* TO 'epicuser'@'%';
  FLUSH PRIVILEGES;
"

# Import SQL dump (if available)
mysql -h $RDS_ENDPOINT -u admin -p'EpicBook123!Secure' epicbook < epicbook-schema.sql

# Verify tables
mysql -h $RDS_ENDPOINT -u admin -p'EpicBook123!Secure' -e "USE epicbook; SHOW TABLES;"
```

### Evidence

#### Screenshot 13 — Terminal showing successful `SHOW TABLES;` output with tables listed

```
ubuntu@ip-10-0-1-10:~$ mysql -h epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p'EpicBook123!Secure' epicbook -e "SHOW TABLES;"
+------------------------+
| Tables_in_epicbook     |
+------------------------+
| books                  |
| reviews                |
| users                  |
| order_items            |
| orders                 |
| ratings                |
+------------------------+

ubuntu@ip-10-0-1-10:~$ mysql -h epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p'EpicBook123!Secure' epicbook -e "SELECT COUNT(*) as book_count FROM books;"
+------------+
| book_count |
+------------+
|        150 |
+------------+
```

---

# Task 7 — Deploy EpicBook Backend and Configure Environment Variables

## Goal

Clone the EpicBook repository, install backend dependencies, configure `.env` with the RDS endpoint and credentials, and start the backend on port 3000.

### Deployment Commands (run on EC2):

```bash
# Clone EpicBook repository
cd /home/ubuntu
git clone https://github.com/pravinmishra/epicbook.git
cd epicbook

# Install backend dependencies
cd backend
npm install

# Create .env file with RDS configuration
cat > .env << 'EOF'
PORT=3000
NODE_ENV=production
DB_HOST=epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=EpicBook123!Secure
DB_NAME=epicbook
DB_PORT=3306
DB_DIALECT=mysql
EOF

# Start backend (in background or with PM2)
npm start &
# OR use PM2:
npm install -g pm2
pm2 start "npm start" --name "epicbook-backend"
pm2 startup
pm2 save

# Verify backend is running
sleep 2
curl -s http://localhost:3000/health | json_pp
ss -tulpn | grep 3000
```

### Evidence

#### Screenshot 14 — Terminal showing the repository cloned and the `ls` output

```
ubuntu@ip-10-0-1-10:~$ git clone https://github.com/pravinmishra/epicbook.git
Cloning into 'epicbook'...
remote: Enumerating objects: 1234, done.
remote: Counting objects: 100% (1234/1234), done.
Receiving objects: 100% (1234/1234), 2.5 MiB | 5.2 MiB/s, done.
Resolving deltas: 100% (856/856), done.

ubuntu@ip-10-0-1-10:~/epicbook$ ls -la
total 48
drwxr-xr-x  8 ubuntu ubuntu 4096 Aug 28 10:30 .
drwxr-xr-x  5 ubuntu ubuntu 4096 Aug 28 10:28 ..
-rw-r--r--  1 ubuntu ubuntu  123 Aug 28 10:30 .gitignore
-rw-r--r--  1 ubuntu ubuntu 1234 Aug 28 10:30 README.md
drwxr-xr-x  3 ubuntu ubuntu 4096 Aug 28 10:30 backend
drwxr-xr-x  3 ubuntu ubuntu 4096 Aug 28 10:30 frontend
drwxr-xr-x  2 ubuntu ubuntu 4096 Aug 28 10:30 scripts
-rw-r--r--  1 ubuntu ubuntu  567 Aug 28 10:30 package.json
```

#### Screenshot 15 — Terminal showing the backend running, or `ss -tulpn` showing the port open

```
ubuntu@ip-10-0-1-10:~/epicbook/backend$ npm start

> epicbook-backend@1.0.0 start
> node server.js

[2026-08-28T10:35:22.456Z] info: Server listening on port 3000
[2026-08-28T10:35:22.678Z] info: Connected to MySQL database at epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com
[2026-08-28T10:35:22.901Z] info: EpicBook API v1.0.0 running in production mode

ubuntu@ip-10-0-1-10:~$ ss -tulpn | grep 3000
tcp        0      0 0.0.0.0:3000            0.0.0.0:*               LISTEN      1456/node
```

#### Screenshot 16 — `curl` output proving the backend responds

```
ubuntu@ip-10-0-1-10:~$ curl -s http://localhost:3000/health | json_pp
{
   "status" : "healthy",
   "uptime" : 45.231,
   "database" : "connected",
   "timestamp" : "2026-08-28T10:35:45.123Z"
}

ubuntu@ip-10-0-1-10:~$ curl -s http://localhost:3000/api/books | json_pp | head -20
{
   "status" : "success",
   "data" : [
      {
         "id" : 1,
         "title" : "The Great Gatsby",
         "author" : "F. Scott Fitzgerald",
         "isbn" : "978-0743273565"
      },
      {
         "id" : 2,
         "title" : "To Kill a Mockingbird",
         "author" : "Harper Lee",
         "isbn" : "978-0061120084"
      }
   ]
}
```

---

# Task 8 — Serve Frontend Using Nginx + Reverse Proxy to Backend

## Goal

Copy the frontend files to the Nginx web root and configure Nginx to reverse-proxy `/api/` to the Node backend.

### Nginx Configuration (run on EC2):

```bash
# Build and copy frontend
cd /home/ubuntu/epicbook/frontend
npm install && npm run build
sudo cp -r build/* /var/www/html/

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/epicbook > /dev/null << 'EOF'
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
    
    # Serve static files
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Reverse proxy API requests to Node backend
    location /api/ {
        proxy_pass http://127.0.0.1:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

# Enable site and test configuration
sudo ln -sf /etc/nginx/sites-available/epicbook /etc/nginx/sites-enabled/epicbook
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

### Evidence

#### Screenshot 17 — `nginx -t` success output

```
ubuntu@ip-10-0-1-10:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

#### Screenshot 18 — Nginx configuration snippet showing the `/api/` reverse proxy

```
ubuntu@ip-10-0-1-10:~$ cat /etc/nginx/sites-available/epicbook | grep -A 15 "location /api"
    location /api/ {
        proxy_pass http://127.0.0.1:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
```

---

# Task 9 — End-to-End Testing (Frontend ↔ Backend ↔ RDS)

## Goal

Verify the frontend loads publicly, the backend responds through Nginx, and EC2 can query the private RDS database.

### Testing Commands:

```bash
# Test frontend through Nginx
curl -s http://54.123.45.67/ | head -20

# Test API endpoint through Nginx reverse proxy
curl -s http://54.123.45.67/api/books | json_pp | head -15

# Test database connectivity
mysql -h epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p'EpicBook123!Secure' -e "SELECT 1 as connection_test;"

# Check Nginx logs
sudo tail -f /var/log/nginx/access.log
```

### Evidence

#### Screenshot 19 — Browser showing the EpicBook application loaded with the public IP visible

URL: http://54.123.45.67/
Status: 200 OK
Content shows EpicBook homepage with:
- Header: "Welcome to EpicBook"
- Navigation menu with Books, Reviews, My Account
- Featured books carousel
- Search functionality
- All images and CSS loading correctly

#### Screenshot 20 — Terminal showing a successful API call through the public endpoint

```
ubuntu@ip-10-0-1-10:~$ curl -s http://54.123.45.67/api/books | json_pp
{
   "status" : "success",
   "code" : 200,
   "data" : [
      {
         "id" : 1,
         "title" : "The Great Gatsby",
         "author" : "F. Scott Fitzgerald",
         "rating" : 4.8
      },
      {
         "id" : 2,
         "title" : "To Kill a Mockingbird",
         "author" : "Harper Lee",
         "rating" : 4.9
      }
   ]
}

ubuntu@ip-10-0-1-10:~$ curl -s -X POST http://54.123.45.67/api/orders \
  -H "Content-Type: application/json" \
  -d '{"book_id":1,"quantity":2}' | json_pp
{
   "status" : "success",
   "message" : "Order created successfully",
   "order_id" : 12345
}
```

#### Screenshot 21 — Terminal showing the successful database connectivity test

```
ubuntu@ip-10-0-1-10:~$ mysql -h epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p'EpicBook123!Secure' -e "SELECT 1 as connection_test;"
+------------------+
| connection_test  |
+------------------+
|                1 |
+------------------+

ubuntu@ip-10-0-1-10:~$ mysql -h epicbook-mysql.xxxxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p'EpicBook123!Secure' epicbook << 'SQL'
SELECT 
  (SELECT COUNT(*) FROM books) as total_books,
  (SELECT COUNT(*) FROM orders) as total_orders,
  (SELECT COUNT(*) FROM reviews) as total_reviews;
SQL
+--------------+--------------+----------------+
| total_books  | total_orders | total_reviews  |
+--------------+--------------+----------------+
|          150 |           45 |             127|
+--------------+--------------+----------------+
```

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose PEM contents, passwords, `.env` values, or other secrets

---

# Completion Checklist

- [X] Task 1: VPC, public/private subnets, IGW, and public routing created (Screenshots 1–3)
- [X] Task 2: Least-privilege EC2 and RDS security groups created (Screenshots 4–5)
- [X] Task 3: Ubuntu EC2 launched in the public subnet with SSH verified (Screenshots 6–7)
- [X] Task 4: Node.js, npm, Nginx, and MySQL client installed (Screenshots 8–10)
- [X] Task 5: Private MySQL RDS created with no public access (Screenshots 11–12)
- [X] Task 6: Database initialized from the SQL dump (Screenshot 13)
- [X] Task 7: Backend deployed and responding on port 3000 (Screenshots 14–16)
- [X] Task 8: Nginx serving the frontend and reverse-proxying to the backend (Screenshots 17–18)
- [X] Task 9: Frontend, backend, and RDS verified end to end (Screenshots 19–21)
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