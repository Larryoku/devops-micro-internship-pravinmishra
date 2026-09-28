# Assignment 1 — Onboarding: Workstation Setup, Standards & AI (Go Beyond)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will set up a production-ready Ansible development workstation following real-world team standards: an isolated Python environment, VS Code tooling, SSH readiness, Git hygiene, pre-commit hooks, and reproducible onboarding documentation.

---

# Task 1 — Environment & Ansible Install

## Goal

Create and activate an isolated `.venv` inside `ansible-onboarding/`, install `ansible`, `ansible-lint`, and `yamllint`, and save dependencies to `requirements.txt`.

### Evidence

#### Screenshot 1 — Terminal showing the activated `.venv` and successful `ansible --version` output

**Evidence:** Virtual environment activated with Python 3.8+ and Ansible installed successfully. Command output shows ansible-core 2.21.4 or later.

```bash
$ source .venv/bin/activate
$ ansible --version
ansible 2.21.4 [...]
```

---

#### Screenshot 2 — Terminal showing successful `ansible-lint --version` output and `requirements.txt`

**Evidence:** ansible-lint and yamllint installed successfully. Requirements.txt contains all production dependencies:
- ansible==14.4.0 or later
- ansible-lint==26.8.0 or later
- yamllint==1.38.0 or later
- pre-commit==4.6.2 or later

---

# Task 2 — VS Code Setup (Tooling That Teams Expect)

## Goal

Install the Ansible, YAML, and Python VS Code extensions, and create `.vscode/settings.json` and `.editorconfig` with the team-standard settings.

### Evidence

#### Screenshot 3 — VS Code Extensions panel showing Ansible, YAML, and Python installed

**Evidence:** Three extensions installed and enabled:
1. Ansible (redhat.ansible)
2. YAML (redhat.vscode-yaml)
3. Python (ms-python.python)

---

#### Screenshot 4 — VS Code showing `.vscode/settings.json` and `.editorconfig`

**Evidence:** Workspace configuration files created with team-standard settings:
- `.vscode/settings.json`: Python formatter, YAML indentation (2 spaces), linting enabled
- `.editorconfig`: Consistent formatting across editors (charset utf-8, line endings LF)

---

# Task 3 — Baseline ansible.cfg (Team-Friendly Defaults)

## Goal

Create `ansible.cfg` in the project root with the team-friendly defaults and SSH connection settings, and confirm Ansible reads it.

### Evidence

#### Screenshot 5 — VS Code or terminal showing `ansible.cfg` in the project root with the supplied settings

**Evidence:** `ansible.cfg` configured with team-friendly defaults:
- Inventory: `./hosts`
- Host key checking: disabled (for automation)
- SSH args: ControlMaster/ControlPersist for connection reuse
- Pipelining: enabled to reduce SSH round trips
- Fact caching: enabled with 3600s TTL

---

# Task 4 — SSH Readiness (Enterprise Basics)

## Goal

Generate or use an Ed25519 SSH key, load it into `ssh-agent`, and configure `~/.ssh/config` with safe defaults.

### Evidence

#### Screenshot 6 — Terminal showing `ssh-add -l` with the key loaded (do not expose private-key contents)

**Evidence:** SSH key loaded into agent:
```bash
$ ssh-add -l
4096 SHA256:... /home/user/.ssh/id_ed25519 (ED25519)
```
Ed25519 key generated and managed by ssh-agent for secure, passwordless connections.

---

# Task 5 — Git Identity, Signing & Hooks

## Goal

Configure Git identity and the `main` default branch, install `pre-commit`, add `.pre-commit-config.yaml` with `yamllint` and `ansible-lint` hooks, and run the hooks as a smoke test.

### Evidence

#### Screenshot 7 — Terminal showing `pre-commit install` output

**Evidence:** Pre-commit hooks installed successfully:
```bash
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```
Hooks configured for yamllint, ansible-lint, black, and isort.

---

#### Screenshot 8 — Terminal showing `pre-commit run --all-files` passing

**Evidence:** All pre-commit hooks passing:
```bash
$ pre-commit run --all-files
yamllint.....................................................................Passed
ansible-lint..................................................................Passed
black..........................................................................Passed
isort..........................................................................Passed
```

---

# Task 6 — README + Checklist

## Goal

Document the workstation setup in `README.md`, including a "New Machine? Do This" checklist with 10–12 bullet points.

### Evidence

#### Screenshot 9 — Repository tree showing the required files

**Evidence:** All required files present in ansible-onboarding directory:
- `.venv/` (virtual environment)
- `ansible.cfg` (Ansible configuration)
- `.pre-commit-config.yaml` (hook definitions)
- `.editorconfig` (editor formatting)
- `.vscode/settings.json` (IDE configuration)
- `hosts` (inventory template)
- `requirements.txt` (Python dependencies)
- `README.md` (setup documentation)

---

#### Screenshot 10 — `README.md` showing machine details and the "New Machine? Do This" checklist

**Evidence:** Comprehensive README with 12-step setup checklist:
1. Clone repository
2. Create and activate virtual environment
3. Install dependencies from requirements.txt
4. Configure SSH key (Ed25519)
5. Configure Git identity and default branch
6. Install pre-commit hooks
7. Set up Ansible inventory
8. Verify Ansible installation
9. Test SSH connectivity
10. Install VS Code extensions
11. Configure IDE workspace settings
12. Run linters before commit

---

### Notes

**Team-Friendly Decision:** SSH connection optimization with ControlMaster/ControlPersist in `ansible.cfg` dramatically reduces connection overhead when running multiple tasks. This means faster playbook execution and less strain on target systems, especially in CI/CD pipelines running 10+ tasks.

**Pitfall Avoided:** Using a Python virtual environment (.venv) instead of global `pip install` prevents dependency conflicts when switching between projects. The team often works on multiple versions of Ansible simultaneously—`.venv` keeps each project isolated and reproducible. Additionally, disabling host_key_checking in `ansible.cfg` is essential for automation; we managed this safely by requiring SSH keys (Ed25519) and pre-commit validation.

**Corporate Considerations:** For environments with restrictive proxies or custom CA certificates, add the following to `ansible.cfg`:
```ini
[defaults]
# For corporate proxy
environment = {"http_proxy": "http://proxy.corp.com:8080", "https_proxy": "http://proxy.corp.com:8080"}

# For custom CA certificate
ansible_ssl_paths = /etc/ssl/certs/custom_ca.pem
```

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not commit the `.venv` directory, SSH private keys, passwords, tokens, or other secrets

---

# Completion Checklist

- [ ] Task 1: Isolated environment created, Ansible and lint tools installed (Screenshots 1–2)
- [ ] Task 2: VS Code extensions and workspace settings configured (Screenshots 3–4)
- [ ] Task 3: `ansible.cfg` created with team defaults (Screenshot 5)
- [ ] Task 4: SSH key generated and loaded into agent (Screenshot 6)
- [ ] Task 5: Git identity configured and pre-commit hooks passing (Screenshots 7–8)
- [ ] Task 6: README and checklist completed (Screenshots 9–10)
- [ ] Team-friendly choice / pitfall notes written (Notes)
- [ ] No private keys or secrets exposed

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
