---
name: commit
description: Create a git commit with a well-formatted, atomic commit message. Use when the user wants to commit staged or unstaged changes.
---
# Commit Skill

Create a git commit with a well-formatted message.

## Instructions

**Always aim to commit small atomic changes that can easily be rolled back**

Example: One commit has implementation and test change in same commit.
Example: One commit that aims to refactor **only** changes the implementation
(because we don't want to change test at same time as a refactor. If there are
poor test coverage, that should come first in case of a refactor. Refactor should
not change behavior, only structure)

1. Run `git status` and `git diff --staged` to see what's being committed
2. Run `git log --oneline -5` to see recent commit style
3. Write a concise commit message that:
   - Uses past tense "Added" not "Add" to start every commit
   - Summarizes the "why" in the commit message
   - Keeps first line under 72 characters
4. Stage any unstaged changes if the user wants them included
5. Create the commit

## Example

```
Fixed authentication timeout on slow connections

The timeout was causing errors for a very specific user (id: 767) and this
is critical to allow that user through as they are a large account.

Plan should be to revisit this later when time.
```
