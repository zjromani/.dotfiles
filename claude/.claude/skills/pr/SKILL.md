# PR Skill

Create a GitHub pull request with a well-structured description. Make it concise always
sacrifice grammar for the sake of concision.

## Instructions

1. Run `git log main..HEAD --oneline` (or appropriate base branch) to see all commits
2. Run `git diff main..HEAD --stat` to understand scope of changes
3. Check if branch is pushed: `git status -sb`
4. If not pushed, push with: `git push -u origin HEAD`
5. Create PR using `gh pr create` with the format below

## PR Format

```
gh pr create --title "Brief descriptive title" --body "$(cat <<'EOF'
## Summary

[2-3 bullet points explaining what this PR does and why]

## Changes

- [Key change 1]
- [Key change 2]

## Test Plan

- [ ] [How to verify this works]

## Notes

[Any context reviewers should know - breaking changes, dependencies, etc.]
EOF
)"
```

## Guidelines

- Title should be imperative mood: "Add feature" not "Added feature"
- Summary focuses on the "why", changes list the "what"
- Always include a test plan, even if it's manual steps
- Link to relevant Jira tickets if applicable
- For draft PRs, use `gh pr create --draft`
