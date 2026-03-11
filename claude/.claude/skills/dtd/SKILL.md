---
name: dtd
description: "Produce a well-structured Design Technical Document (DTD). Interviews the user with 6 targeted questions, then emits a complete, Confluence-ready DTD with all sections in order — high-level intent first, implementation details last."
---

# DTD

A Design Technical Document is the canonical artifact for communicating a feature or system change across engineering, product, and stakeholders. Without structure, DTDs either bury intent under implementation detail or skip sections that matter to reviewers. This skill enforces the right order: problem and solution first, implementation detail last.

This produces one artifact: a complete, Confluence-ready DTD filled with your answers and `[ADD CONTENT HERE]` stubs for anything you didn't cover.

## When to Trigger

- User says "write a DTD," "create a design doc," "I need to document this feature"
- Before starting implementation on a non-trivial feature
- When a user has a design to communicate to reviewers or stakeholders

## The Interview

Ask these 6 questions in order. Wait for answers before emitting the DTD. If the user gives short answers, ask one follow-up to get enough signal for the doc.

### 1. Feature name and context links
"What is the feature or project name? Share any relevant links (Asana, Figma, Discovery Doc, Preliminary Design, related PRs or issues)."

### 2. Problem statement
"What problem is this solving? Give me 2–3 sentences — what breaks, what's missing, or what user need is unmet today."

### 3. Proposed solution
"What is the proposed solution? 2–3 sentences on the approach, not the implementation."

### 4. Phased release plan
"How will this ship? Describe the main phases or epics. It's fine if it's a single phase."

### 5. API and data model changes
"Are there any known API changes, new endpoints, or data model changes? Describe them briefly, or say 'none yet' if unknown."

### 6. Authorization changes
"Are there any changes to authorization scopes or permission checks? Which endpoints or resources are affected?"

---

After gathering answers, emit the full DTD. Do not ask more questions — stub out anything not covered.

## Output Format

Emit the DTD using the template below. Fill in answers from the interview. For any section not addressed, insert `[ADD CONTENT HERE]` so the gap is visible but not blocking.

**Section order is enforced**: high-level sections first, implementation details grouped at the bottom under `## Implementation Details`. This prevents reviewers from wading through architecture diagrams before understanding the problem.

---

```markdown
# [Feature Name] — Design Technical Document

## Related Links

| Type | Link |
|------|------|
| Asana | [ADD LINK] |
| Figma | [ADD LINK] |
| Discovery Doc | [ADD LINK] |
| Preliminary Design | [ADD LINK] |

---

## Problem Statement

[2–5 sentences. What is broken, missing, or painful today? Who is affected and how?]

---

## Proposed Solution

[2–5 sentences. What is the approach? Why is this the right solution? What does it not do?]

---

## Phased Release Plan

| Phase | Epic / Description | Notes |
|-------|--------------------|-------|
| 1 | [ADD CONTENT HERE] | |
| 2 | [ADD CONTENT HERE] | |

---

## Implementation Details

### System Design

#### Architecture

[ADD CONTENT HERE — sequence diagrams, component diagrams, or prose describing the system flow]

#### Data Model

[ADD CONTENT HERE — new tables, columns, or schema changes]

#### UI

[ADD CONTENT HERE — link to Figma or describe key UI changes]

#### API Docs

[ADD CONTENT HERE — new or modified endpoints, request/response shapes]

---

### Fault Tolerance

[ADD CONTENT HERE — what happens when dependencies fail? graceful degradation? retry logic?]

---

### Test Plan

#### Automation Tests

| Test | Type | Description | Coverage |
|------|------|-------------|----------|
| [test name] | Unit / Integration / E2E | [what it tests] | [what it covers] |

---

### Observability

#### Amplitude Events

| Event Name | Trigger | Properties | Notes |
|------------|---------|------------|-------|
| [event name] | [user action that triggers it] | [key properties] | |

#### Datadog Metrics

| Metric | Type | Description | Alert Threshold |
|--------|------|-------------|-----------------|
| [metric name] | Counter / Gauge / Histogram | [what it measures] | [threshold if applicable] |

---

### Changes to Managed Objects

| Object | Change Type | Description |
|--------|-------------|-------------|
| [object name] | Add / Modify / Remove | [what changes and why] |

---

### Authorization

| Endpoint / Resource | Scope Required | Change |
|--------------------|----------------|--------|
| [endpoint] | [scope] | New / Modified / Removed |

---

### Product Metrics

| Event | Description | Target |
|-------|-------------|--------|
| [metric event] | [what it measures] | [success target if known] |

---

### Solution Alternatives

| Alternative | Why Considered | Why Rejected |
|-------------|----------------|--------------|
| [alternative approach] | [rationale for evaluating it] | [reason it was ruled out] |
```

---

## Delivery

Present the filled DTD. Then ask:

> "Does this capture the design, or are there sections you want to flesh out now?"

If the user wants to iterate on a section, help them fill it in. If they're done, remind them: "Copy this into Confluence. Stub sections (`[ADD CONTENT HERE]`) are intentional — fill them in as the design matures."

## What Not to Do

- Don't skip the interview and ask the user to fill in a blank template — the value is in synthesizing their answers into prose
- Don't put implementation detail in Problem Statement or Proposed Solution — those sections stay high-level
- Don't remove empty table rows — skeleton tables signal "this needs content" to reviewers
- Don't add sections beyond the template without a clear reason — the template is the standard
- Don't make Problem Statement or Proposed Solution longer than 5 sentences — compression is the point
