- `git fetch` retrieves the latest changes from the remote repository **without merging** them into your current branch.
- `git pull` does the same as `fetch` but **also automatically merges** the changes into your current branch.

### fetch the changes and then we have to merge or rebase. If u want to inspect changes, when u r working on critical incomapttable story like in production . like experimental changes.  if many people r working on that remote repo i will cherry pick the commit and merge

pull means directly pull the updated version= fetch+merge/rebase. if u r sure about the changes.

when a commit is made there are bunch of chekcs like ci/cd smoke test to be sure about commits.
i frequently do git pull on timeliy basis to sure sue of recent changes