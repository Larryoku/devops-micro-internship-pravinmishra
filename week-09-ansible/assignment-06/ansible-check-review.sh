#!/bin/bash

# Ansible Change Risk Review Script
# Reads ansible-playbook --check --diff output and categorizes changes into risk categories
# Usage: ./ansible-check-review.sh -i inventory.ini -p site.yml

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
INVENTORY=""
PLAYBOOK=""
OUTPUT_FILE="/tmp/ansible_check_output.log"

# Parse arguments
while getopts "i:p:" opt; do
  case $opt in
    i) INVENTORY="$OPTARG" ;;
    p) PLAYBOOK="$OPTARG" ;;
    *) echo "Usage: $0 -i inventory.ini -p site.yml"; exit 1 ;;
  esac
done

if [[ -z "$INVENTORY" || -z "$PLAYBOOK" ]]; then
  echo "Usage: $0 -i inventory.ini -p site.yml"
  exit 1
fi

echo -e "${BLUE}Running Ansible dry-run...${NC}"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --check --diff > "$OUTPUT_FILE" 2>&1 || true

# Function to check for service restart changes
check_service_restarts() {
  local count=0
  if grep -E "notify|handler|service.*reloaded|service.*restarted" "$OUTPUT_FILE" > /dev/null 2>&1; then
    count=$(grep -E "notify|handler|service.*reloaded|service.*restarted" "$OUTPUT_FILE" | wc -l)
  fi
  echo "$count"
}

# Function to check for firewall changes
check_firewall_changes() {
  local count=0
  if grep -E "azure_network_security_group|ufw|firewall|security_group" "$OUTPUT_FILE" > /dev/null 2>&1; then
    count=$(grep -E "azure_network_security_group|ufw|firewall|security_group" "$OUTPUT_FILE" | wc -l)
  fi
  echo "$count"
}

# Function to check for user/sudo changes
check_user_changes() {
  local count=0
  if grep -E "user.*changed|sudo|sudoers|groups.*changed" "$OUTPUT_FILE" > /dev/null 2>&1; then
    count=$(grep -E "user.*changed|sudo|sudoers|groups.*changed" "$OUTPUT_FILE" | wc -l)
  fi
  echo "$count"
}

# Function to check for package/file removal
check_removal_changes() {
  local count=0
  if grep -E "apt.*state.*absent|file.*state.*absent|remove|uninstall|delete" "$OUTPUT_FILE" > /dev/null 2>&1; then
    count=$(grep -E "apt.*state.*absent|file.*state.*absent|remove|uninstall|delete" "$OUTPUT_FILE" | wc -l)
  fi
  echo "$count"
}

# Count unreachable hosts
count_unreachable() {
  grep -E "unreachable|FAILED|failed" "$OUTPUT_FILE" | wc -l || echo "0"
}

# Count changed tasks (deduped by task name, not per-host)
count_changed_tasks() {
  grep -E "^TASK \[|changed:" "$OUTPUT_FILE" | grep -B1 "changed:" | grep "TASK" | sort -u | wc -l || echo "0"
}

echo -e "${BLUE}Analyzing changes...${NC}\n"

# Collect risk metrics
SERVICE_RESTARTS=$(check_service_restarts)
FIREWALL_CHANGES=$(check_firewall_changes)
USER_CHANGES=$(check_user_changes)
REMOVAL_CHANGES=$(check_removal_changes)
UNREACHABLE=$(count_unreachable)
TOTAL_CHANGED=$(count_changed_tasks)

# Generate report
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}ANSIBLE CHANGE RISK REVIEW REPORT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

echo -e "Playbook: ${YELLOW}$PLAYBOOK${NC}"
echo -e "Inventory: ${YELLOW}$INVENTORY${NC}"
echo -e "Report Generated: $(date '+%Y-%m-%d %H:%M:%S')\n"

echo -e "${BLUE}Risk Category Breakdown:${NC}"
echo -e "  Service Restarts/Handlers:  ${SERVICE_RESTARTS}"
echo -e "  Firewall Rule Changes:      ${FIREWALL_CHANGES}"
echo -e "  User/Sudo Changes:          ${USER_CHANGES}"
echo -e "  Package/File Removals:      ${REMOVAL_CHANGES}"
echo -e "  Unreachable Hosts:          ${UNREACHABLE}"
echo -e "  Total Changed Tasks:        ${TOTAL_CHANGED}\n"

# Determine overall risk level
OVERALL_RISK="LOW"
if [[ $UNREACHABLE -gt 0 ]]; then
  OVERALL_RISK="CRITICAL"
elif [[ $REMOVAL_CHANGES -gt 0 ]]; then
  OVERALL_RISK="HIGH"
elif [[ $FIREWALL_CHANGES -gt 0 || $USER_CHANGES -gt 0 ]]; then
  OVERALL_RISK="MEDIUM"
elif [[ $SERVICE_RESTARTS -gt 0 ]]; then
  OVERALL_RISK="MEDIUM"
fi

# Color-code risk level
if [[ "$OVERALL_RISK" == "CRITICAL" ]]; then
  RISK_COLOR="$RED"
elif [[ "$OVERALL_RISK" == "HIGH" ]]; then
  RISK_COLOR="$RED"
elif [[ "$OVERALL_RISK" == "MEDIUM" ]]; then
  RISK_COLOR="$YELLOW"
else
  RISK_COLOR="$GREEN"
fi

echo -e "${BLUE}Overall Risk Level:${NC} ${RISK_COLOR}${OVERALL_RISK}${NC}\n"

# Recommendations
echo -e "${BLUE}Recommendations:${NC}"
if [[ "$OVERALL_RISK" == "CRITICAL" ]]; then
  echo -e "  ${RED}⚠️  CRITICAL: Check unreachable hosts immediately${NC}"
  echo "  → Verify inventory connectivity with: ansible all -m ping"
  echo "  → Fix connectivity issues before applying changes"
elif [[ "$OVERALL_RISK" == "HIGH" ]]; then
  echo -e "  ${RED}⚠️  HIGH RISK: File/package removal detected${NC}"
  echo "  → Review the changes carefully in the full output below"
  echo "  → Ensure no critical application files will be deleted"
  echo "  → Consider backing up affected directories first"
elif [[ "$OVERALL_RISK" == "MEDIUM" ]]; then
  echo -e "  ${YELLOW}⚠️  MEDIUM RISK: Service restarts or structural changes detected${NC}"
  echo "  → Review the specific changes before applying"
  echo "  → Consider scheduling during a maintenance window"
  echo "  → Monitor service availability immediately after applying"
else
  echo -e "  ${GREEN}✓ LOW RISK: Changes appear safe to apply${NC}"
  echo "  → Proceed with: ansible-playbook -i $INVENTORY $PLAYBOOK"
fi

echo -e "\n${BLUE}════════════════════════════════════════════════════════${NC}\n"

# Show key changed tasks
echo -e "${BLUE}Changed Tasks (summarized):${NC}"
grep -E "^TASK \[" "$OUTPUT_FILE" | head -10 | sed 's/TASK \[/  ✓ /'

if [[ $(grep -c "^TASK \[" "$OUTPUT_FILE" || echo "0") -gt 10 ]]; then
  echo "  ... and $(($(grep -c "^TASK \[" "$OUTPUT_FILE") - 10)) more tasks"
fi

echo -e "\n${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "Full output saved to: ${YELLOW}$OUTPUT_FILE${NC}\n"

# Exit code based on risk
if [[ "$OVERALL_RISK" == "CRITICAL" ]]; then
  exit 1
else
  exit 0
fi
