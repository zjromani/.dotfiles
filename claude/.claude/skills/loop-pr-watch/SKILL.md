---
name: loop-pr-watch
description: Autonomous PR review loop. Triages review comments every 3 minutes via sub-agents — auto-fixes mechanical changes (renames, style, formatting), pushes back on structural ones, flags merge conflicts and always-human cases. Responds to every comment with the commit SHA that addresses it. Loops until the PR is approved + green or 45 minutes elapse. Never merges the PR itself. Invoke with `/loop /loop-pr-watch [PR-number|URL]` in Claude Code for fully autonomous operation, or `/loop-pr-watch [PR-number|URL]` for a single check cycle in Cursor.
---

# loop-pr-watch

Autonomous PR review loop. Handles the mechanical back-and-forth of a GitHub PR review so you only get interrupted for judgment calls.

**Hard rules — never break these:**
- Never merge the PR
- Never rebase or rewrite git history
- Never auto-resolve merge conflicts
- Never commit a fix without first running type-check + lint
- Never push if validation fails
- One atomic commit per comment fix (independently revertable)
- Always respond to a comment before or after the commit — never claim a fix without a SHA reference

---

## Invocation

```
/loop-pr-watch [PR-number | PR-url]
```

**Claude Code (recommended):** Invoke as `/loop /loop-pr-watch [PR]` for a self-paced loop that checks every 3 minutes. The skill calls `ScheduleWakeup(180)` to continue and omits the call to stop.

**Cursor / manual:** Invoke `/loop-pr-watch [PR]` directly for one check cycle. At the end it prints next-step instructions if not done.

---

## Step 0 — Resolve PR and load state

```bash
# If no arg provided:
gh pr view --json number,headRefName,baseRefName,title,body,url

# Detect owner/repo from remote:
gh repo view --json nameWithOwner
```

State file path: `/tmp/loop-pr-watch-{PR-number}.json`

**First run (no state file):** Initialize state:
```json
{
  "pr": 123,
  "repo": "owner/repo",
  "start_epoch": <unix timestamp now>,
  "handled_ids": [],
  "conflict_flagged": false,
  "iter": 0
}
```

Post opening comment on the PR:
> "loop-pr-watch started. Monitoring for 45 minutes. I'll auto-fix mechanical review comments and flag anything that needs human judgment. I will not merge this PR."

**Subsequent runs:** Read state file, increment `iter`.

---

## Step 1 — Timeout check

```bash
date +%s  # get current epoch
```

If `now - start_epoch > 2700` (45 minutes):
- Post timeout summary comment (see Exit Comment format)
- Stop. Do NOT call ScheduleWakeup.

---

## Step 2 — PR state check

```bash
gh pr view {PR} --json state,mergeable,reviewDecision,statusCheckRollup
```

**Exit conditions (stop looping):**
- `state = MERGED` or `state = CLOSED` → exit silently, no comment
- `reviewDecision = APPROVED` AND all status checks are passing → post success comment, stop

---

## Step 3 — Merge conflict check

```bash
gh pr view {PR} --json mergeable
```

If `mergeable = CONFLICTED` and `state.conflict_flagged = false`:
- Post on the PR:
  > "Merge conflicts detected. I won't rebase or rewrite history — please resolve manually and re-push."
- Set `conflict_flagged = true` in state. Do not repeat this comment on future iterations.

---

## Step 4 — Fetch unhandled review comments

```bash
# Inline review comments (line-level):
gh api repos/{repo}/pulls/{PR}/comments

# Review-level comments and CHANGES_REQUESTED reviews:
gh api repos/{repo}/pulls/{PR}/reviews
```

Filter to IDs not already in `state.handled_ids`. These are the comments to process this iteration.

For `CHANGES_REQUESTED` reviews, collect both the review-level summary body and any inline comments from that review.

---

## Step 5 — Triage each unhandled comment

Process comments one at a time. For each:

### Pre-filter (deterministic — no LLM needed)

Route to **escalate** immediately if ANY of these match:

**Path-based:** The comment references a file matching:
- `infra/`, `terraform/`, `k8s/`, `Dockerfile`, `.github/workflows/`, `CODEOWNERS`

**Keyword-based** (case-insensitive in comment body):
- `blocking`, `security concern`, `security issue`, `architecture`, `breaking change`, `breaking change`

**Review state:**
- The comment belongs to a `CHANGES_REQUESTED` review AND is a review-level summary (not an inline code comment on a specific line)

If escalate: post reply, add to `handled_ids`, move to next comment.

### 4-Gate LLM triage

Spawn a **triage sub-agent** (see Sub-agent Context spec below). The sub-agent reads the comment and the diff of referenced file(s) and returns:

```json
{ "decision": "implement|pushback|escalate", "gate_failed": null, "reasoning": "one sentence" }
```

Gates — apply in order, first failure determines outcome:

**Gate 1 — Scope**
- Touches ≤ 3 files
- ≤ 50 LOC delta
- No change to exported function signatures, HTTP route definitions, DB schema, wire format, CLI flags, or public SDK surface

**Gate 2 — Reversibility**
- A single `git revert {SHA}` would restore prior behavior
- Does not delete a public symbol, route, column, or field
- Does not narrow a type, interface, or accepted input set
- Does not move logic across architectural layers (controller ↔ service ↔ repo ↔ infra)

**Gate 3 — Extensibility**
- Does not replace an abstraction with a concrete implementation
- Does not collapse an enum or union type into a stringly-typed value
- Does not remove an extension point (interface, hook, strategy pattern, registered handler)
- Does not couple two previously independent modules

**Gate 4 — Behavior**
- No change to validation rules, authentication, authorization, or error semantics
- No change to retry logic, timeouts, concurrency primitives, or transaction boundaries

**Examples:**
| Comment | Decision | Gate |
|---------|----------|------|
| Rename local variable | implement | all pass |
| Reformat to match style guide | implement | all pass |
| Extract private helper method | implement | all pass |
| Make concrete class implement an interface | implement | all pass |
| Change public method signature | pushback | Gate 1 |
| Remove a public method | pushback | Gate 2 |
| Move validation from controller to service | pushback | Gate 2 |
| Change enum to string type | pushback | Gate 3 |
| Add input validation that changes contract | escalate | Gate 4 |

---

## Step 6 — Execute decisions

### implement

Spawn a **fix sub-agent** (see Sub-agent Context spec below).

Fix sub-agent responsibilities:
1. Implement the change
2. Run type-check + lint (e.g., `tsc --noEmit`, `eslint`, `rubocop`, `go vet` — pick the appropriate tool for the repo)
3. If validation fails: stop, report the failure. Do NOT commit.
4. If validation passes: create ONE atomic commit with a past-tense message scoped to this comment (e.g., "Renamed `getFoo` to `fetchFoo` per review")
5. Push the branch
6. Return the commit SHA

Main agent then:
- Posts reply on the comment thread:
  > "Addressed in {SHA} — {one sentence describing what changed}."
- Adds comment ID to `state.handled_ids`

### pushback

Post reply explaining which gate failed:
> "Declining this one — [specific reason citing the gate, e.g., 'this changes the public interface signature which would require coordinated updates across callers']. Happy to discuss if there's a different framing."

Add to `handled_ids`.

### escalate

Post reply:
> "Flagging this for human review — [brief reason, e.g., 'comment touches auth logic which I won't modify automatically']. @{PR-author}"

Add to `handled_ids`.

---

## Step 7 — Persist state and schedule next check

Write updated state.json (incremented `iter`, updated `handled_ids`, `conflict_flagged`).

**If in Claude Code loop context:** Call `ScheduleWakeup(delaySeconds=180, prompt="<<autonomous-loop-dynamic>>", reason="Next loop-pr-watch check in 3 minutes")`.

**If ScheduleWakeup is unavailable (Cursor or direct invocation):** Print:
> "Check complete (iteration {iter}). Run /loop-pr-watch {PR} again in 3 minutes to continue monitoring."

---

## Exit Comments

**Success:**
```
loop-pr-watch done — review approved and all checks passing.
Handled {N} comments: {X} implemented, {Y} pushed back, {Z} escalated.
```

**Timeout:**
```
loop-pr-watch timed out after 45 minutes.
Handled {N} comments: {X} implemented, {Y} pushed back, {Z} escalated.
Still open: comment IDs {list} — requires human attention.
```

---

## Sub-agent Context Spec

Both triage and fix sub-agents are spawned as `subagent_type: "pr-reviewer"`. The agent definition encodes Engine's stack standards, review style, the 4-gate rubric, and the pre-filter — do not re-embed those in the prompt.

### Triage sub-agent

Spawn with `subagent_type: "pr-reviewer"`. Prompt must include:

- **Mode**: "Operate in triage mode. Return JSON only."
- **PR context**: PR title, description, base branch, PR URL
- **Comment**: full comment body, commenter username, the file and line it references
- **Diff**: diff of the specific file(s) referenced (`gh api repos/{repo}/pulls/{PR}/files`)
- **Session context**: any requirements, architecture decisions, or constraints the main agent has — pass verbatim so the sub-agent understands the intent behind the PR

Expected output (JSON only):
```json
{"decision": "implement|pushback|escalate", "gate_failed": null|"1"|"2"|"3"|"4", "reasoning": "one sentence"}
```

### Fix sub-agent

Spawn with `subagent_type: "pr-reviewer"`. Prompt must include everything the triage sub-agent got, plus:

- **Mode**: "Operate in fix mode. Return the commit SHA only."
- **Triage verdict**: the decision and reasoning from the triage sub-agent
- **Branch**: current branch name and base branch
- **Hard rules** (embed verbatim):
  - Run type-check + lint before committing. If it fails, stop and report — do not commit.
  - One atomic commit per fix. Commit message: past tense, scoped to this comment. Under 72 chars.
  - Never use `--no-verify`.
  - Never merge the PR.
  - Never rebase or rewrite history.
  - Push the branch after committing.
  - Return the commit SHA as your final output.
