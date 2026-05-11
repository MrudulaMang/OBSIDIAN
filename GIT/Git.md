# 📘 Git Commands — What You Learned

---

## 🧠 1. Initialize Repository

```bash
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
