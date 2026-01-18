# Commit Skill

Create a git commit with a well-formatted message.

## Instructions

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
