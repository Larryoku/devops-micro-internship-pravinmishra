#!/bin/bash
# triage-system skill — run health check and summarize results

TRIAGE_OUTPUT=$(bash scripts/linux-triage.sh 2>&1)
EXIT_CODE=$?

# Extract key information from output
FINAL_STATE=$(echo "$TRIAGE_OUTPUT" | grep "Final State:" | awk -F': ' '{print $NF}')
CPU_STATUS=$(echo "$TRIAGE_OUTPUT" | grep -E "^\[" | sed -n '1p')
MEM_STATUS=$(echo "$TRIAGE_OUTPUT" | grep -E "^\[" | sed -n '2p')
DISK_STATUS=$(echo "$TRIAGE_OUTPUT" | grep -E "^\[" | sed -n '3p')
NGINX_STATUS=$(echo "$TRIAGE_OUTPUT" | grep -E "^\[" | sed -n '4p')
HTTP_STATUS=$(echo "$TRIAGE_OUTPUT" | grep -E "^\[" | sed -n '5p')

# Print summary
echo "=================================================="
echo "SYSTEM HEALTH CHECK SUMMARY"
echo "=================================================="
echo ""
echo "Status: $FINAL_STATE (Exit Code: $EXIT_CODE)"
echo ""
echo "Health Checks:"
echo "  CPU         → $CPU_STATUS"
echo "  Memory      → $MEM_STATUS"
echo "  Disk Space  → $DISK_STATUS"
echo "  Nginx       → $NGINX_STATUS"
echo "  HTTP Health → $HTTP_STATUS"
echo ""

# Highlight critical issues
if [ "$FINAL_STATE" = "FAIL" ]; then
    echo "⚠️  CRITICAL ISSUES DETECTED"
    echo ""
    echo "Failed checks:"
    echo "$TRIAGE_OUTPUT" | grep "\[FAIL\]" | sed 's/^/  • /'
elif [ "$FINAL_STATE" = "WARN" ]; then
    echo "⚠️  WARNINGS PRESENT"
    echo ""
    echo "Warnings:"
    echo "$TRIAGE_OUTPUT" | grep "\[WARN\]" | sed 's/^/  • /'
else
    echo "✅ All systems operational"
fi

echo ""
echo "=================================================="

exit $EXIT_CODE
