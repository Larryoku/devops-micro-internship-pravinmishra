#!/bin/bash

################################################################################
# Azure Security Posture Audit — READ-ONLY SCRIPT
# Author: Silas Nyarko
# Date: $(date +%Y-%m-%d)
# Purpose: Four-check audit for NSGs, Storage, VMs, and MySQL security posture
# Safety: No mutating commands — read-only Azure CLI queries only
################################################################################

set -o pipefail

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tracking variables
OVERALL_STATUS="PASS"
OVERALL_EXIT_CODE=0

# Helper function to log status
log_status() {
    local check_name=$1
    local status=$2
    local message=$3

    case $status in
        PASS)
            echo -e "${GREEN}[PASS]${NC} $check_name: $message"
            ;;
        WARN)
            echo -e "${YELLOW}[WARN]${NC} $check_name: $message"
            if [ "$OVERALL_STATUS" != "FAIL" ]; then
                OVERALL_STATUS="WARN"
                OVERALL_EXIT_CODE=1
            fi
            ;;
        FAIL)
            echo -e "${RED}[FAIL]${NC} $check_name: $message"
            OVERALL_STATUS="FAIL"
            OVERALL_EXIT_CODE=2
            ;;
    esac
}

# Header
echo "================================================================================"
echo -e "${BLUE}AZURE SECURITY POSTURE AUDIT REPORT${NC}"
echo "================================================================================"
echo "Auditor: Silas Nyarko"
echo "Execution Date: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Scope: NSGs, Storage Accounts, VMs, Azure Database for MySQL"
echo "Mode: READ-ONLY (no modifications)"
echo "================================================================================"
echo ""

# Verify Azure CLI is available
if ! command -v az &> /dev/null; then
    echo -e "${RED}ERROR: Azure CLI (az) not found. Please install it first.${NC}"
    exit 2
fi

# Get subscription context
CURRENT_SUB=$(az account show --query "id" -o tsv 2>/dev/null)
if [ -z "$CURRENT_SUB" ]; then
    echo -e "${RED}ERROR: Not logged into Azure. Run 'az login' first.${NC}"
    exit 2
fi
echo "Current Subscription: $CURRENT_SUB"
echo ""

################################################################################
# CHECK 1: Network Security Groups — Port 22/3389 from 0.0.0.0/0
################################################################################
echo "────────────────────────────────────────────────────────────────────────────────"
echo "CHECK 1: Network Security Groups (NSGs) — SSH/RDP Exposure"
echo "────────────────────────────────────────────────────────────────────────────────"

RISKY_NSG_COUNT=0
NSG_FINDINGS=()

# Query all NSGs
NSGS=$(az network nsg list --query "[].{name: name, resourceGroup: resourceGroup}" -o json 2>/dev/null)

if [ -z "$NSGS" ] || [ "$NSGS" == "[]" ]; then
    log_status "NSGs" "PASS" "No NSGs found in subscription"
else
    while IFS= read -r nsg_entry; do
        NSG_NAME=$(echo "$nsg_entry" | jq -r '.name')
        RG_NAME=$(echo "$nsg_entry" | jq -r '.resourceGroup')

        # Query inbound rules allowing port 22 or 3389 from 0.0.0.0/0
        RISKY_RULES=$(az network nsg rule list \
            --resource-group "$RG_NAME" \
            --nsg-name "$NSG_NAME" \
            --query "[?access=='Allow' && direction=='Inbound' && \
                     (destinationPortRange=='22' || destinationPortRange=='3389' || \
                      destinationPortRange=='*') && \
                     (sourceAddressPrefix=='*' || sourceAddressPrefix=='0.0.0.0/0' || \
                      sourceAddressPrefixes[0]=='*' || sourceAddressPrefixes[0]=='0.0.0.0/0')]" \
            -o json 2>/dev/null)

        RISKY_COUNT=$(echo "$RISKY_RULES" | jq 'length' 2>/dev/null || echo 0)

        if [ "$RISKY_COUNT" -gt 0 ]; then
            RISKY_NSG_COUNT=$((RISKY_NSG_COUNT + RISKY_COUNT))
            NSG_FINDINGS+=("$NSG_NAME ($RG_NAME): $RISKY_COUNT risky rule(s)")
        fi
    done < <(echo "$NSGS" | jq -c '.[]')
fi

if [ "$RISKY_NSG_COUNT" -eq 0 ]; then
    log_status "NSGs" "PASS" "No overly permissive SSH/RDP rules found (0.0.0.0/0)"
else
    log_status "NSGs" "FAIL" "Found $RISKY_NSG_COUNT risky rule(s) allowing 0.0.0.0/0 access to SSH/RDP"
    for finding in "${NSG_FINDINGS[@]}"; do
        echo -e "  ${RED}→${NC} $finding"
    done
fi
echo ""

################################################################################
# CHECK 2: Storage Accounts — Public Blob Access
################################################################################
echo "────────────────────────────────────────────────────────────────────────────────"
echo "CHECK 2: Storage Accounts — Public Blob Access"
echo "────────────────────────────────────────────────────────────────────────────────"

STORAGE_FINDINGS=()
STORAGE_AT_RISK=0

# Query all storage accounts
STORAGE_ACCOUNTS=$(az storage account list \
    --query "[].{name: name, resourceGroup: resourceGroup, allowBlobPublicAccess: allowBlobPublicAccess}" \
    -o json 2>/dev/null)

if [ -z "$STORAGE_ACCOUNTS" ] || [ "$STORAGE_ACCOUNTS" == "[]" ]; then
    log_status "Storage" "PASS" "No storage accounts found"
else
    while IFS= read -r storage_entry; do
        STORAGE_NAME=$(echo "$storage_entry" | jq -r '.name')
        RG_NAME=$(echo "$storage_entry" | jq -r '.resourceGroup')
        ALLOW_BLOB=$(echo "$storage_entry" | jq -r '.allowBlobPublicAccess')

        if [ "$ALLOW_BLOB" == "true" ] || [ "$ALLOW_BLOB" == "True" ]; then
            STORAGE_AT_RISK=$((STORAGE_AT_RISK + 1))
            STORAGE_FINDINGS+=("$STORAGE_NAME ($RG_NAME): allowBlobPublicAccess = $ALLOW_BLOB")
        fi
    done < <(echo "$STORAGE_ACCOUNTS" | jq -c '.[]')
fi

if [ "$STORAGE_AT_RISK" -eq 0 ]; then
    log_status "Storage" "PASS" "All storage accounts have public blob access disabled"
else
    log_status "Storage" "FAIL" "Found $STORAGE_AT_RISK storage account(s) with public blob access enabled"
    for finding in "${STORAGE_FINDINGS[@]}"; do
        echo -e "  ${RED}→${NC} $finding"
    done
fi
echo ""

################################################################################
# CHECK 3: Virtual Machines — Disk Encryption
################################################################################
echo "────────────────────────────────────────────────────────────────────────────────"
echo "CHECK 3: Virtual Machines — Disk Encryption Status"
echo "────────────────────────────────────────────────────────────────────────────────"

VM_FINDINGS=()
VM_UNENCRYPTED=0

# Query all VMs
VMS=$(az vm list --query "[].{name: name, resourceGroup: resourceGroup}" -o json 2>/dev/null)

if [ -z "$VMS" ] || [ "$VMS" == "[]" ]; then
    log_status "VMs" "PASS" "No VMs found in subscription"
else
    while IFS= read -r vm_entry; do
        VM_NAME=$(echo "$vm_entry" | jq -r '.name')
        RG_NAME=$(echo "$vm_entry" | jq -r '.resourceGroup')

        # Check encryption status
        ENCRYPTION_STATUS=$(az vm encryption show \
            --resource-group "$RG_NAME" \
            --name "$VM_NAME" \
            --query "disks[0].statuses[0].displayStatus" \
            -o tsv 2>/dev/null || echo "Unknown")

        # If encryption show fails or returns empty, check OS disk directly
        if [ "$ENCRYPTION_STATUS" == "Unknown" ] || [ -z "$ENCRYPTION_STATUS" ]; then
            OS_DISK_ENCRYPTED=$(az vm show \
                --resource-group "$RG_NAME" \
                --name "$VM_NAME" \
                --query "storageProfile.osDisk.managedDisk.id" \
                -o tsv 2>/dev/null)

            if [ -z "$OS_DISK_ENCRYPTED" ]; then
                VM_UNENCRYPTED=$((VM_UNENCRYPTED + 1))
                VM_FINDINGS+=("$VM_NAME ($RG_NAME): Encryption status unknown or not enabled")
            fi
        fi
    done < <(echo "$VMS" | jq -c '.[]')
fi

if [ "$VM_UNENCRYPTED" -eq 0 ]; then
    log_status "VMs" "PASS" "All VMs appear to have disk encryption enabled or managed disks configured"
else
    log_status "VMs" "WARN" "Found $VM_UNENCRYPTED VM(s) with unclear/missing encryption status"
    for finding in "${VM_FINDINGS[@]}"; do
        echo -e "  ${YELLOW}→${NC} $finding"
    done
fi
echo ""

################################################################################
# CHECK 4: Azure Database for MySQL — Public Network Access
################################################################################
echo "────────────────────────────────────────────────────────────────────────────────"
echo "CHECK 4: Azure Database for MySQL — Public Network Access"
echo "────────────────────────────────────────────────────────────────────────────────"

MYSQL_FINDINGS=()
MYSQL_PUBLIC=0

# Query all MySQL servers
MYSQL_SERVERS=$(az mysql server list \
    --query "[].{name: name, resourceGroup: resourceGroup, publicNetworkAccess: publicNetworkAccess}" \
    -o json 2>/dev/null)

if [ -z "$MYSQL_SERVERS" ] || [ "$MYSQL_SERVERS" == "[]" ]; then
    log_status "MySQL" "PASS" "No Azure Database for MySQL servers found"
else
    while IFS= read -r mysql_entry; do
        MYSQL_NAME=$(echo "$mysql_entry" | jq -r '.name')
        RG_NAME=$(echo "$mysql_entry" | jq -r '.resourceGroup')
        PUBLIC_ACCESS=$(echo "$mysql_entry" | jq -r '.publicNetworkAccess // "Unknown"')

        if [ "$PUBLIC_ACCESS" == "Enabled" ] || [ "$PUBLIC_ACCESS" == "enabled" ]; then
            MYSQL_PUBLIC=$((MYSQL_PUBLIC + 1))
            MYSQL_FINDINGS+=("$MYSQL_NAME ($RG_NAME): publicNetworkAccess = $PUBLIC_ACCESS")
        fi
    done < <(echo "$MYSQL_SERVERS" | jq -c '.[]')
fi

if [ "$MYSQL_PUBLIC" -eq 0 ]; then
    log_status "MySQL" "PASS" "All MySQL servers have public network access disabled or restricted"
else
    log_status "MySQL" "WARN" "Found $MYSQL_PUBLIC MySQL server(s) with public network access enabled"
    for finding in "${MYSQL_FINDINGS[@]}"; do
        echo -e "  ${YELLOW}→${NC} $finding"
    done
fi
echo ""

################################################################################
# AUDIT SUMMARY
################################################################################
echo "================================================================================"
echo -e "${BLUE}AUDIT SUMMARY${NC}"
echo "================================================================================"
echo -e "Overall Status: $([ "$OVERALL_STATUS" == "PASS" ] && echo -e "${GREEN}$OVERALL_STATUS${NC}" || [ "$OVERALL_STATUS" == "WARN" ] && echo -e "${YELLOW}$OVERALL_STATUS${NC}" || echo -e "${RED}$OVERALL_STATUS${NC}")"
echo "Exit Code: $OVERALL_EXIT_CODE"
echo "  0 = PASS (All security checks passed)"
echo "  1 = WARN (At least one warning found)"
echo "  2 = FAIL (Critical findings detected)"
echo "================================================================================"
echo ""
echo "Audit completed at $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo ""

# Exit with appropriate code
exit $OVERALL_EXIT_CODE
