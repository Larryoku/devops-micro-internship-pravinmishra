---
allowed-tools:
  - Read
  - jira:get_sprint_issues
  - jira:search_issues
  - jira:get_issue
disable-model-invocation: true
---

Analyze the active sprint in Jira and output a detailed triage report covering:
1. Sprint Velocity & Total Story Points
2. Stories at Risk of Missing the Sprint
3. Items Missing an Estimate
