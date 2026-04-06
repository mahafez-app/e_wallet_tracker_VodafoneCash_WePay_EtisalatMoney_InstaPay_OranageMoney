---
name: pr-open
description: Create a new branch, commit the prepared changes, push the branch, and open a pull request with a conventional commit message and description. Use after running `pr-prep`.
---

---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

This command assumes the working directory is **clean and verified**
using `pr-prep`.

---

# Instructions

## Step 1 — Verify repository state

- Run `git status`.
- Confirm there are modified files.
- If the working tree is clean, abort.

---

## Step 2 — Create a new branch

Create a branch using this format:

```
type/scope-short-description
```

Examples:

```
refactor/home-screen-cleanup
fix/download-progress-crash
feat/history-pagination
chore/update-architecture-rules
```

Run:

```
git checkout -b <branch-name>
```

---

## Step 3 — Stage changes

Stage all modified files:

```
git add .
```

Verify:

```
git status
```

---

## Step 4 — Commit changes

Create a **Conventional Commit** message.

Format:

```
type(scope): short imperative description

- bullet detail 1
- bullet detail 2
- bullet detail 3
```

Types allowed:

```
feat
fix
refactor
test
chore
```

Run:

```
git commit -m "<commit-message>"
```

---

## Step 5 — Push branch

Push the new branch:

```
git push -u origin <branch-name>
```

---

## Step 6 — Open Pull Request

Open a PR using the following format.

### Title

Use the **same as the commit message header**:

```
type(scope): short description
```

### Description

Structure:

```
## Summary
Short explanation of the change.

## Changes
- bullet list of important changes

## Verification
- flutter analyze passed
- flutter test passed
- manual verification steps if applicable
```

If GitHub CLI is available:

```
gh pr create --fill
```

Otherwise provide the PR link to open manually.

---

## Step 7 — Final report

Report:

- Branch name
- Commit message
- Files changed
- PR link
