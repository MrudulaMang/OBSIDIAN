There are several ways to restrict write access, depending on what you're trying to protect.

RULES VS RULESETS
- For a new repository, use **Rulesets**.
- If you're maintaining an older repository, you may still see **Branch Protection Rules** because many existing repositories use them.

### 1. Repository permissions (most common)

Only users with **Write**, **Maintain**, or **Admin** permission can push.

- **Read** → Can clone and view only.
- **Triage** → Manage issues/PRs, cannot push.
- **Write** → Can push to branches (unless branch rules prevent it).
- **Maintain** → Write + repository maintenance.
- **Admin** → Full control.

If someone should not be able to push, remove their **Write** permission.

---

### 2. Branch protection rules (recommended)

Even users with **Write** access can be prevented from pushing directly to important branches like `main`.

Typical settings:

- ✅ Require Pull Requests before merging.
- ✅ Require at least 1 or 2 approvals.
- ✅ Require status checks (CI/CD) to pass.
- ✅ Require branches to be up to date.
- ✅ Restrict who can push.
- ✅ Restrict who can merge.
- ✅ Prevent force pushes.
- ✅ Prevent branch deletion.

This is the most common approach in professional teams.

Example:

```
main├── Direct Push ❌├── Force Push ❌├── Delete ❌└── Merge only through Pull Request ✅
```

Developers work like this:

```
main  │  ├── feature/login  ├── feature/payment  └── feature/search        ↓     Pull Request        ↓    Code Review        ↓      Merge
```

---

### 3. CODEOWNERS

You can require approval from specific people before changes to certain files can be merged.

Example:

```
/terraform/   @devops-team/kubernetes/  @platform-team
```

A PR touching those directories cannot be merged until the designated owners approve it.

---

### 4. Rulesets (newer GitHub feature)

GitHub Rulesets provide centralized policies across branches or repositories.

Examples:

- No direct pushes.
- Signed commits only.
- Linear history.
- Restrict branch creation/deletion.
- Require PR reviews.

Organizations often prefer Rulesets over individual branch protection rules.

---

### 5. Organization/team permissions

In an organization repository, assign permissions by team:

|Team|Permission|
|---|---|
|Developers|Write|
|QA|Read|
|DevOps|Maintain|
|Leads|Admin|

This avoids managing permissions user by user.

---

### Typical enterprise setup

A common configuration is:

- Developers have **Write** access.
- `main` and `release` branches are protected.
- Direct pushes to those branches are disabled.
- Changes must come through Pull Requests.
- At least one or two approvals are required.
- CI/CD checks must pass before merging.
- Force pushes and branch deletion are disabled.

This allows developers to contribute while ensuring all changes are reviewed and validated before reaching protected branches.

----

## These settings are configured in the repository settings. You need to be the **repository owner** or have **Admin** access.

### Branch Protection Rules

1. Open the repository.
2. Click **Settings**.
3. In the left sidebar, click **Rules** → **Rulesets** (or **Branches** → **Branch protection rules** in older repositories).
4. Create a new ruleset or branch protection rule.
5. Select the branch (e.g., `main`).
6. Enable options such as:
    - ✅ Require a pull request before merging
    - ✅ Require approvals
    - ✅ Require status checks
    - ✅ Block force pushes
    - ✅ Block branch deletion
    - ✅ Restrict who can push

---

### Repository Permissions

For a personal repository:

1. Go to **Settings**.
2. Click **Collaborators**.
3. Add/remove collaborators or change their access level.

For an organization repository:

1. Go to **Settings**.
2. Click **Collaborators and teams** (or manage from the organization).
3. Assign permissions such as:
    - Read
    - Triage
    - Write
    - Maintain
    - Admin

---

### CODEOWNERS

Create a file named:

```
.github/CODEOWNERS
```

Example:

```
# Everything requires Alice's review* @alice# Terraform changes require DevOps team/terraform/ @devops-team# Kubernetes manifests require Platform team/kubernetes/ @platform-team
```

Then, in your branch protection/ruleset, enable **Require review from Code Owners**.

---

### Rulesets (recommended)

Go to:

**Repository → Settings → Rules → Rulesets → New ruleset**

Here you can configure policies such as:

- Restrict pushes
- Require pull requests
- Require approvals
- Require signed commits
- Block force pushes
- Restrict branch deletion

---

If you're preparing for **DevOps interviews**, focus primarily on **Branch Protection Rules** and **Rulesets**. These are the features most commonly used in enterprise GitHub workflows.
