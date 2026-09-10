# Kanban Board Reference — Markdown-Based Project Tracking

**Mechanism:** Markdown file-based kanban board integrated with the Paperclip API (port 3100)

**Location:** `~/Documents/Obsidian Vault/Workspaces/Chuck/` or `/home/chuck/AIS-OS/` — any markdown file with kanban-compatible YAML frontmatter

## Board Format

Markdown files with this structure are auto-recognized:

```yaml
---
title: "Project Name"
status: "active"  # active | blocked | completed
priority: "high"  # low | medium | high
tags: [paperclip, cb-ventures]
---

## Columns (WIP → In Progress → Review → Done)

### WIP (Work in Progress)
| Issue | Title | Assignee | Status |
|-------|-------|----------|--------|
| CBV-195 | Configure Substack paid tier | Forge | ACTIVE |

### In Progress
| Issue | Title | Assignee | Status |
|-------|-------|----------|--------|
| — | — | — | — |

### Review
| Issue | Title | Assignee | Status |
|-------|-------|----------|--------|
| — | — | — | — |

### Done
| Issue | Title | Assignee | Outcome |
|-------|-------|----------|---------|
| CBV-192 | Market research: 3 niches | Scout | DONE |

## Paperclip API Integration

**Endpoint:** `POST /api/companies/{companyId}/issues` (port 3100)

**Create new issue:**
```bash
curl -X POST http://127.0.0.1:3100/api/companies/f52d2d24-5404-4d81-8ddf-bcc162670713/issues \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New task title",
    "description": "Task description",
    "status": "wip",
    "priority": "medium",
    "tags": ["paperclip", "cb-ventures"]
  }'
```

**List all issues:**
```bash
curl -s http://127.0.0.1:3100/api/issues?companyId=f52d2d24-5404-4d81-8ddf-bcc162670713
```

**Update issue status:**
```bash
curl -X PATCH http://127.0.0.1:3100/api/issues/CBV-195 \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}'
```

## Obsidian Integration

1. Place the markdown file in your Obsidian vault
2. The kanban table renders natively in Obsidian graph view
3. Backlinks show which issues are referenced in other notes
4. Tags (`#paperclip`, `#cb-ventures`) create cross-vault connections

## Daily Workflow

1. **Morning:** Open Obsidian → view kanban board → see what's WIP vs. Done
2. **During day:** Add new issues via Paperclip API or edit markdown directly
3. **End of day:** Move completed items to "Done" column
4. **Weekly:** Review board → update priorities → flag blockers

## Auth & Access

- **Local only:** Paperclip API runs on `127.0.0.1:3100` — no external auth needed
- **Obsidian vault:** Files are plain markdown — version controlled via Git if desired
- **Board health check:** `curl http://127.0.0.1:3100/api/health` ✅ (verified)

---

**Last checked:** 2026-09-08  
**Status:** ✅ Connected — markdown kanban board wired to Paperclip API