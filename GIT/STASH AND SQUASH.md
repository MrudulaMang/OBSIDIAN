
`git stash` is used to temporarily save uncommitted changes without making a commit.

It answers this situation:

“I’m in the middle of work, but I need to switch branches or pull urgent changes, and my current changes are incomplete.”

Instead of making a dirty temporary commit like:

`WIP final latest final2`

you stash it.

Example:

```
git stash
```

This takes your modified tracked files, stores them safely, and returns your working directory to a clean state.

Later:

```
git stash pop
```

This brings the changes back.

Common real cases:

1. Production hotfix arrives  
    You’re building feature A, but must urgently switch to fix prod issue on another branch.
2. Need to pull latest code  
    Git may block pull because your local uncommitted changes would be overwritten.
3. Experimental code  
    You tried something messy and want to park it temporarily.

Useful commands:

```
git stash
```

stash current work

```
git stash list
```

see all stashes

```
git stash pop
```

apply and remove stash

```
git stash apply
```

apply but keep stash

```
git stash drop
```

delete stash

```
git stash -u
```

include untracked files

Important:

Stash is temporary parking, not long-term storage.  
Good engineers forget stashes and lose context.

Use stash for interruption handling, not as a substitute for clean commits.

# SQUASH

Squash is used to combine multiple commits into a single clean commit so that history becomes easier to read and review. It is commonly done before raising a pull request when a feature branch contains many small commits like “fix typo,” “update again,” or “final change.” Instead of pushing messy history, squash creates one meaningful commit such as “Implement payment service retry logic.” This improves rollback, code review, and audit clarity. Squashing is usually done on local feature branches, not shared branches, because it rewrites history.

Common commands:

```
git rebase -i HEAD~3
```

Interactively squash the last 3 commits

```
pick a1b2 first commitsquash c3d4 second commitsquash e5f6 third commit
```

Change `pick` to `squash` for commits you want to combine

```
git push --force
```

Push rewritten history after squash (only safe on your own branch)
