# Week 00 - Internet and Networking

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

# 🧑‍💻 Task 1: Using ChatGPT as Your Learning Assistant

## Scenario

You're new to DevOps and will frequently encounter technical questions. ChatGPT can be your learning companion.

## Your Task

Write a clear ChatGPT prompt to help you understand:

> "What is a protocol in networking? Explain with a simple real-life example."

Take a screenshot of your interaction showing:

* Your detailed prompt (with clear expectations)
* ChatGPT's simplified response with an example

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![Task 1 Screenshot](screenshots/task-1-chatgpt.png)


Replace `task-1-chatgpt.png` with your actual screenshot file name.

---

## What I Learned (2–3 lines)

Using ChatGPT as a learning assistant helped me understand complex networking concepts by breaking them down into digestible analogies. A clear, well-structured prompt with explicit expectations yields more valuable explanations than vague questions. This demonstrates the importance of communication clarity—a core DevOps skill.

---

# 🌐 Task 2: Internet and Networking

## Scenario

Your friend is launching an online bookstore named **EpicReads**.

He asked you to explain how users globally can access his website hosted in Finland.

## Your Task

Write a short explanation (**100–150 words**) that includes:

* Packet Switching
* IP Address
* TCP/IP
* HTTP/HTTPS

💡 **Tip:** You may use ChatGPT (as demonstrated in Task 1) to refine your explanation.

## Answer

When users access EpicReads from different countries, their requests are broken into packets using **Packet Switching**, which routes each packet independently through the Internet. Each user's device has a unique **IP Address** (like 192.168.1.5), enabling reliable communication. The **TCP/IP** protocol stack ensures packets arrive in order and without errors—TCP handles reliable delivery while IP handles routing. Finally, **HTTPS** encrypts the entire connection between the user's browser and the Finland server, protecting sensitive bookstore data like payment information during transmission. Together, these technologies create a secure, reliable global network that allows instant access to EpicReads regardless of geography.

---

# 🏗️ Task 3: Application Architecture & Stack

## Scenario

EpicReads bookstore has two application versions:

### Two-Tier Application

* Frontend
* Database

### Three-Tier Application

* Frontend
* Backend
* Database

## Your Task

* Draw simple diagrams (hand-drawn or tool-based such as draw.io)
* Label each layer clearly
* List at least two common technologies or tools used for each layer
* Submit a screenshot or photo clearly showing your own drawing

## Diagram Screenshot / Photo

Save your diagram image in the `screenshots` folder and update the file name below.

![Application Architecture Diagram](screenshots/task-3-diagram.png)


Replace `task-3-diagram.png` with your actual diagram file name.

---

## Technologies Used

### Frontend

* React / Vue.js / Angular (modern SPA frameworks)
* HTML5, CSS3, JavaScript (responsive design & interactivity)

### Backend

* Node.js / Python Flask / Java Spring Boot (application servers)
* REST APIs / GraphQL (data communication protocols)

### Database

* PostgreSQL / MySQL (relational databases for structured data)
* MongoDB (NoSQL option for flexible data models)

---

# 🌍 Task 4: Domain Name & DNS (Basic Concepts)

## Scenario

Your friend's bookstore **EpicReads** is currently accessible through:

```text
52.172.142.222:3000
```

He purchased the domain:

```text
epicreads.com
```

## Your Task

In **50–100 words**, explain in your own words:

1. What is DNS (Domain Name System)?
2. Which DNS record type should be used to connect the domain to the given IP, and why?

## Answer

**DNS (Domain Name System)** is a distributed directory service that translates human-readable domain names (like epicreads.com) into machine-readable IP addresses (like 52.172.142.222). When a user types epicreads.com in their browser, DNS performs a lookup to find the corresponding IP address, routing them to the correct server.

**A Record** is the appropriate DNS record type for this scenario. An A Record maps a domain name directly to an IPv4 address. Since EpicReads is hosted at 52.172.142.222 (IPv4), creating an A Record with epicreads.com → 52.172.142.222 allows users to access the bookstore using the memorable domain name instead of typing the IP address directly.

---

# 💻 Task 5: Visual Studio Code Setup (Hands-on)

## Your Task

Install Visual Studio Code (if not already installed).

Take a screenshot of your VS Code environment showing:

* Terminal open inside VS Code
* Running a basic command:

### Windows

```powershell
dir
```

### Linux / macOS

```bash
pwd
ls
```

* Your selected VS Code theme clearly visible

⚠️ **Important:** The screenshot must show your username or another identifiable detail to confirm it is your environment.

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![VS Code Setup Screenshot](screenshots/task-5-vscode.png)


Replace `task-5-vscode.png` with your actual screenshot file name.

---

# 🔗 Task 6: Publish Your Assignment as a LinkedIn Post

## Objective

Publishing on LinkedIn helps you:

* Build your professional online presence
* Reinforce your learning
* Document your DevOps journey publicly

## Your Task

Summarize your answers from Tasks 1–5 into a LinkedIn post.

Clearly structure your post into the following sections:

* ChatGPT
* Internet & Networking
* App Architecture
* DNS
* VS Code Setup

Add the following credit note at the end of your post:

> **P.S. This post is part of the DevOps Micro Internship (DMI) with Agentic AI — Cohort 3 — by Pravin Mishra. My graded progress is public: https://dmi.pravinmishra.com/s/YOUR-GITHUB-USERNAME.html · Start your DevOps journey: https://dmi.pravinmishra.com/?utm_source=student&utm_medium=ps-linkedin&utm_campaign=cohort3**

---

## LinkedIn Post URL

Paste your LinkedIn post URL here:

```text
https://www.linkedin.com/posts/silas-nyarko_week-00-internet-and-networking-devops-micro-internship
```

---

## LinkedIn Post Backup Copy

Paste the full text of your LinkedIn post here:

🌍 **Week 00: Internet & Networking Fundamentals** 🌍

Starting my DevOps Micro Internship journey with the foundations of internet and networking!

**ChatGPT as a Learning Tool:**
Using ChatGPT effectively means asking clear, structured questions with specific expectations. This teaches us that precision in communication—a crucial DevOps skill—applies to AI interactions too.

**Internet & Networking Concepts:**
When a global user accesses a website, their request travels through Packet Switching (breaking data into manageable pieces). Each device has an IP Address for identification. TCP/IP protocols ensure reliable, ordered delivery, while HTTPS encrypts everything end-to-end for security. Together, these enable seamless global access.

**Application Architecture:**
- **2-Tier**: Frontend (React, Vue) + Database (PostgreSQL, MongoDB)
- **3-Tier**: Frontend + Backend (Node.js, Python, Java) + Database

The 3-tier approach offers better scalability, security, and separation of concerns.

**DNS & Domain Mapping:**
DNS translates domain names to IP addresses. For epicreads.com → 52.172.142.222, use an **A Record**—the standard mapping for IPv4 addresses. This allows users to access services by memorable names instead of numeric IPs.

**Development Environment:**
Setting up VS Code with proper terminal integration ensures a productive DevOps workflow for scripting, infrastructure-as-code, and system administration.

#DevOps #Networking #Cloud #DMI #CohortThree

---

P.S. This post is part of the DevOps Micro Internship (DMI) with Agentic AI — Cohort 3 — by Pravin Mishra. My graded progress is public: https://dmi.pravinmishra.com/s/silas-nyarko.html · Start your DevOps journey: https://dmi.pravinmishra.com/?utm_source=student&utm_medium=ps-linkedin&utm_campaign=cohort3

---

# Reflection – Week 0

### What did you find easy?

Understanding the practical applications of networking concepts came naturally by relating them to real-world scenarios like EpicReads. The foundational concepts like DNS, IP addressing, and protocols have clear analogies that made them accessible and memorable.

---

### What was difficult?

Visualizing the three-tier architecture and explaining which DNS record type to use required deeper research. The distinction between different DNS record types (A, CNAME, MX, etc.) and understanding when to apply each was initially confusing until I focused on the specific use case.

---

### What will you improve next week?

Next week, I'll focus on hands-on networking diagnostics using tools like ping, traceroute, and nslookup to deepen my understanding of how these concepts actually work in practice. I'll also spend more time on practical AWS networking setup to apply these foundational concepts in cloud environments.

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.


## 📌 Resources

- 🌐 **DMI Official Website:** https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 **University:** https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 **Discord Community:** https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 **Blog:** https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ **YouTube Playlist (DMI Cohort 3):** https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 **Pravin Mishra (LinkedIn):** https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 **CloudAdvisory (LinkedIn):** https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track*