# Epic Verification

## Core Principle

Epics are NOT thematic buckets. Only suggest an epic when the ticket **directly contributes** to that epic's stated acceptance criteria or scope. See [/atribui-epics](../../atribui-epics/SKILL.md) for the full rationale.

## Rules

- **Bugs do not need an Epic** — skip this check for Bug type tickets
- **Tickets with `no-epic-needed` label** — skip this check, they were already triaged
- Only suggest epics whose statusCategory is NOT Done
- Thematic similarity alone is NOT enough — the ticket must fulfill an acceptance criterion
- When in doubt, flag as "sem epic (ok)" rather than suggesting a weak match

## How to Check

### 1. Verify if ticket already has a parent

```bash
jira issue view TICKET-KEY --raw 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); p=d.get('fields',{}).get('parent'); print(f'Parent: {p[\"key\"]} ({p[\"fields\"][\"summary\"]})' if p else 'No parent')"
```

### 2. If no parent and not a Bug, fetch open epics dynamically

```bash
jira issue list -q 'project = HYPERFLEET AND issuetype = Epic AND statusCategory != Done' --plain --no-headers --columns key,summary,status --no-truncate 2>/dev/null
```

### 3. Compare ticket scope against epic acceptance criteria

For candidate epics, read their acceptance criteria:

```bash
jira issue view EPIC-KEY --plain 2>/dev/null
```

Only suggest the epic if the ticket directly contributes to one of the epic's acceptance criteria.

### 4. Status values for the criteria table

- **ok** — ticket has a parent epic, or is a Bug, or has label `no-epic-needed`
- **alerta** — no parent and no `no-epic-needed` label, but a matching epic was found (suggest it)
- **erro** — no parent, no label, and the ticket clearly should belong to an existing epic based on AC match
- **ok (sem epic)** — no parent, no label, but no epic's AC matches — this is fine
