---
name: learn
description: Create structured, self-contained lessons to ramp up on any domain — a codebase, technology, team process, or concept. Use when the user wants to "learn", "ramp up", "get up to speed", "create lesson", or "understand" something unfamiliar.
---
# Learn Skill

Build a structured curriculum of self-contained lesson files that rapidly build understanding of an unfamiliar domain.

## Core Principles

1. **Self-contained lessons.** Every lesson includes all information needed to understand the topic. External links are attribution, not required reading. A reader should never need to open another document to follow the lesson.
2. **Research before writing.** Never fabricate. Investigate the actual codebase, docs, APIs, and tools before writing a single line of lesson content.
3. **Curriculum over individual lessons.** Lessons build on each other in a deliberate sequence. The learning guide (`00-learning-guide.md`) is the syllabus — it defines what to learn and in what order.
4. **300-word minimum.** Every lesson must be at least 300 words. This enforces real research over shallow summaries.

## Invocation Patterns

| Command | Behavior |
|---------|----------|
| `/learn <domain>` | New curriculum — create `.lessons/`, draft learning guide, write first lesson |
| `/learn <topic>` | Add a lesson to an existing `.lessons/` directory |
| `/learn --update <file>` | Process the `## Updates` section in an existing lesson |
| `/learn --status` | Show curriculum progress from the learning guide |

If `.lessons/` exists, `/learn <topic>` adds a lesson. If it doesn't, `/learn <domain>` bootstraps a new curriculum.

## Workflow: New Curriculum

1. **Assess the domain type** to pick a research strategy:
   - **Codebase** — start with project structure, entry points, key abstractions. Use code search, READMEs, CI config.
   - **Technology** — start with core concepts, mental model, "hello world" equivalent. Use official docs, web search.
   - **Process / Team** — start with workflows, key terms, who-does-what. Use docs, Confluence, Slack if available.

2. **Create `.lessons/` directory** in the current project root.

3. **Draft `00-learning-guide.md`** — the curriculum index. Include:
   - H1 title: `# Learning Guide: <Domain>`
   - A 1–2 sentence description of what this curriculum covers
   - A progress table (see Learning Guide Format below)
   - Plan 5–10 lessons covering the domain from foundations to advanced topics

4. **Write the first lesson** (`01-*.md`) following the Lesson File Format.

5. **Present the plan** — show the user the proposed curriculum and ask if they want to adjust the lesson order or topics before continuing.

## Workflow: New Lesson

1. **Determine the next lesson number** from existing files in `.lessons/`.
2. **Research the topic** using this priority order:
   - Code search (Grep, Glob, Read) — for codebase domains
   - Project docs (README, docs/, wiki) — for any domain
   - MCP tools (Slack, Confluence, GitHub) — when available, don't error if not
   - Web search — for technology and general concepts
   - Existing lessons — avoid repeating what's already covered
3. **Write the lesson** following the Lesson File Format.
4. **Validate** — confirm 300+ words, self-contained, proper structure.
5. **Update `00-learning-guide.md`** — mark lesson status as complete, fill in summary.

## Workflow: Update Lesson

1. **Read the lesson file.**
2. **Find the `## Updates` section** — this is a scratch area where users (or reviewers) drop notes about what needs to change.
3. **Research each update item** — investigate code, docs, or web as needed.
4. **Apply changes** to the lesson body.
5. **Remove the `## Updates` section** entirely once all items are processed.
6. **Revalidate** — 300+ words, self-contained, proper structure.

## Lesson File Format

Filename: `NN-kebab-case-title.md` (e.g., `01-project-architecture.md`)

```markdown
# Lesson Title

One sentence stating what the reader will understand after this lesson.

---

## Section Heading

Body content. Use H2 and H3 for structure. Include code snippets, diagrams,
or examples where they aid understanding.

Attribute non-obvious claims inline (e.g., "per the Express.js docs, ...").
Date-stamp information that may become stale (e.g., "as of March 2026").

## Key Takeaways

- Bullet point summaries of the most important concepts
- 3–5 takeaways per lesson

## Additional Information

- Related lessons: `03-data-model.md`, `05-api-layer.md`
- Links to primary sources for further reading
```

### Rules

- H1 is the lesson title — exactly one per file
- First paragraph is the purpose sentence
- Horizontal rule (`---`) separates purpose from body
- `## Key Takeaways` is always the second-to-last section
- `## Additional Information` is always the last section
- `## Updates` is a temporary scratch section users can add anywhere — it gets consumed and removed by `/learn --update`

## Learning Guide Format

Filename: `00-learning-guide.md`

```markdown
# Learning Guide: <Domain>

Brief description of what this curriculum covers and who it's for.

| # | Lesson | Status | Summary |
|---|--------|--------|---------|
| 01 | Project Architecture | Complete | How the repo is structured and why |
| 02 | Data Model | In Progress | Core entities and their relationships |
| 03 | Authentication Flow | Planned | How users authenticate and sessions work |
```

Status values: `Planned`, `In Progress`, `Complete`

## Research Quality Standards

- **Never fabricate.** If you can't find the answer, say so in the lesson and note it as an area for future investigation.
- **Prefer primary sources.** Code > official docs > blog posts > Stack Overflow. Inline-attribute anything non-obvious.
- **Date-stamp volatile information.** APIs, versions, config defaults change. Write "as of <date>" for anything that may drift.
- **No separate Sources section.** Attribution goes inline, next to the claim. This keeps lessons self-contained and readable.
