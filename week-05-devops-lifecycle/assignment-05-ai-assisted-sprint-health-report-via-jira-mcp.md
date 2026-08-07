# Assignment 5 — AI-Assisted Sprint Health Report via Jira MCP

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will connect Claude Code to your Jira board through an MCP server, the same way you connected it to GitHub in Week 2, and build a read-only `/sprint-health` skill. The skill reads your current sprint through Jira's API and reports sprint velocity, stories at risk of missing the sprint, and items missing an estimate — but it must never create, edit, comment on, or transition a single ticket itself. You will prove that boundary holds by making a real change on the board yourself and confirming the skill only ever reports, never acts.

---

# Task 1 — Create a Jira API Token

## Goal

Generate an API token from your Atlassian account that the MCP server will use to authenticate with your Jira site. Do not screenshot the token value itself.

### Evidence

#### Screenshot 1 — Jira API token creation confirmation page showing the token name, with the token value not visible

![alt text](<screenshots/Ass 05  05 Screenshot 1.png>)

### Notes You Must Write (Very Important):

Why does the MCP server need your site URL and account email in addition to the token?

The MCP server requires all three parameters because Atlassian Cloud uses HTTP Basic Authentication (email:token) to route, identify, and authorize API requests:

Site URL (JIRA_URL): Directs the MCP server to your specific Atlassian tenant instance (e.g., [https://yourdomain.atlassian.net](https://yourdomain.atlassian.net)), as Atlassian Cloud hosts millions of isolated customer sites.

Account Email (JIRA_USERNAME): Supplies the explicit user identity required by HTTP Basic Auth. The API protocol requires a user account to pair with the credential for Base64 request encoding.

API Token (JIRA_API_TOKEN): Serves as the secret password replacement that authenticates the user identity and authorizes scoped access to your Jira project resources without exposing primary account login credentials.

# Task 2 — Create .mcp.json at the Project Root

## Goal

Create or update `.mcp.json` at your project root with a Jira MCP server block, following the same shape as the GitHub MCP server you configured in Week 2.

### Evidence

#### Screenshot 2 — `.mcp.json` open in VS Code showing the Jira server configuration

![alt text](<screenshots/Ass 05 05 Screenshot 2.png>)

### Notes You Must Write (Very Important):

Compare this jira block to the github block from Week 2 Assignment 5. The GitHub server ran via npx (a Node.js package); this one runs via uvx (a Python package) — what stays exactly the same shape despite that difference, and why doesn't Claude Code care which language a given MCP server is written in?

What Stays the Same Shape:

JSON Schema & Keys: The configuration block inside .mcp.json retains the exact same JSON structure under mcpServers. Both configurations rely on three fundamental key-value fields:

"command": The binary executable launcher (npx vs. uvx).

"args": An array of string parameters passed to launch the specific server package.

"env": An object containing environment variables, API tokens, and tenant URL parameters.

Why Claude Code Doesn't Care Which Language the Server Uses:

Protocol Abstraction (JSON-RPC): Claude Code interacts with all MCP servers using the Model Context Protocol via standard input/output (stdio) streams running JSON-RPC messages.

Process Decoupling: Claude Code simply spawns a background sub-process using the provided "command" and "args". Because communication happens strictly through standardized JSON messages sent over stdin and stdout, Claude Code never interacts directly with the source code or runtime environment—making the client completely language-agnostic regardless of whether the server is written in Python, Node.js, Go, or Rust.

# Task 3 — Add Your Credentials to settings.local.json

## Goal

Add your Jira site URL, account email, and API token to `.claude/settings.local.json`, and confirm that file is listed in `.gitignore` so it is never committed.

### Evidence

#### Screenshot 3 — `settings.local.json` open in VS Code showing the `env` section, with the actual token value blurred or covered

![alt text](<screenshots/Ass 05 05 Screenshot 3.png>)

### Notes You Must Write (Very Important):

Why must JIRA_API_TOKEN live in settings.local.json and never in .mcp.json?

JIRA_API_TOKEN must live in settings.local.json and never in .mcp.json for essential security hygiene and secret management reasons:

Version Control Protection (.gitignore): settings.local.json is designed for machine-specific local overrides and is excluded from Git via .gitignore. Storing the token here ensures sensitive credentials are never accidentally committed or pushed to remote repositories.

Shared Architecture (.mcp.json): .mcp.json is a shared project-level configuration file intended to be checked into version control so team members share standard MCP server setups. Hardcoding secrets in .mcp.json exposes your private credentials to anyone with access to the repository.

Credential Isolation & Safety: Keeping secrets isolated in local settings allows individual developers to manage and rotate their own access tokens independently without modifying shared project code or risking public credential leaks.

# Task 4 — Verify the Connection with /mcp

## Goal

Restart Claude Code and confirm the Jira MCP server shows as connected.

### Evidence

#### Screenshot 4 — `/mcp` output showing `jira: connected`

![alt text](<screenshots/Ass 05 05 Screenshot 4.png>)

# Task 5 — Run a Live Query to Prove Real Board Data

## Goal

Ask Claude to list the issues in your current active sprint through the Jira MCP connection, and confirm the result matches what you see on your live board in the browser.

### Evidence

#### Screenshot 5 — Claude's response showing the live sprint issue list retrieved via Jira MCP

![alt text](<screenshots/Ass 05 05 Screenshot 5.png>)

### Notes You Must Write (Very Important):

How did you confirm this was real board data and not something Claude guessed?

Exact Board Match: The issue keys (e.g., SCRUM-19, SCRUM-1, GJSN-2), status categories (To Do, In Progress), and project prefixes rendered in the report match your live Jira project workspace exactly.

Dynamic Update Verification: When you manually changed issue statuses and parameters directly on your Jira board, re-running /sprint-health dynamically pulled and reflected those exact state changes in the new terminal output.

MCP Real-Time Execution: Claude Code actively invoked the Jira Model Context Protocol (jira - search_issues) tool during execution. The process logged real-time network requests and spent active compute time fetching live JSON payloads directly from your Atlassian API endpoint.

# Task 6 — Build the /sprint-health Skill

## Goal

Create a `/sprint-health` skill restricted to read-only Jira tools plus `Read`, with no issue-mutating tools and no `Write`. Run it and confirm it produces a report covering sprint velocity, at-risk stories, and items missing an estimate.

### Evidence

#### Screenshot 6 — `SKILL.md` frontmatter showing `allowed-tools` limited to read-only Jira tools plus `Read`, with `disable-model-invocation: true`

![alt text](<screenshots/Ass 05 05  Screenshot 6.png>)

#### Screenshot 7 — `/sprint-health` output showing the full triage report against your real sprint

![alt text](<screenshots/Ass 05 05 Screenshot 7.png>)

### Notes You Must Write (Very Important):

1. Which Jira MCP tools does this skill's allowed-tools list include, and which mutating tools (create issue, update issue, transition issue, add comment) does it deliberately exclude?

Allowed-Tools List Included

jira_search_issues / jira_search (Search issues using JQL)

jira_get_issue (Get issue details by key or ID)

jira_get_agile_boards (List agile boards)

jira_get_sprints_from_board (Get sprints for a board)

jira_get_sprint_issues (Get all issues belonging to a specific sprint)

jira_get_project_issues (Get project-level issue lists)

Mutating Tools Deliberately Excluded

jira_create_issue (Create new Jira issues)

jira_update_issue (Edit fields, descriptions, or story points on existing issues)

jira_transition_issue (Change issue status/workflow states, e.g., moving from To Do to In Progress)

jira_add_comment (Post new comments or updates to issues)

Why Excluded?

The /sprint-health skill is designed strictly as a read-only diagnostic and auditing tool. By scoping the allowed-tools list to read-only capabilities, it guarantees that analyzing sprint health will never accidentally alter issue states, modify sprint scope, or overwrite project data during triage.

2. Why does a Scrum Master need this restriction more than almost any other role in this course?

A Scrum Master needs read-only restrictions more than almost any other role in this course due to the core principles of the Agile methodology and the boundaries of servant leadership:

Role Neutrality & Team Ownership: A Scrum Master is a facilitator, coach, and process steward—not a hands-on manager. Allowing an automated AI tool under a Scrum Master's command to mutate issues (moving statuses, assigning work, or editing story points) undermines team self-organization and violates the fundamental principle that team members own their sprint backlog.

Psychological Safety & Trust: If an automated tool or Scrum Master changes issue statuses or estimates without team consent, it damages trust. Sprint updates must reflect reality as reported by the developers doing the work, not arbitrary automated overrides during a triage check.

Audit Trail & Governance Integrity: Automated read-only checks allow a Scrum Master to identify bottlenecks, unestimated work, or stale tasks objectively. Keeping mutating tools strictly excluded ensures that remediations (e.g., adding estimates or transitioning blocked tasks) happen through direct team communication and intentional actions rather than unintended AI side effects.

---

# Task 7 — Prove the Skill Never Mutates the Board

## Goal

Manually update one ticket on your board in the browser (for example, move a story to "Done" or add a missing estimate), then run `/sprint-health` again and confirm the new report reflects your change — proving the skill only ever reads live state and never wrote to the board itself.

### Evidence

#### Screenshot 8 — Second `/sprint-health` run showing the report now reflects your manual board change

![alt text](<screenshots/Ass 05 05  Screenshot 8.png>)

### Notes You Must Write (Very Important):

Map this assignment to Gather → Analyze → Human Act → Verify from Week 3 Assignment 6. Which step did you perform manually in the browser, and why must that step stay human?

Gather: Executing /sprint-health allows Claude Code to fetch live board issues, active sprint data, and status fields automatically from Jira using the Jira MCP server (jira_search_issues, jira_get_sprint_issues).

Analyze: Claude Code processes the retrieved payload against sprint health rules to evaluate capacity, flag unestimated work, detect blocked items, and synthesize actionable triage recommendations.

Human Act: The user manually navigates to the Atlassian Jira web browser to transition an issue's status (e.g., moving SCRUM-5 or SCRUM-19 from To Do to In Progress) or update story point estimates.

Verify: Re-running /sprint-health in Claude Code queries the API a second time to confirm that the manual change made in Jira is accurately reflected in the fresh terminal report output.

Manual Step & Why It Must Stay Human

The Manual Step: Updating the issue state or estimate directly inside the Jira browser interface (Human Act).

Why It Must Stay Human:

Team Autonomy & Accountability: Transitioning work or setting estimates represents a commitment made by the development team. Allowing AI or an automated tool to alter issue statuses directly strips team members of ownership over their sprint backlog.

Ground-Truth Integrity: AI can analyze data patterns, but only human engineers know the real-world status, technical complexity, or actual blockers of a task. Keeping the action manual prevents hallucinated, unauthorized, or inaccurate state changes on live project boards.

Process Safety: Scoping AI to read-only diagnostic roles enforces an ethical boundary—ensuring automated tools highlight problems without silently executing destructive or unwanted mutations.

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 8 required screenshots
- All the required notes

---

# Completion Checklist

- [X] Task 1: Jira API token created, value never screenshotted (Screenshot 1)
- [X] Task 2: `.mcp.json` has the Jira server block (Screenshot 2)
- [X] Task 3: Credentials stored in `settings.local.json`, token blurred, file gitignored (Screenshot 3)
- [X] Task 4: `/mcp` shows the Jira server connected (Screenshot 4)
- [X] Task 5: Live query returned real sprint data, verified against the browser (Screenshot 5)
- [X] Task 6: `/sprint-health` skill created with correct read-only `allowed-tools`, and produced a full report (Screenshots 6–7)
- [X] Task 7: A manual board change was reflected in a second `/sprint-health` run (Screenshot 8)
- [X] Skill never created, edited, transitioned, or commented on any issue
- [X] Reflection answered (Notes)
- [X] No API token value exposed

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
