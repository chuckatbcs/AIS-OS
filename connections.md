# Connections

Registry of every system the AIOS can reach. Filled by `/onboard` from Q4-Q7 answers; expanded over time as new tools are wired up. `/audit` checks this file for domain coverage and freshness.

| # | Domain | Tool | Mechanism | Auth | Last checked |
|---|---|---|---|---|---|
| 1 | Revenue / Financials | Stripe (planned) | not yet connected | — | — |
| 2 | Customer interactions | Email (cbventures.co@gmail.com) | himalaya CLI (IMAP/SMTP) | app password | 2026-09-08 |
| 3 | Calendar | (not specified) | not yet connected | — | — |
| 4 | Communication | Email, Teams, person-to-person | himalaya CLI (IMAP/SMTP) | app password | 2026-09-08 |
|| 5 | Project / task tracking | AI chats, email, **kanban board (markdown)** | file-based kanban (markdown) + Paperclip API (on pcgamer) | 2026-09-10 |
| 6 | Meeting intelligence | None (async only) | not yet connected | — | — |
| 7 | Knowledge / files | Obsidian, email | file-based (read/write vault at `~/Documents/Obsidian Vault/Workspaces/Chuck/`) | — | 2026-09-08 |

**Mechanism options:** `mcp` (MCP server), `script` (Python/Bash hitting an API, in `scripts/`), `export` (CSV/JSON dump pipeline), `key+ref` (`.env` key + `references/{tool}-api.md` guide), `not yet connected`.

When wiring a new tool, also save `references/{tool}-api.md` capturing endpoints, auth flow, and common queries — researched-once-saved-forever.
