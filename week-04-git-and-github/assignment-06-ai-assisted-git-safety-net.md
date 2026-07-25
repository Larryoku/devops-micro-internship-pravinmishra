# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 1.png>)

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

Add your answer here.

---Working on a separate branch keeps the main branch safe, stable, and working while you build or test new features. It prevents unfinished or broken code from breaking the main project and allows for code reviews (PRs) before merging.

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of  `git status` showing the staged file on feature/ai-pr-ready

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 1.png>)

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

Add your answer here.

---Using a fake key prevents real credentials from leaking into public Git repositories, which could cause security breaches or unauthorized access. It allows you to practice configuring keys safely without risking actual cloud resources or sensitive data.

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 2.png>)

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 3.png>)

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

Add your answer here.

---Files inside .git/hooks/ are local to your computer and are automatically ignored by Git, meaning they cannot be pushed or shared across a team. Keeping hooks/pre-commit in a tracked repository folder allows the entire team to version-control the hook script and share identical pre-commit safety checks across all developer environments.

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

Add your answer here.

---What each intercepts:

hooks/pre-commit intercepts local Git actions (blocking a git commit before code is committed).

PreToolUse intercepts AI agent actions (blocking a Claude/Agentic AI tool execution before a command or API call runs).

What they have in common:

Both act as pre-execution safety gates designed to prevent secret leaks, enforce validation rules, and catch dangerous errors before changes become permanent or external actions are triggered.

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 4.png>)

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**

Add your answer here.

---The line: The line containing epicreads-key.pem (or the regex pattern matching AWS/RSA private key patterns and high-entropy secret strings, such as grep -E 'AKIA|BEGIN.*PRIVATE KEY|secret|api_key').

Why it matched: The pre-commit script scans staged files for common secret patterns and keywords using regular expressions. Because the fake key matched the structural format or filename convention of a real credential, the regex pattern flagged it to prevent accidental commits.

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

Add your answer here.

---Could it catch it? No. If a variable uses a generic name (like temp_token = "xyz123") and lacks known prefixes like AKIA or standard regex patterns, the rule-based check will completely miss it.

What it tells you about limits: Fixed rules relying on static regex or string matching suffer from high false-negative rates—they only catch known patterns and expected formats. They fail to detect novel, obfuscated, or generically named secrets, highlighting the need for entropy-based scanning or context-aware AI tools alongside static rules.

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 5.png>)

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

Add your screenshot here.

---![alt text](<screenshots/Ass 05 Screenshot 6.png>)

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

Add your answer here.

---Why it has Bash and Read: /pr-ready needs Read to inspect file content and Bash to run read-only validation commands (like git status, git diff, tests, or linter checks) to verify that the workspace is clean and ready for submission.

Why it lacks Write: A PR readiness check is designed to audit and validate code, not modify it. Omitting Write permissions prevents the command from accidentally modifying files, destroying untracked work, or altering the repository state right before a submission.

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

Add your answer here.

---No, they evaluated the diff for different purposes and caught different types of issues.

What pre-commit caught that /pr-ready didn't: The pre-commit hook caught security policy violations—specifically, hardcoded fake keys and credentials, blocking the commit at the local repository level.

What /pr-ready caught that pre-commit didn't: /pr-ready caught submission and workflow completeness issues—such as uncommitted changes, missing evidence/screenshots, incomplete template responses, or un-pushed branches that prevent a Pull Request from being review-ready.

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 7.png>)

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 8.png>)

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

Add your answer here.

---Removed the Secret File: Deleted the file containing the fake private key (epicreads-key.pem) from the workspace.

Unstaged Sensitive Content: Removed any references or staged changes involving hardcoded keys from Git tracking using git rm or git restore --staged.

Verified Clean Diff: Re-ran git status and the pre-commit script to ensure no blocked patterns or high-entropy credentials remained before making a clean commit.

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

**Important:** Open this Pull Request with base repository set to **your own fork** — not the shared upstream `pravinmishraaws/devops-micro-internship-pravinmishra` repository. This assignment's hook and skill files are your own practice work, not a change meant for the shared class repo.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison (paste it in the PR conversation or your notes below)

Add your screenshot here.

---![alt text](<screenshots/Ass 06 Screenshot 9.png>)

#### PR Link

Add your PR URL here...

---https://github.com/pravinmishraaws/devops-micro-internship-pravinmishra/pull/120

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

Add your answer here.

---What was edited: Verified that placeholder text (like screenshot image links, local file paths, and exact task checkboxes) was replaced with real repository evidence, and adjusted any inaccurate technical details generated by the AI model.

Why: AI-generated descriptions often contain hallucinations, generic placeholders, or inaccurate assumptions about local changes. Reviewing and editing the draft ensures the Pull Request accurately reflects the actual work completed and meets all submission guidelines before peer review.

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

Add your answer here.

---Unfilled Placeholders: You might submit unedited template brackets (like [Insert Screenshot Here] or [YOUR_NAME]), making the submission look incomplete or unprofessional.

AI Hallucinations: The draft could include incorrect claims, non-existent features, or wrong command steps that don't match what you actually built or tested.

Leaked Data & Security Risks: It could unintentionally expose sensitive file paths, internal environment notes, or raw output data that shouldn't be made public.

Failed Reviews: Reviewers or automated grading scripts could reject the Pull Request for missing mandatory assignment requirements or containing misleading information.

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

Add your answer here.

---Access Rights: You do not have write or push access to the main upstream repository, so direct branch creation or PRs against it would be rejected.

Repository Isolation: Targeting your own fork keeps your assignment submission, experimental branches, and personal edits contained in your own GitHub account without cluttering or breaking the shared class repository.

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

Add your answer here.

---The Steps: Steps that involve inspecting the workspace and reading repository state—specifically running commands like git status, git diff, git log, scanning files for secrets, or reading modified file contents.

Why: In the OODA loop / Agentic workflow framework, the Gather phase is all about collecting context, reading existing code, and discovering current repository conditions before analyzing or taking action.

**2. Which step(s) represent Analyze?**

Add your answer here.

---The Steps: Running pre-commit validation hooks, checking regex rule matches against staged diffs, and running /pr-ready audits.

Why: In the agentic loop framework, Analyze is where raw context and gathered data are evaluated against rules, policies, and requirements to identify security risks, missing items, or errors before deciding how to act.

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

Add your answer here.

---The Step: Executing final deployment commands—specifically running git commit, git push, and creating/submitting the Pull Request.

Why a human must do it:

Accountability & Ownership: A human owner must take responsibility for code changes entering a shared repository.

Credential & Authorization Boundaries: Automated AI assistants lack personal authentication tokens, SSH keys, or permissions to sign commits under your identity.

Final Gatekeeping: Human review ensures that no unauthorized changes, unvetted secrets, or AI hallucinations bypass final safety checks before publication.

**4. Which step is Verify?**

Add your answer here.

---The Steps: Running /pr-ready, inspecting git status after resolution, checking the PR diff on GitHub, and confirming that the automated status/CI checks pass on the open Pull Request.

Why: The Verify step confirms that the actions taken during the Act phase actually solved the problem, satisfied all security policies, and left the workspace in a valid, submission-ready state.

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

Add your answer here.

---Neither tool is sufficient on its own because fixed-rule pre-commit hooks provide deterministic, instant safety checks for known patterns like private keys, while AI skills provide context-aware auditing for high-level PR readiness, missing documentation, and subtle logic errors that static regex rules miss. Using both creates a defense-in-depth strategy that combines rigid security guardrails with smart, holistic code validation.

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

Add your LinkedIn post URL here...

---https://www.linkedin.com/posts/silas-nyarko_dmi-devops-micro-internship-with-agentic-share-7486877737366929409-7sqN/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC77mYABXwQj5VAsAS-zzzdbpmvsIZLeP7U

## Key Learnings

Add 3-5 bullet points on what you learned this week.

-Shifting Security Left: Implementing local pre-commit hooks provides an immediate, automated line of defense that stops secrets (like private keys) from being accidentally committed to version control.

Limits of Pattern Matching: Rule-based regex checks are essential for fast, deterministic detection of known patterns (like AWS key prefixes), but they miss generic variable names, obfuscated strings, and high-entropy secrets.

Combining AI Skills & Fixed Rules: Using fixed hooks for rigid security rules alongside AI skills (/pr-ready) creates a defense-in-depth strategy that evaluates both security compliance and holistic PR quality.

Human-in-the-Loop Governance: While AI agents can perform the Gather and Analyze phases of the OODA loop, critical execution steps (Act) like git push and opening PRs require human oversight, credential control, and accountability.
-
-

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission — the fake key in Task 1 is intentional and must stay clearly fake
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

Paste your forked repository URL here:

`Add your URL here`

---https://github.com/Larryoku/devops-micro-internship-pravinmishra.git


# Completion Checklist

- [X] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [X] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [X] `core.hooksPath` configured to point at `hooks/`
- [X] Pre-commit hook shown blocking the risky commit
- [X] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [X] `/pr-ready` run against the risky diff and shown flagging issues
- [X] Risky file fixed; `git commit` succeeds cleanly
- [X] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [X] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [X] Agentic Loop mapping (Task 7) completed in your own words
- [X] LinkedIn post published and URL submitted
- [X] All required screenshots added
- [X] GitHub repository URL provided

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
