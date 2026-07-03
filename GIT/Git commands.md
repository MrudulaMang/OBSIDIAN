# 📘 Git Commands — What You Learned

---

## 🧠 1. Initialize Repository

git init
```

👉 Creates a new `.git` folder (starts tracking)

---

## 🧹 2. Remove Existing Git History (reset repo)

```bash
rm -rf .git
```

👉 Deletes old repo history  
👉 Used when copying from another repo

---

## 🔗 3. Add Remote Repository

```bash
git remote add origin <repo-url>
```

👉 Connects local repo to GitHub (or other)

---

## 🔍 4. Check Remote

```bash
git remote -v
```

👉 Shows linked repo URLs

---

## 🌿 5. Set Branch Name

```bash
git branch -M main
```

👉 Renames current branch to `main`

git branch -a 
lists **all branches** known to your local Git repository.

- `git branch` → Shows only **local branches**.
- `git branch -r` → Shows only **remote-tracking branches**.
- `git branch -a` → Shows **both local and remote-tracking branches**.
- Output:

```
* main  feature/login  remotes/origin/HEAD -> origin/main  remotes/origin/main  remotes/origin/develop  remotes/origin/feature/payment
```

Explanation:

- `* main` → You're currently on the local `main` branch.
- `feature/login` → Another local branch.
- `remotes/origin/main` → The `main` branch on the remote named `origin`.
- `remotes/origin/develop` → The remote `develop` branch.
- `remotes/origin/feature/payment` → A remote feature branch.
- `remotes/origin/HEAD -> origin/main` → Indicates the default branch of the remote repository.
- ### When is this useful?

Suppose you cloned a repository:

```
git clone https://github.com/user/project.gitcd project
```

Running:

```
git branch
```

might show:

```
* main
```

But:

```
git branch -a
```

might show:

```
* main  remotes/origin/main  remotes/origin/develop  remotes/origin/release
```

Now you know there are `develop` and `release` branches on the remote.

If you want to work on `develop`:

```
git checkout develop
```

(or with newer Git:)

```
git switch develop
```

Git will create a local `develop` branch that tracks `origin/develop` automatically if it doesn't already exist.

**Interview tip:** `git branch -a` does **not** contact the remote server. It only displays the local branches and the remote-tracking branches that your local repository already knows about. To update that information first, run:

```
git fetch
```

Then run:

```
git branch -a
```

to see the latest remote branches.


---

## 📂 6. Check Current Status

```bash
git status
```

👉 Shows:

- modified files
    
- staged files
    
- untracked files
    

---

## ➕ 7. Add Files to Staging

```bash
git add .
```

👉 Adds all files

or specific:

```bash
git add <file>
```

---

## 💾 8. Commit Changes

```bash
git commit -m "your message"
```

👉 Saves snapshot locally

---

## 🚀 9. Push to Remote

```bash
git push -u origin main
```

👉 Uploads code to GitHub  
👉 `-u` sets upstream (future pushes easier)

---

## 🔄 10. Future Push (after upstream set)

```bash
git push
```

---

## 📥 11. Pull Latest Changes

```bash
git pull
```

👉 Gets latest from remote

---

## 🔎 12. Check Current Repo Info

```bash
git branch
```

👉 Shows current branch

---

## 🧠 13. Check Which Repo Folder is Connected To

```bash
git remote -v
```

👉 Answer to your question:

> “which repo is my folder pointing to?”

---

## 🚫 14. .gitignore (concept)

- Used to ignore files (logs, secrets, etc.)
    

Example:

```text
*.log
.env
terraform.tfstate
```

---

## 🔥 Typical Flow You Did

```bash
rm -rf .git
git init
git remote add origin <url>
git branch -M main
git add .
git commit -m "initial commit"
git push -u origin main
```

---

## 🧠 Key Understanding

- `.git` folder = repo identity
    
- removing it = fresh start
    
- remote = connection to GitHub
    
- commit = local snapshot
    
- push = send to remote
    

## 15.git log vs git reflog
`git log` shows the **commit history** of the current branch.

Basic command:

```
git log
```

Example output:

commit 8a1d3f6b9f7c1d4...
Author: John Doe <john@example.com>
Date:   Thu Jul 2 10:30:15 2026

    Added login validation

commit c4b29a9d8e...
Author: Jane Smith <jane@example.com>
Date:   Wed Jul 1 14:20:05 2026

    Fixed Docker build

commit 12ab34cd56...
Author: John Doe <john@example.com>
Date:   Tue Jun 30 09:15:00 2026

    Initial commit```

Each commit contains:

- **Commit ID (SHA)** – Unique identifier for the commit.
- **Author** – Who made the commit.
- **Date** – When it was created.
- **Commit message** – Description of the change.

### Commonly used variations

**One-line summary (most common):**

```
git log --oneline
```

Output:

```
8a1d3f6 Added login validationc4b29a9 Fixed Docker build12ab34c Initial commit
```

---

**Show commits as a graph (very useful with branches):**

```
git log --oneline --graph --all
```

Example:

```
* 8a1d3f6 Added login validation
* c4b29a9 Fixed Docker build
|\
| * a91f234 Feature payment
|/
* 12ab34c Initial commit
```

This lets you visualize branching and merging.

---

**Show last 5 commits:**

```
git log -5
```

---

**Show changes introduced by each commit:**

```
git log -p
```

---

**Show commits by a specific author:**

```
git log --author="John Doe"
```

---

**Show commits affecting a specific file:**

```
git log app.py
```

### Interview example

Suppose you have this history:

Initial commit
      │
      ▼
Added Dockerfile
      │
      ▼
Configured Jenkins
      │
      ▼
Fixed Kubernetes manifest
```

Running:

```
git log --oneline
```

might display:

```
f8c21a4 Fixed Kubernetes manifest
a3d9b12 Configured Jenkins
9e2c671 Added Dockerfile
4f5b123 Initial commit
```

### Frequently asked interview question

**Q: What is the difference between `git log` and `git reflog`?**

- `git log` shows the **history of commits**.
- `git reflog` shows the **history of where `HEAD` and branch references have pointed**, including commits, checkouts, rebases, resets, and other local reference movements. It is often used to recover work after operations like `git reset --hard`.






---
git checkout <commit_id>
git switch --detach <commit_id>
git reset --hard <commit_id>
“Can I revert commits between commit A and commit B, not just HEAD → A?”
		Answer: yes, with:
		git revert A^..B
---
copy only single folder from a REPO
	git sparse-checkout set roboshop-infra-eks/31-cicd-tools
	ls
	git branch -a
	cd  roboshop-infra-eks  
	git sparse-checkout set 31-cicd-tools
	git sparse-checkout list
	ls
	cd 31-cicd-tools
	 ls
copy one repo from one github acct to another
git clone https://github.com/daws-88s/catalogue-unit-tests.git
   5        0.017 cd catalogue-unit-tests
   6        0.094 git remote set-url origin https://github.com/MrudulaMang/catalogue-unit-tests.git
   7        0.083 git remote -v
   8        1.637 git add .; git commit -m "jenkin unit tests"; git push origin main

-------------
 git config --list

---Git commit identity
git config user.name
git config user.email

ssh -T git@github.com ---This shows which GitHub account is authenticated.

-----------------------------------------------------

Your local folder and the new GitHub repo are separate histories. “Merge” means connecting the local folder to the remote repo and pushing your code.

If your local folder is not yet a Git repo:

```
cd your-folder
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

git remote remove origin
git remote show origin