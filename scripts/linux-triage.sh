#!/bin/bash
# ==========================================
# Script: linux-triage.sh
# Engineer: Silas Nyarko
# Purpose: AI-Assisted Linux Incident Triage
# ==========================================

# ------------------------------------------
# SCREENSHOT 5 ZONE: Variables & Array
# ------------------------------------------
CPU_WARN=70
CPU_FAIL=90
MEM_FAIL=10  
DISK_FAIL=90 

FINAL_STATUS="HEALTHY"
EXIT_CODE=0

# The Checks Array
checks=(
    "check_cpu"
    "check_memory"
    "check_disk"
    "check_nginx"
    "check_http"
)

# ------------------------------------------
# SCREENSHOT 6 ZONE: Check Functions
# ------------------------------------------
check_cpu() {
    echo "--- [1/5] Checking CPU Utilization ---"
    local idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
    local cpu_use=$((100 - idle))
    
    echo "Current CPU Usage: ${cpu_use}%"
    if [ "$cpu_use" -ge "$CPU_FAIL" ]; then
        echo "[FAIL] CPU usage is critically high!"
        FINAL_STATUS="FAIL"
    elif [ "$cpu_use" -ge "$CPU_WARN" ]; then
        echo "[WARN] CPU usage is elevated."
        [ "$FINAL_STATUS" != "FAIL" ] && FINAL_STATUS="WARN"
    else
        echo "[OK] CPU levels are optimal."
    fi
    echo ""
}

check_memory() {
    echo "--- [2/5] Checking Memory Availability ---"
    local free_mem=$(free | grep Mem | awk '{print int($4/$2 * 100)}')
    echo "Free Memory: ${free_mem}%"
    if [ "$free_mem" -le "$MEM_FAIL" ]; then
        echo "[FAIL] Memory is critically low!"
        FINAL_STATUS="FAIL"
    else
        echo "[OK] Memory levels are healthy."
    fi
    echo ""
}

check_disk() {
    echo "--- [3/5] Checking Disk Space ---"
    local disk_use=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    echo "Root Disk Usage: ${disk_use}%"
    if [ "$disk_use" -ge "$DISK_FAIL" ]; then
        echo "[FAIL] Disk space is running out!"
        FINAL_STATUS="FAIL"
    else
        echo "[OK] Disk space is healthy."
    fi
    echo ""
}

check_nginx() {
    echo "--- [4/5] Checking Nginx Service ---"
    local nginx_status=$(systemctl is-active nginx 2>&1)
    local port_80=$(ss -ltn | grep -c ':80')

    if [ "$nginx_status" = "active" ] && [ "$port_80" -gt 0 ]; then
        echo "[OK] Nginx is running and listening on Port 80."
    else
        echo "[FAIL] Nginx service is down or Port 80 is not listening!"
        FINAL_STATUS="FAIL"
    fi
    echo ""
}

check_http() {
    echo "--- [5/5] Checking Local HTTP Response ---"
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost || echo "000")
    echo "HTTP Local Response Code: $http_code"
    if [ "$http_code" = "200" ]; then
        echo "[OK] Web application responding successfully."
    else
        echo "[FAIL] Failed to get a healthy 200 OK response!"
        FINAL_STATUS="FAIL"
    fi
    echo ""
}

# ------------------------------------------
# SCREENSHOT 7 ZONE: Driver Loop & Exit
# ------------------------------------------
echo "=========================================="
echo "Starting System Triage Report for Silas Nyarko"
echo "=========================================="
echo ""

for current_check in "${checks[@]}"; do
    $current_check
done

if [ "$FINAL_STATUS" = "FAIL" ]; then
    EXIT_CODE=2
elif [ "$FINAL_STATUS" = "WARN" ]; then
    EXIT_CODE=1
else
    EXIT_CODE=0
fi

echo "=========================================="
echo "Triage Complete. Final State: $FINAL_STATUS"
echo "=========================================="

exit $EXIT_CODE