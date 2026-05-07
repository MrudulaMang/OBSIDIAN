
`git reset` and `git revert` are both used to undo changes, but they work differently. `git reset` moves the branch pointer (HEAD) to an earlier commit and can remove commits from history, which makes it suitable mainly for local or private branches before code is shared. Depending on `--soft`, `--mixed`, or `--hard`, it may keep changes staged, unstaged, or delete them completely. `git revert`, on the other hand, does not remove history; it creates a new commit that reverses the effect of a previous commit, making it safer for shared branches like develop, release, or production where preserving history and auditability is important. In simple terms: reset rewrites history, revert preserves history.


`git reset` and `git revert` are not single commands—they have important variants. Know these, not just the names.

`git reset` commands

```
git reset --soft <commit>
```

Moves HEAD to the commit, keeps changes staged.

```
git reset --mixed <commit>
```

(Default)

Moves HEAD, keeps changes in working directory but unstaged.

```
git reset --hard <commit>
```

Moves HEAD and deletes local changes.

```
git reset HEAD <file>
```

Unstages a file.

```
git reset --soft HEAD~1
```

Undo last commit, keep changes staged.

```
git reset --hard HEAD~1
```

Remove last commit and discard changes.

```
git reset --hard origin/main
```

Force local branch to match remote.

---

`git revert` commands

```
git revert <commit>
```

Creates a new commit that undoes that commit.

```
git revert HEAD
```

Revert latest commit.

```
git revert HEAD~2..HEAD
```

Revert a range of recent commits.

```
git revert --no-commit <commit>
```

Apply revert changes without auto commit.

```
git revert -m 1 <merge_commit>
```

Revert a merge commit (`-m` specifies parent).

---

What people forget in interviews:

Reverting a merge commit is different:

```
git revert -m 1 <merge_commit>
```

If they ask this and you miss `-m`, it shows shallow understanding.

---

The dangerous mistake:

Using

```
git reset --hard
```

on shared branches.

That breaks teams.

That is why senior engineers ask this question. They are testing judgment, not syntax.`git reset` and `git revert` are both used to undo changes, but they work differently. `git reset` moves the branch pointer (HEAD) to an earlier commit and can remove commits from history, which makes it suitable mainly for local or private branches before code is shared. Depending on `--soft`, `--mixed`, or `--hard`, it may keep changes staged, unstaged, or delete them completely. `git revert`, on the other hand, does not remove history; it creates a new commit that reverses the effect of a previous commit, making it safer for shared branches like develop, release, or production where preserving history and auditability is important. In simple terms: reset rewrites history, revert preserves history.

-------------------------

# REVERT



--------
in which env revert is used

Mostly in shared environments—especially branches like `develop`, `release`, `main`, or `production`—where history must remain intact.

Why?

Because `git revert` creates a new commit that cancels the effect of an old commit instead of deleting history.

That matters when others may already have pulled the bad commit.

Typical cases:

1. UAT / QA branch  
    A bad feature was merged and testing failed.  
    You revert the merge commit instead of rewriting branch history.
2. Staging / Pre-prod  
    Deployment caused issues.  
    You revert the release commit so the branch remains auditable.
3. Production / Main branch  
    A hotfix introduced a bug.  
    You usually revert, not reset, because force-pushing production history is risky and often blocked.
4. Shared develop branch  
    A teammate’s merged PR broke integration.  
    Revert is safer than reset because everyone already depends on that history.