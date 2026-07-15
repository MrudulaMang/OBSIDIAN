# Git Secret Removal & History Rewrite — Quick Notes

## Problem

GitHub rejected the push with:

```
GH013: Repository rule violations
Push cannot contain secrets
```

AWS Access Key and Secret Access Key existed in:

```
others/Devops_accessKeys.txt
```

The file was already deleted from the current folder, but GitHub still detected it.

### Why?

Because Git stores file changes in commit history.

```
Commit A → Secret file added ❌
Commit B → File deleted
```

Deleting in Commit B does **not** remove the secret from Commit A.

GitHub Push Protection scanned the commits being pushed and found the old secret.

---

## What We Did

### 1. Checked Git status

```
git status
```

Shows:

- current branch
- working tree status
- whether local branch is ahead/behind remote

Example:

```
Your branch is ahead of 'origin/main' by 5 commits
```

Meaning:

> Local `main` has 5 commits that `origin/main` does not have.

---

### 2. Found commits containing the secret file

```
git log --oneline main -- others/Devops_accessKeys.txt
```

Output:

```
51f85e7 ob
806db12 ob
```

`--oneline` displays each commit in a compact single-line format.

This showed the file was touched in two commits—likely added in one and deleted in another.

---

### 3. Checked what the bad commit contained

```
git show --stat 806db12
```

Shows files changed in a commit and change statistics.

We discovered `806db12` contained:

- AWS credential files ❌
- Kubernetes notes
- Terraform notes
- Linux notes
- Networking notes
- Images

Therefore, we could **not simply delete/drop the commit** because useful content would also be lost.

---

## Why We Rewrote Git History

We needed to modify an **old commit** and remove only the credential files.

Original history:

```
A → B → 806db12 → D → E → F
             ↑
          Secret
```

After rewriting:

```
A → B → 2579217 → D' → E' → F'
             ↑
       Secret removed
```

The commit hashes changed because a Git commit includes a reference to its parent.

Change one old commit → all descendant commit hashes change.

---

## Interactive Rebase

Command used:

```
git rebase -i 806db12^
```

`-i` = interactive mode.

`806db12^` = start from the parent of `806db12`, so the target commit itself is included.

Important difference:

```
git rebase -i 806db12
```

Rebases commits **after** `806db12`.

```
git rebase -i 806db12^
```

Includes `806db12`.

---

## Edited the Target Commit

In the rebase editor:

```
pick 806db12 ob
```

Changed to:

```
edit 806db12 ob
```

`edit` tells Git:

> Stop at this commit and allow me to modify it.

Git stopped at:

```
Stopped at 806db12
You can amend the commit now
```

---

## Removed Secret Files

```
git rm others/Devops_accessKeys.txt
git rm others/Devops_credentials.txt
```

Removes the files from the commit being edited.

---

## Amended the Commit

```
git commit --amend --no-edit
```

`--amend` modifies the current commit.

`--no-edit` keeps the existing commit message.

The old commit was replaced with a new commit hash.

---

## Continued the Rebase

```
git rebase --continue
```

Git replayed the remaining commits on top of the modified commit.

Before:

```
806db12
ce51e89
6ef1cb5
51f85e7
8f6f64c
```

After:

```
2579217
7ef5787
ca3ca02
92b064d
f1cc74a
```

Same logical history, but new hashes because history was rewritten.

---

## Compared Local and Remote Branches

```
git log --oneline origin/main..main
```

Means:

> Show commits in local `main` that are not in `origin/main`.

It showed 5 local commits.

---

## Final Push

```
git push origin main
```

Successful output:

```
0e3da58..f1cc74a  main -> main
```

The rewritten commits were successfully pushed.

---

## Key Lessons

1. Deleting a secret file does not remove it from Git history.
2. GitHub can detect secrets inside commits being pushed.
3. `git rebase -i` can modify old commits.
4. Use `edit` when you want to change a commit.
5. Use `drop` only when the entire commit can be removed.
6. Rewriting an old commit changes all descendant commit hashes.
7. Keep commits atomic: **one logical change per commit**.
8. Credentials should be in `.gitignore` and should never enter Git history.
9. If real AWS keys are committed, rotate/revoke them even after history cleanup.

-------------------
git filter-branch --force --index-filter \
"git rm --cached --ignore-unmatch others/Devops_accessKeys.txt" \
--prune-empty -- main

telling to find the commit which has the seceret file and remove that scerert file and change the commit hash as the commit is immutable.