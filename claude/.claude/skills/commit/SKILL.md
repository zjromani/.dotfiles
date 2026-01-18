# Commit Skill

Create a git commit with a well-formatted message.

## Instructions

**Always aim to commit small atomic changes that can easily be rolled back**

Example: One commit has implementaion and test change in same commit. 
Example: One commit that aims to recactor **only** changes the implentation
(because we dont' want to change test at same time as a refactor. if there are 
poor test coverage, that should come first in case of a refactor. refactor should
not change behacior, only structure)

1. Run `git status` and `git diff --staged` to see what's being committed
2. Run `git log --oneline -5` to see recent commit style
3. Write a concise commit message that:
   - Uses past tense "Added" not "Add" to start every commit
   - Summarizes the "why" in the commit message.
   - Keeps first line under 72 characters
4. Stage any unstaged changes if the user wants them included
5. Create the commit

## Example

```
Fix authentication timeout on slow connections

Increased the default timeout from 5s to 30s to handle
users on slower networks. Also added retry logic.
```
