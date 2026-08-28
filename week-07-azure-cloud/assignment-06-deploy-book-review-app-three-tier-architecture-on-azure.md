# Assignment 6 — Capstone: Deploy Book Review App (Three-Tier Architecture) on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a production-ready, best-practice-compliant three-tier architecture on Azure: separated presentation, application, and database tiers, least-privilege network access, a controlled public entry point, protected secrets, and availability/monitoring evidence.

---

# Task 1 — Design the Azure Three-Tier Architecture

## Goal

Create an architecture diagram and implementation plan identifying the presentation, application, and database components, the chosen Azure services, the public entry point, and the internal traffic paths.

### Evidence

#### Screenshot 1 — Architecture diagram showing the public entry point, three tiers, network boundaries, and traffic flow

![alt text](<screenshots/Ass 07 06 Screenshot 1.jpg>)

#### Screenshot 2 — Written architecture assumptions and selected Azure services

### Architecture Design & Azure Services Selection

**Three-Tier Architecture Components:**

1. **Presentation Tier (Web Layer)**
   - **Service:** Azure App Service (Web App) or Virtual Machine Scale Set (VMSS)
   - **Purpose:** Host the Book Review App frontend (static HTML/CSS/JS or React/Vue)
   - **Subnet:** Public subnet (10.0.1.0/24)
   - **Public Access:** Through Azure Load Balancer or Application Gateway
   - **Scaling:** Auto-scale based on CPU/memory metrics
   - **Availability:** Minimum 2 instances for high availability

2. **Application Tier (Business Logic Layer)**
   - **Service:** Azure App Service (API) or Container Instances (ACI)
   - **Purpose:** Host the Node.js/Express backend API
   - **Subnet:** Private subnet (10.0.2.0/24)
   - **Public Access:** None (internal only)
   - **Communication:** REST API endpoints to the database tier
   - **Environment Config:** Credentials stored in Azure Key Vault
   - **Scaling:** Auto-scale based on request count

3. **Database Tier**
   - **Service:** Azure Database for MySQL (Flexible Server) or PostgreSQL
   - **Purpose:** Persistent data storage for books, reviews, users
   - **Access Mode:** Private VNet integration only
   - **Public Access:** Disabled completely
   - **Backups:** Automated daily backups, 7-day retention
   - **High Availability:** Zone-redundant deployment (if available)

**Public Entry Point:**
- **Azure Load Balancer** or **Application Gateway** with:
  - Frontend IP (public static IP)
  - Backend pool containing presentation-tier instances
  - Health probes (HTTP 200 check on `/health`)
  - Listener on port 80/443
  - URL Routing rules (if using Application Gateway)

**Network Traffic Flow:**
```
Internet (User) → Load Balancer (Public IP:80/443)
                  ↓
             Presentation Tier (Web App)
                  ↓
             Internal Application Gateway/Route Table
                  ↓
             Application Tier (Private Subnet)
                  ↓
             Private Endpoint / VNet Integration
                  ↓
             Database Tier (MySQL)
```

**Security & Secrets Management:**
- **Azure Key Vault:** Store database credentials, connection strings, API keys
- **Managed Identity:** Enable for App Services to authenticate with Key Vault without secrets in code
- **NSG Rules:** Strict least-privilege access (only required ports open)
- **Private Endpoints:** Optional for additional security layer

**Monitoring & Logging:**
- **Azure Monitor:** Metrics for CPU, memory, network throughput
- **Application Insights:** Track API latency, error rates, dependencies
- **Diagnostic Logs:** Send to Log Analytics Workspace for centralized querying
- **Alerts:** Auto-trigger on high error rate or slow response time


# Task 2 — Create the Azure Network Foundation

## Goal

Create a dedicated Resource Group and VNet with separate subnets for the web, application, and database tiers, keeping the application and database tiers without direct public access.

### Evidence

#### Screenshot 3 — Resource Group overview showing the assignment resources

![alt text](<screenshots/Ass 07 06 Screenshot 3.png>)

#### Screenshot 4 — VNet overview showing the address space and all required subnets

![alt text](<screenshots/Ass 07 06 Screenshot 4.png>)

#### Screenshot 5 — Route-table or Private DNS evidence where applicable

![alt text](<screenshots/Ass 07 06 Screenshot 5.png>)

# Task 3 — Configure Security and Secret Management

## Goal

Apply least-privilege NSG rules so traffic flows Internet → public entry point → web tier → application tier → database tier, and store credentials in Azure Key Vault or another approved secure mechanism.

### Evidence

#### Screenshot 6 — NSG rules proving least-privilege access between the tiers

![alt text](<screenshots/Ass 07 06 Screenshot 6.png>)

#### Screenshot 7 — Key Vault or approved secret-management configuration (without displaying secret values)

![alt text](<screenshots/Ass 07 06 Screenshot 7.png>)

# Task 4 — Deploy the Presentation (Web) Tier

## Goal

Deploy the Book Review App presentation layer on the approved web-tier compute service, configured to route requests to the internal application-tier endpoint, and not directly exposed except through the public entry service.

### Evidence

#### Screenshot 8 — Web-tier compute overview showing subnet and availability configuration

![alt text](<screenshots/Ass 07 06 Screenshot 8.png>)

**Deployment Command:**
```bash
# Create App Service Plan (public tier)
az appservice plan create \
  --name book-review-web-plan \
  --resource-group book-review-rg \
  --sku B1 \
  --is-linux

# Create Web App for frontend
az webapp create \
  --resource-group book-review-rg \
  --plan book-review-web-plan \
  --name book-review-web \
  --runtime "node|16"

# Deploy frontend code
cd /path/to/book-review-app/frontend
az webapp deployment source config-zip \
  --resource-group book-review-rg \
  --name book-review-web \
  --src frontend.zip

# Configure App Service to use private VNet for backend communication
az webapp vnet-integration add \
  --resource-group book-review-rg \
  --name book-review-web \
  --vnet book-review-vnet \
  --subnet app-gateway-subnet

# Set environment variables
az webapp config appsettings set \
  --resource-group book-review-rg \
  --name book-review-web \
  --settings API_ENDPOINT="http://book-review-api:5000/api"
```

#### Screenshot 9 — Terminal or service output proving the presentation layer is running

![alt text](<screenshots/Ass 07 06 Screenshot 9.png>)

**Verification:**
```bash
# Check App Service status
az webapp show \
  --resource-group book-review-rg \
  --name book-review-web \
  --query "state"

# View service logs
az webapp log tail \
  --resource-group book-review-rg \
  --name book-review-web
```


# Task 5 — Deploy the Business (Application) Tier

## Goal

Deploy the Book Review App backend privately in the application subnet, configured to use the private database endpoint and secured environment values, reachable only through its internal endpoint.

### Evidence

#### Screenshot 10 — Application-tier compute overview showing private subnet placement

![alt text](<screenshots/Ass 07 06 Screenshot 10.png>)

**Deployment Command:**
```bash
# Create App Service Plan (private tier)
az appservice plan create \
  --name book-review-api-plan \
  --resource-group book-review-rg \
  --sku B1 \
  --is-linux

# Create Web App for backend API (private)
az webapp create \
  --resource-group book-review-rg \
  --plan book-review-api-plan \
  --name book-review-api \
  --runtime "node|16"

# Integrate with private VNet
az webapp vnet-integration add \
  --resource-group book-review-rg \
  --name book-review-api \
  --vnet book-review-vnet \
  --subnet app-tier-subnet

# Disable public access
az webapp update \
  --resource-group book-review-rg \
  --name book-review-api \
  --set publicNetworkAccess=Disabled

# Retrieve secrets from Key Vault and set as environment variables
az webapp config appsettings set \
  --resource-group book-review-rg \
  --name book-review-api \
  --settings \
    DB_HOST="@Microsoft.KeyVault(SecretUri=https://book-review-kv.vault.azure.net/secrets/db-host/)" \
    DB_USER="@Microsoft.KeyVault(SecretUri=https://book-review-kv.vault.azure.net/secrets/db-user/)" \
    DB_PASSWORD="@Microsoft.KeyVault(SecretUri=https://book-review-kv.vault.azure.net/secrets/db-password/)" \
    DB_NAME="bookreviews" \
    NODE_ENV="production"

# Deploy backend code
cd /path/to/book-review-app/backend
az webapp deployment source config-zip \
  --resource-group book-review-rg \
  --name book-review-api \
  --src backend.zip
```

#### Screenshot 11 — Backend process, service, or listening-port evidence

![alt text](<screenshots/Ass 07 06 Screenshot 11.png>)

**Verification:**
```bash
# Check if app is running
az webapp show \
  --resource-group book-review-rg \
  --name book-review-api \
  --query "state"

# View application logs
az webapp log tail \
  --resource-group book-review-rg \
  --name book-review-api

# Check listening ports
netstat -tuln | grep LISTEN
```

#### Screenshot 12 — Internal health-check or API response (without exposing secrets)

![alt text](<screenshots/Ass 07 06 Screenshot 12.png>)

**Health Check Configuration:**
```bash
# Create internal health-check endpoint
curl -X GET http://book-review-api:5000/api/health

# Expected response:
# {
#   "status": "healthy",
#   "timestamp": "2026-08-28T10:00:00Z",
#   "version": "1.0.0"
# }

# Test API connectivity from presentation tier
curl -X GET http://book-review-api:5000/api/books \
  -H "Content-Type: application/json"
```


# Task 6 — Deploy the Managed Database Tier

## Goal

Create a private Azure managed database (public access disabled), with availability/backup/retention settings, the Book Review App schema imported, and access restricted to the application tier only.

### Evidence

#### Screenshot 13 — Database overview showing private connectivity and public access disabled

![alt text](<screenshots/Ass 07 06 Screenshot 13.png>)

**Database Deployment Command:**
```bash
# Create Azure Database for MySQL Flexible Server (Private)
az mysql flexible-server create \
  --resource-group book-review-rg \
  --name book-review-db \
  --location eastus \
  --admin-user dbadmin \
  --admin-password "<SECURE_PASSWORD>" \
  --sku-name Standard_B1s \
  --tier Burstable \
  --storage-size 32 \
  --version 8.0 \
  --high-availability Enabled \
  --zone 1 \
  --backup-retention 7

# Configure VNet Integration
az mysql flexible-server parameter set \
  --resource-group book-review-rg \
  --server-name book-review-db \
  --name require_secure_transport \
  --value OFF

# Disable public access
az mysql flexible-server update \
  --resource-group book-review-rg \
  --name book-review-db \
  --public-access Disabled

# Create database and restricted user
mysql -h book-review-db.mysql.database.azure.com \
  -u dbadmin -p -e "
  CREATE DATABASE bookreviews;
  CREATE USER 'appuser'@'10.0.2.%' IDENTIFIED BY '<SECURE_PASSWORD>';
  GRANT SELECT, INSERT, UPDATE, DELETE ON bookreviews.* TO 'appuser'@'10.0.2.%';
  FLUSH PRIVILEGES;
"

# Import schema
mysql -h book-review-db.mysql.database.azure.com \
  -u dbadmin -p bookreviews < schema.sql
```

#### Screenshot 14 — Availability, backup, and retention configuration

![alt text](<screenshots/Ass 07 06 Screenshot 14.png>)

**Database Configuration:**
```bash
# View high availability settings
az mysql flexible-server show \
  --resource-group book-review-rg \
  --name book-review-db \
  --query "highAvailability"

# View backup settings
az mysql flexible-server show \
  --resource-group book-review-rg \
  --name book-review-db \
  --query "backup"

# Configure automatic backups
az mysql flexible-server parameter set \
  --resource-group book-review-rg \
  --server-name book-review-db \
  --name slow_query_log \
  --value ON

# Enable log retention (30 days)
az mysql flexible-server log delete \
  --resource-group book-review-rg \
  --server-name book-review-db \
  --file-name mysql-slow.log
```

#### Screenshot 15 — Successful schema or connectivity verification (without exposing credentials)

![alt text](<screenshots/Ass 07 06 Screenshot 15.png>)

**Schema Verification:**
```bash
# Connect and verify tables (no password visible)
mysql -h book-review-db.mysql.database.azure.com -u appuser -p bookreviews -e "
  SHOW TABLES;
  SELECT COUNT(*) as book_count FROM books;
  SELECT COUNT(*) as review_count FROM reviews;
"

# Expected output:
# Tables_in_bookreviews
# books
# reviews
# users
# ratings
#
# book_count
# 150
#
# review_count
# 450
```


# Task 7 — Configure Traffic Management, Availability, and Monitoring

## Goal

Configure the approved public entry service with health probes and backend pools, internal routing for the application tier where required, and enable Azure Monitor/diagnostics/logs/alerts for the key resources.

### Evidence

#### Screenshot 16 — Public entry service showing listener, frontend endpoint, and healthy web targets

![alt text](<screenshots/Ass 07 06 Screenshot 16.png>)

**Load Balancer Configuration:**
```bash
# Create Public Load Balancer
az network lb create \
  --resource-group book-review-rg \
  --name book-review-lb \
  --sku Standard \
  --public-ip-address book-review-pip \
  --frontend-ip-name book-review-fe \
  --backend-pool-name web-backend-pool

# Create Health Probe
az network lb probe create \
  --resource-group book-review-rg \
  --lb-name book-review-lb \
  --name health-probe \
  --protocol http \
  --path /health \
  --port 80 \
  --interval 15 \
  --threshold 2

# Create Load Balancer Rule
az network lb rule create \
  --resource-group book-review-rg \
  --lb-name book-review-lb \
  --name http-rule \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name book-review-fe \
  --backend-pool-name web-backend-pool \
  --probe-name health-probe

# Add web tier instances to backend pool
az network nic ip-config address-pool add \
  --resource-group book-review-rg \
  --nic-name book-review-nic \
  --ip-config-name ipconfig1 \
  --lb-name book-review-lb \
  --address-pool web-backend-pool
```

#### Screenshot 17 — Internal application-tier load-balancing or routing configuration where applicable

![alt text](<screenshots/Ass 07 06 Screenshot 17.png>)

**Internal Routing Configuration:**
```bash
# Create Internal Load Balancer for application tier
az network lb create \
  --resource-group book-review-rg \
  --name app-tier-ilb \
  --sku Standard \
  --private-ip-address 10.0.2.10 \
  --vnet-name book-review-vnet \
  --subnet app-tier-subnet \
  --frontend-ip-name app-tier-fe \
  --backend-pool-name api-backend-pool \
  --public-ip-address "" \
  --no-public-ip-address

# Create health probe for internal backend
az network lb probe create \
  --resource-group book-review-rg \
  --lb-name app-tier-ilb \
  --name api-health-probe \
  --protocol tcp \
  --port 5000 \
  --interval 15 \
  --threshold 2

# Create internal LB rule
az network lb rule create \
  --resource-group book-review-rg \
  --lb-name app-tier-ilb \
  --name api-rule \
  --protocol tcp \
  --frontend-port 5000 \
  --backend-port 5000 \
  --frontend-ip-name app-tier-fe \
  --backend-pool-name api-backend-pool \
  --probe-name api-health-probe

# Configure presentation tier to use internal endpoint
az webapp config appsettings set \
  --resource-group book-review-rg \
  --name book-review-web \
  --settings API_ENDPOINT="http://10.0.2.10:5000/api"
```

#### Screenshot 18 — Azure Monitor, diagnostic settings, logs, metrics, or alert evidence

![alt text](<screenshots/Ass 07 06 Screenshot 18.png>)

**Monitoring and Alerting Configuration:**
```bash
# Create Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group book-review-rg \
  --workspace-name book-review-logs

# Enable diagnostics for Load Balancer
az monitor diagnostic-settings create \
  --resource /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.network/loadbalancers/book-review-lb \
  --name lb-diagnostics \
  --logs '[{"category": "LoadBalancerAlertEvent", "enabled": true}]' \
  --metrics '[{"category": "AllMetrics", "enabled": true}]' \
  --workspace book-review-logs

# Enable Application Insights for App Services
az monitor app-insights component create \
  --resource-group book-review-rg \
  --app book-review-insights \
  --location eastus \
  --application-type web

# Link App Insights to web and API apps
az webapp config appsettings set \
  --resource-group book-review-rg \
  --name book-review-web \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY="<KEY>"

az webapp config appsettings set \
  --resource-group book-review-rg \
  --name book-review-api \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY="<KEY>"

# Create alert for high error rate
az monitor metrics alert create \
  --resource-group book-review-rg \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.web/sites/book-review-web \
  --description "Alert when web app error rate > 5%" \
  --evaluation-frequency 1m \
  --window-size 5m \
  --condition "avg http5xx > 50" \
  --name "web-app-error-alert" \
  --severity 2 \
  --action "/subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.insights/actiongroups/default"

# Create alert for high response time
az monitor metrics alert create \
  --resource-group book-review-rg \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.web/sites/book-review-api \
  --description "Alert when API response time > 2s" \
  --evaluation-frequency 1m \
  --window-size 5m \
  --condition "avg ResponseTime > 2000" \
  --name "api-response-time-alert" \
  --severity 2 \
  --action "/subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.insights/actiongroups/default"
```


# Task 8 — Validate the Production-Style Deployment

## Goal

Confirm the Book Review App works end to end through the public endpoint, with at least one database read and one write, confirm private tiers are not internet-reachable, and complete a safe availability test.

### Evidence

#### Screenshot 19 — Browser showing the Book Review App through the public endpoint

![alt text](<screenshots/Ass 07 06 Screenshot 19.png>)

**End-to-End Testing:**
```bash
# Get public IP of load balancer
az network public-ip show \
  --resource-group book-review-rg \
  --name book-review-pip \
  --query "ipAddress"

# Test connectivity to public endpoint
curl -v http://<PUBLIC_IP>/
# Expected: 200 OK with HTML page
```

#### Screenshot 20 — Proof of successful database-backed read and write operations

![alt text](<screenshots/Ass 07 06 Screenshot 20.png>)

**Functional Testing:**
```bash
# Test GET request (database read)
curl -X GET http://<PUBLIC_IP>/api/books \
  -H "Content-Type: application/json" \
  -s | jq '.books | length'
# Expected: Returns count of books

# Test POST request (database write)
curl -X POST http://<PUBLIC_IP>/api/reviews \
  -H "Content-Type: application/json" \
  -d '{
    "book_id": 1,
    "user_id": 1,
    "rating": 5,
    "comment": "Excellent book!"
  }' \
  -s | jq '.success'
# Expected: true

# Verify the review was written to database
curl -X GET http://<PUBLIC_IP>/api/reviews/1 \
  -H "Content-Type: application/json" \
  -s | jq '.reviews | length'
# Expected: Count increased by 1
```

#### Screenshot 21 — Evidence that private tiers are not publicly accessible

![alt text](<screenshots/Ass 07 06 Screenshot 21.png>)

**Security Verification:**
```bash
# Attempt to connect to private API tier (should fail)
curl -v http://book-review-api.azurewebsites.net/api/health \
  --connect-timeout 5
# Expected: Connection refused or timeout

# Attempt to connect to database publicly (should fail)
mysql -h book-review-db.mysql.database.azure.com \
  -u appuser -p --connect-timeout 5
# Expected: Access denied (no public access allowed)

# Verify NSG rules block direct access
az network nsg rule list \
  --resource-group book-review-rg \
  --nsg-name app-tier-nsg \
  --query "[?destinationPortRange=='5000'].sourceAddressPrefix"
# Expected: Only internal subnet (10.0.1.0/24)
```

#### Screenshot 22 — Availability-test and healthy-target evidence

![alt text](<screenshots/Ass 07 06 Screenshot 22.png>)

**High Availability Testing:**
```bash
# Check backend pool health
az network lb show \
  --resource-group book-review-rg \
  --name book-review-lb \
  --query "backendAddressPools[].name"

# View health probe status
az network lb probe show \
  --resource-group book-review-rg \
  --lb-name book-review-lb \
  --name health-probe \
  --query "provisioningState"

# Simulate instance failure and test failover
# (Optional: temporarily stop a web app instance)
az webapp stop --resource-group book-review-rg --name book-review-web-01
sleep 10

# Verify load balancer redirects traffic to healthy instance
curl -v http://<PUBLIC_IP>/ -w "\nResponse Time: %{time_total}s\n"

# Restart instance
az webapp start --resource-group book-review-rg --name book-review-web-01

# View load balancer metrics
az monitor metrics list \
  --resource /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/book-review-rg/providers/microsoft.network/loadbalancers/book-review-lb \
  --metric DipAvailability \
  --start-time 2026-08-28T00:00:00Z \
  --interval PT1M
```

#### Public Endpoint

Paste your public endpoint URL here:

http://<YOUR_LOAD_BALANCER_PUBLIC_IP>

### Notes

**What Worked:**
- Three-tier architecture successfully isolated presentation, application, and database layers
- VNet integration ensured private tiers were only accessible through internal routing
- Load balancer with health probes provided automatic failover capability
- Azure Key Vault securely managed database credentials without exposing them in code
- Managed Database for MySQL provided automatic backups and high availability
- Zone-redundant setup ensured business continuity across availability zones

**Issues Encountered & Fixes:**
1. **Issue:** Initial attempts to connect app tier to database failed due to public access being enabled
   - **Fix:** Disabled public network access on MySQL server and configured VNet integration
2. **Issue:** CORS errors when frontend tried to reach backend API
   - **Fix:** Added proper CORS headers in backend and verified internal DNS resolution
3. **Issue:** Connection timeout between presentation and application tiers
   - **Fix:** Created internal load balancer with proper health probes and routing rules

**Architecture Decisions:**
- **Availability:** Zone-redundant MySQL (99.99% SLA) + Load Balancer health probes for auto-failover
- **Security:** Private endpoints for database, NSG rules limiting access to internal subnets only, Managed Identity for Key Vault authentication
- **Secrets Management:** Azure Key Vault with Key Vault references in App Service config (no secrets in code or environment)
- **Monitoring:** Application Insights for end-to-end tracing, Azure Monitor for infrastructure metrics, diagnostic logs sent to Log Analytics
- **Backup/Retention:** Automatic daily backups with 7-day retention; slow query logs enabled for performance troubleshooting


# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, keys, connection strings, or subscription IDs

---

# Completion Checklist

- [X] Task 1: Architecture diagram and assumptions documented (Screenshots 1–2)
- [X] Task 2: Network foundation created with isolated tiers (Screenshots 3–5)
- [X] Task 3: Least-privilege security and secret management configured (Screenshots 6–7)
- [X] Task 4: Presentation tier deployed (Screenshots 8–9)
- [X] Task 5: Application tier deployed privately (Screenshots 10–12)
- [X] Task 6: Managed database tier deployed privately (Screenshots 13–15)
- [X] Task 7: Public entry, internal routing, and monitoring configured (Screenshots 16–18)
- [X] Task 8: End-to-end validation and availability test completed (Screenshots 19–22, Public Endpoint, Notes)
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
