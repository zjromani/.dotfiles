# Autoresearch Changelog: zach-editor

## Eval Criteria

1. **Human-sounding** — Does it sound like a human wrote it (not AI)?
2. **No em dashes** — Are there zero em dashes (—) in the output?
3. **No bloat** — Is the output shorter or equal length to the input?
4. **Directness preserved** — Does it preserve the directness/ask without softening?
5. **Informal tone preserved** — Are sentence fragments and informal tone kept (no over-formalization)?

---

## Experiment 0 — baseline

**Score:** 29/30 (96.7%)
**Change:** None — original skill as-is
**Result:** Strong baseline. Only failure: input 6 (stream-of-thought request) got slightly longer — skill added "can you" prefix and "also" connector when splitting a run-on sentence into questions.
**Failing outputs:** Long, unstructured inputs sometimes get words added during restructuring.

---

## Experiment 1 — discard

**Score:** 29/30 (96.7%)
**Change:** Added explicit length constraint to bloat rule: "The output should always be shorter than or equal to the input — never add words, filler, or connectors that weren't there."
**Reasoning:** Expected the explicit constraint to prevent the "can you" prefix addition on input 6.
**Result:** No improvement. Input 6 still got "can you" added. The generic length instruction wasn't specific enough to prevent adding question framing. Reverted.
**Failing outputs:** Input 6 still adds "can you" prefix when restructuring imperative into question form.

---

## Experiment 2 — discard

**Score:** 29/30 (96.7%)
**Change:** Added anti-pattern: "Convert imperatives to questions — if the input says 'pull this,' keep it as 'pull this,' not 'can you pull this'"
**Reasoning:** The "Question-driven" pattern and "can you take [this]" signature phrase encourage converting imperatives to questions, adding words.
**Result:** No improvement. Input 6 still got "can you pull" and added "also, wondering if" — the model treats long run-on requests as needing question framing regardless of the anti-pattern. Reverted.
**Failing outputs:** Input 6 remains the sole failure — long stream-of-thought imperatives get restructured with added question framing.

---

## Summary — stopped early by user (token budget)

**Baseline: 29/30 (96.7%) → Final: 29/30 (96.7%)**
- 3 experiments (1 baseline + 2 mutations), 0 kept, 2 discarded
- The skill is already very strong. The only consistent failure is a narrow edge case: long, unstructured imperative sentences get "can you" prepended when the model restructures them into questions.
- This failure is likely a model behavior rather than a prompt issue — the model interprets long imperative run-ons as needing polite question framing, and two different anti-pattern approaches couldn't override it.

