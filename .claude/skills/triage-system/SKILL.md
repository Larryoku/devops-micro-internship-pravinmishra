---
name: triage-system
description: Run system health check and summarize status
---

# Triage System

Automatically runs the Linux incident triage script and provides a concise health status summary.

## Usage

```
/triage-system
```

## What it does

1. Executes `scripts/linux-triage.sh`
2. Parses the output for check results
3. Summarizes overall system health status
4. Reports specific failures or warnings

## Output

A human-readable summary showing:
- Overall system state (HEALTHY/WARN/FAIL)
- Exit code
- Each check result with status
- Any critical issues requiring attention
