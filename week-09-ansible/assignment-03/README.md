# Static Web Deployment with Ansible

This project demonstrates a multi-play Ansible playbook for deploying a static website to web servers.

## Project Structure

```
static-web/
├── README.md              # This file
├── site.yml              # Three-play main playbook
├── inventory.ini         # Host inventory with web group
└── files/
    └── index.html        # Static website content
```

## Setup

1. **Clone/Create the Project**
   ```bash
   mkdir -p static-web/files
   cd static-web
   ```

2. **Get the Static Website Content**
   Download `index.html` from `https://github.com/pravinmishraaws/Azure-Static-Website`
   ```bash
   curl -o files/index.html https://raw.githubusercontent.com/pravinmishraaws/Azure-Static-Website/main/index.html
   ```

3. **Configure Inventory**
   Update `inventory.ini` with your web server IPs and SSH key path.

4. **Run the Playbook**
   ```bash
   ansible-playbook -i inventory.ini site.yml
   ```

## Playbook Breakdown

- **Play 1**: Install and start Nginx on web servers
- **Play 2**: Copy static content and trigger reload handler
- **Play 3**: Verify deployment with HTTP 200 assertions

## Verification

After successful playbook run, access the website at:
```
http://<web1-public-ip>/
http://<web2-public-ip>/
```
