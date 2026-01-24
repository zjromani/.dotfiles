# PR Skill

Create a GitHub pull request. Prioritize concision over grammar.

## Instructions

1. Run `git log main..HEAD --oneline` to see commits
2. Run `git diff main..HEAD --stat` for scope
3. Push if needed: `git push -u origin HEAD`
4. Create PR with `gh pr create`

## PR Format

```
gh pr create --title "Added feature X" --body "$(cat <<'EOF'
## Summary
- [Why this change exists]

## Test Plan
- [ ] [How to verify]
EOF
)"
```

## Guidelines

- Title uses past tense: "Added feature" not "Add feature"
- Summary is the "why", keep it minimal
- For draft PRs: `gh pr create --draft`
