# Assignment 3 — Production Maintenance Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will treat your already deployed React application (on Ubuntu VM with Nginx) as a live production system. You will perform structured operational checks covering network validation, service health, log analysis, resource monitoring, configuration verification, and incident simulation with recovery — mirroring real on-call DevOps responsibilities.

---

# Task 1 — Server Access & Networking Validation

## Goal

Verify that the deployed React application is reachable from the browser and confirm basic network connectivity of the Ubuntu VM.

### Evidence

#### Screenshot 1 — Browser showing the React app with your Full Name visible on the UI

Add your screenshot here.

--- ![alt text](<Tasks 1-3.png>)

#### Screenshot 2 — Output of `ip a`

Add your screenshot here.

--- ![alt text](<Tasks 2-1.png>)

#### Screenshot 3 — Output of `sudo ss -tulpen`

Add your screenshot here.

--- ![alt text](<Tasks 3-1.png>)

#### Screenshot 4 — Output of `sudo ufw status`

Add your screenshot here.

--- ![alt text](<Tasks 4-1.png>)

### Notes

Answer the following in your own words:

**1. What proves Nginx is listening on 0.0.0.0:80?**

Write your answer here.

--- With ss -tulpen output. You will see a line containing tcp LISTEN ... 0.0.0.0:80 (or *:80) with users:(("nginx",...)). This explicitly states the Nginx process is bound to port 80 across all available network interfaces.

**2. What proves SSH is active on port 22?**

Write your answer here.

--- In the same ss output, a line will show tcp LISTEN ... 0.0.0.0:22 or [::]:22 tied to sshd. Additionally, if you are actively connected via SSH to run these commands, that network socket session itself proves it is operational.

**3. Did you find any unexpected open ports? Explain briefly.**

Write your answer here.

--- Check if ports like 22 (SSH) and 80 (HTTP) / 443 (HTTPS) are the only ones open. If you see things like port 3000 (development servers) or database ports (3306, 5432) exposed to the public (0.0.0.0), those are unexpected and represent a security risk.

# Task 2 — Service Health & Systemd Validation (Nginx)

## Goal

Verify that Nginx is properly installed, running, enabled at boot, and safely configured.

### Evidence

#### Screenshot 1 — Output of `systemctl status nginx --no-pager`

Add your screenshot here.

--- ![alt text](<Tasks 2 1.png>)

#### Screenshot 2 — Output of `sudo nginx -t`

Add your screenshot here.

--- ![alt text](<Tasks 2 2.png>)

#### Screenshot 3 — Output of `sudo ss -lptn '( sport = :80 )'
Add your screenshot here.

--- ![alt text](<Tasks 2 3.png>)

### Notes

Answer the following in your own words:

**1. What happens if Nginx fails to restart in production?**

Write your answer here.

--- If Nginx fails to restart, the web server goes down. Users trying to access your React application will receive a "Connection Refused" or timeout error, causing a complete production outage.

**2. What's your basic rollback plan?**

Write your answer here.

--- Always run sudo nginx -t before restarting. If a restart fails, immediately check sudo journalctl -eu nginx to find the syntax/configuration error, revert the latest configuration changes to the last known working backup, and restart the service again.

# Task 3 — Logs & Request Trace

## Goal

Verify real traffic flow and analyze logs to understand system behavior and errors.

### Evidence

#### Screenshot 1 — Output of `sudo tail -n 30 /var/log/nginx/access.log`

Add your screenshot here.

--- ![alt text](<Tasks 3 1.png>)

#### Screenshot 2 — Output of `sudo tail -n 30 /var/log/nginx/error.log`

Add your screenshot here.

--- ![alt text](<Tasks 3 2.png>)

#### Screenshot 3 — Output of `sudo journalctl -u nginx --no-pager -n 50`

Add your screenshot here.

--- ![alt text](<Tasks 3 3.png>)

### Notes

Answer the following in your own words:

**1. Were there any errors in the logs?**

- If yes, mention 1–2 example error lines from the logs and explain what each one means in simple terms.
- If no, explain what it means if the error log is empty or shows no recent errors during your check.

Write your answer here.

--- Look for lines with [error] or HTTP status codes in the 4xx/5xx range. If empty or showing no recent errors, it means Nginx has not encountered missing files (404), permission issues (403), or configuration routing mishaps since the last log rotation.

**2. If there were no errors, what does that indicate about the system?**

Write your answer here.

--- It indicates basic operational health; runtime configurations are syntactically sound, assets are right where Nginx expects them to be, and permissions are correctly mapped.

**3. Based on the access logs, were your curl requests visible in the log entries? What does that prove about traffic flow?**

Write your answer here.

--- Yes, there are entries with the user-agent curl/... and the public client IP address. This proves end-to-end traffic flow is working: requests successfully travel through the cloud network, hit the VM's network interface, and are processed directly by Nginx.

# Task 4 — System Resource Health Check (Capacity Red Flags)

## Goal

Assess server capacity and detect potential performance or failure risks.

### Evidence

#### Screenshot 1 — Output of `uptime`

Add your screenshot here.

--- ![alt text](<Tasks 4 1.png>)

#### Screenshot 2 — Output of `free -h`

Add your screenshot here.

--- ![alt text](<Tasks 4 2.png>)

#### Screenshot 3 — Output of `df -h`

Add your screenshot here.

--- ![alt text](<Tasks 4 3.png>)

#### Screenshot 4 — Output of `sudo du -sh /var/* | sort -h`

Add your screenshot here.

--- ![alt text](<Tasks 4 4.png>)

### Notes

Answer the following in your own words:

**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

Write your answer here.

--- Memory is often the most critical resource because React builds or multiple running processes can easily consume 1GB of RAM, leading to caching issues or out-of-memory (OOM) kills.

**2. What happens if disk becomes 100% full in a production server?**

Write your answer here.

--- The system will fail completely. Nginx won't be able to write to its access or error logs, database engines won't be able to write transactions, cron jobs will fail, and SSH sessions might even block you from logging in to fix the problem.

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

Add your screenshot here.

--- ![alt text](<Tasks 5 1.png>)

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

Add your screenshot here.

--- ![alt text](<Tasks 5 2.png>)

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

Add your screenshot here.

--- ![alt text](<Tasks 5 3.png>)

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

Write your answer here.

--- You can verify it by checking the timestamps of the static assets in /var/www/html to ensure they match your latest deployment time, or by running grep to find specific unique strings, version tags, or commit hashes injected into the HTML/JS build files.

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

Add your screenshot here.
--- ![alt text](<Tasks 6 1.png>)

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

Add your screenshot here.

--- ![alt text](<Tasks 6 2.png>)

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

Add your screenshot here.

---![alt text](<Tasks 6 3.png>)

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

Write your answer here.

--- The configuration failure was caused by a syntax error inside the Nginx default virtual host file (/etc/nginx/sites-available/default). Specifically, a non-Nginx terminal command (sudo or nano /etc/nginx/sites-available/default) was accidentally pasted into the configuration file on line 39/41. Because Nginx did not recognize this as a valid directive, the configuration syntax test failed.

**2. How did you fix the issue?**

Write your answer here.

--- I fixed the issue by:

Running sudo nginx -t to locate the exact line number causing the syntax error.

Opening the configuration file using sudo nano /etc/nginx/sites-available/default and navigating to the problematic line.

Removing the accidental text paste and converting the line back into a standard Nginx comment (# include snippets/snakeoil.conf;).

Re-running sudo nginx -t to verify that the syntax was clean, and finally reloading Nginx using sudo systemctl reload nginx to safely apply the configuration.

**3. How can you avoid this kind of issue in real production systems?**

Write your answer here.

--- In a real production environment, you can avoid these manual configuration errors by implementing the following practices:

Pre-commit and Pre-deployment Checks: Integrate configuration validation tests (like nginx -t) into a CI/CD pipeline. This ensures broken configurations are automatically blocked in staging before they can ever be deployed to a live production server.

Infrastructure as Code (IaC) & Configuration Management: Use tools like Ansible, Chef, Puppet, or Terraform to manage configurations programmatically rather than manually editing configuration files on live production servers.

Linting Tools: Use Nginx configuration linter tools in your code editor to catch syntax errors and formatting mistakes in real-time before committing changes.

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

Add your screenshot here.

--- ![alt text](<Tasks 7 1.png>)

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

Add your screenshot here.

--- ![alt text](<Tasks 7 2.png>)

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

Write your answer here

--- The web host's target document root path (/var/www/html) was moved/renamed. Because Nginx's block configuration explicitly points to that folder directory to serve up the frontend build assets (index.html), removing it leaves Nginx with nothing to fetch.

**2. How did you fix the issue and restore the application?**

Write your answer here.

--- The path matches Nginx's configuration again, it instantly processes incoming traffic without even needing a service reload.

**3. What steps would you take to prevent this kind of issue in real production systems?**

Write your answer here.

--- By implementing Atomic Symlink Deployments. Instead of copying production build folders straight into a live path, you deploy your new version to a separate folder (like /var/www/build_v2) and update a symbolic link pointing to it (/var/www/html -> /var/www/build_v2). If a build fails or goes missing, you can instantaneously toggle the symlink back to a previous folder without knocking your application offline.

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

Write your answer here.

--- Cryptographic keys are mathematically impossible to guess or brute-force, completely eliminating the risk of automated password-cracking attacks.

**2. Why should only required ports be open on a production server?**

Write your answer here.

--- Every open port is an unlocked door into your server. If you leave a port open for a database or a development server, an attacker can look for flaws in those services to hack in.Closing unused ports minimizes your server's "attack surface," ensuring that malicious actors have fewer avenues to discover and exploit vulnerabilities in your background software.

**3. Why is it important for Nginx to be enabled on boot?**

Write your answer here.

--- Cloud instances occasionally restart due to hardware failures, cloud provider maintenance, or system updates. If a server reboots at 3:00 AM and Nginx is not enabled on boot, your website stays completely down until an engineer wakes up to start it manually.Ensuring Nginx is enabled on boot guarantees high availability; if the underlying VM unexpectedly restarts, the system automatically brings the web server back online without requiring manual intervention.

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

Write your answer here.

--- The internet is crawled constantly by malicious bots looking for exposed API keys, private SSH keys, and passwords.Publicly exposing credentials allows unauthorized actors to compromise user data, hijack control of your servers, or spin up malicious resources (like crypto-miners) that result in massive cloud financial bills.

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Write your answer here.

--- Cloud providers charge by the hour or second for running resources. Additionally, an unmonitored, active server is a security liability over time.Turning off unused infrastructure prevents unnecessary financial charges from the cloud provider and removes "forgotten" servers that might become unpatched security risks over time.

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`_______________https://www.linkedin.com/posts/silas-nyarko_dmi-cohort-4-live-micro-internship-waiting-share-7483625441837301760-Wq8N/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC77mYABXwQj5VAsAS-zzzdbpmvsIZLeP7U___________`

---

#### Screenshot — Published LinkedIn post

Add your screenshot here.

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [X] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [X] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [X] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [X] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [X] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [X] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [X] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [X] Task 8: Security & Reliability Notes answered
- [X] LinkedIn post published and URL submitted
- [X] Full Name visible in all required screenshots
- [X] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*