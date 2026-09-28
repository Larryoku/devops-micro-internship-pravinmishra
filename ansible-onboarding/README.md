# Ansible Onboarding & Workstation Setup

This directory contains production-ready Ansible development environment configuration following team standards and best practices.

## Overview

- **Isolated Python Environment**: `.venv` with Ansible, ansible-lint, and yamllint
- **Team-Friendly Defaults**: `ansible.cfg` with SSH connection optimization and smart gathering
- **Pre-commit Hooks**: Automated YAML, Ansible, and Python linting
- **VS Code Integration**: Extensions and workspace settings configured
- **SSH Readiness**: Ed25519 key support with ssh-agent integration

## Quick Start

### Prerequisites
- Python 3.8+
- SSH keypair (preferably Ed25519)
- Git configured locally

### New Machine? Do This

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ansible-onboarding
   ```

2. **Create and activate virtual environment**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

4. **Configure SSH key**
   ```bash
   # If not already done
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
   ssh-add ~/.ssh/id_ed25519
   ```

5. **Configure Git**
   ```bash
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   git config --global init.defaultBranch main
   ```

6. **Install pre-commit hooks**
   ```bash
   pre-commit install
   pre-commit run --all-files  # Test run
   ```

7. **Set up Ansible inventory**
   - Edit `hosts` file with your target hosts
   - Format: `[groupname]` followed by hostname or IP

8. **Verify Ansible**
   ```bash
   ansible --version
   ansible-inventory --list -i hosts
   ```

9. **Test SSH connectivity**
   ```bash
   ansible all -i hosts -m ping
   ```

10. **Install VS Code extensions**
    - Ansible (redhat.ansible)
    - YAML (redhat.vscode-yaml)
    - Python (ms-python.python)

11. **Configure IDE**
    - Open VS Code in this directory
    - Install recommended extensions
    - Settings are auto-loaded from `.vscode/settings.json`

12. **Run linters before commit**
    ```bash
    pre-commit run --all-files
    ```

## Files & Configuration

| File | Purpose |
|------|---------|
| `requirements.txt` | Python dependencies (Ansible, linters, hooks) |
| `ansible.cfg` | Ansible runtime configuration with team defaults |
| `.pre-commit-config.yaml` | Git pre-commit hooks (YAML, Ansible, Python linting) |
| `.editorconfig` | Editor settings for consistent formatting |
| `.vscode/settings.json` | VS Code workspace settings |
| `hosts` | Ansible inventory of target hosts |

## Team-Friendly Decisions

1. **SSH Connection Optimization**: ControlMaster/ControlPersist reduces connection overhead on repeated SSH calls
2. **Smart Gathering**: Caches facts with 1-hour TTL to speed up playbook runs
3. **Pre-commit Hooks**: Catches linting errors before commit, preventing CI failures
4. **Pipelining Enabled**: Reduces number of SSH round-trips for task execution

## Common Pitfalls Avoided

1. **Global pip installs**: Using `.venv` ensures isolated dependencies and avoids system pollution
2. **Missing SSH agent**: Ed25519 keys with ssh-agent prevent repeated password prompts
3. **Unversioned dependencies**: `requirements.txt` freezes exact versions for reproducibility
4. **No linting pre-commit**: Pre-commit hooks catch YAML and Ansible errors early
5. **Inconsistent formatting**: `.editorconfig` ensures consistent indentation across the team

## Troubleshooting

### SSH Connection Issues
```bash
ssh-add ~/.ssh/id_ed25519
ssh-add -l  # Verify key is loaded
```

### Ansible Inventory Not Found
```bash
ansible-inventory --list -i hosts  # Verify inventory path
```

### Pre-commit Hooks Failing
```bash
pre-commit run --all-files --verbose  # Run with verbose output
```

### Python Virtual Environment Issues
```bash
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Resources

- [Ansible Documentation](https://docs.ansible.com)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Pre-commit Framework](https://pre-commit.com/)
- [EditorConfig Standard](https://editorconfig.org/)

---

**Part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track**
