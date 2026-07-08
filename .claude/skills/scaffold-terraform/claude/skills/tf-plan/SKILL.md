---
name: tf-plan
description: Safely runs and analyzes a Terraform plan output.
allowed-tools: [Bash, Read, Grep]
disable-model-invocation: true
---

# Terraform Plan Analyzer
When `/tf-plan` is executed:
1. Execute `terraform plan -out=tfplan` via Bash.
2. Read or grep the output summary to check for additions, changes, or destructions.
3. Output the exact plan summary to the user. Do not attempt to modify files.