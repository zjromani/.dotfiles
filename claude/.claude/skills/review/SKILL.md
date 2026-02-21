---
name: review
description: Review code changes for correctness, security, performance, and maintainability. Use when the user wants feedback on a PR diff or staged changes.
---
# Review Skill

Review code changes for a pull request or staged changes.

## Instructions

1. Get the diff to review:
   - For PR: `gh pr diff <number>` or `gh pr view <number> --web`
   - For local: `git diff` or `git diff --staged`

2. Review for these categories:

### Correctness
- Does the logic do what it claims?
- Edge cases handled?
- Error handling present where needed?

### Security
- Input validation on external data?
- No secrets or credentials?
- SQL injection, XSS, or injection risks?

### Performance
- Unnecessary loops or N+1 queries?
- Large allocations in hot paths?
- Missing indexes for new queries?

### Maintainability
- Clear naming and intent?
- Appropriate test coverage?
- No dead code or commented-out blocks?

## Output Format

```
## Summary
[One sentence overall assessment]

## Issues
- **[Critical/Major/Minor]**: [description] (file:line)

## Suggestions
- [Optional improvements, not blocking]

## Verdict
[Approve / Request Changes / Needs Discussion]
```

## Severity Calibration

- **Critical**: Bugs that will hit production, security vulnerabilities, data loss risks. Must fix before merge.
- **Major**: Logic errors in non-obvious paths, missing validation on external input, performance issues at scale. Should fix before merge.
- **Minor**: Style nits, naming suggestions, small readability improvements. Nice to fix, not blocking.

## Guidelines

- Be specific - reference file:line when possible
- Distinguish blocking issues from suggestions
- Acknowledge what's done well, briefly
- If reviewing your own code, be extra critical
