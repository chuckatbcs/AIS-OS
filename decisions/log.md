# Decisions Log

Append-only record of meaningful decisions and why they were made. `/level-up` Phase 2 (Method interview) writes scoped automation specs here. You can also append manually whenever you decide something worth remembering.

**Format per entry:**

```
## YYYY-MM-DD — Short title

**Decision:** what was decided.

**Why:** the reasoning, constraints, and what would change your mind.

**Alternatives considered:** what else was on the table.

**Owner:** who's accountable.
```

Keep it terse. Future-you will thank present-you for capturing the *why*, not just the *what*.

---

## 2026-09-06 - Audit evidence and routing maintenance

**Decision:** Ship audit rubric v2 and a small /link skill. Audit scores working evidence across the Four Cs, checks operating-manual routing and freshness, and passes one concrete gap into /level-up. A selected repair can improve an existing workflow instead of creating another skill.

**Why:** File counts, configured keys, named rituals, and recent edits do not prove an operational AIOS. Source findability and freshness need explicit checks.

**Alternatives considered:** Keeping presence-based scoring or requiring a hot cache. Neither reliably establishes retrieval quality or successful execution.

## 2026-09-06 - Portable skills and automatic audit history

**Decision:** Ship all four skills for Claude Code and Codex, with bundled resources, matching operating manuals, and a script for regenerating Codex copies. Audit reports are saved automatically, preserve previous runs, and track findings across comparable inspections.

**Why:** Students need the same shared guidance when switching assistants and evidence of actual improvements over time. Intentional runtime adaptations, unknown verification, and confirmed defects are reported separately.

## 2026-09-06 - Portable 3D Brain skill

**Decision:** Add `/3d-brain` for Claude Code and Codex. Ask for a name and categories, map selected local folders, and scaffold a bundled, configurable application with spherical placement, Cinema, and interactive growth replay.

**Why:** Shipping the working renderer preserves the intended appearance and interactions across AIOS installations. A prose-only prompt would produce inconsistent recreations. User config and graph data remain local; the public package includes only code, documentation, dependency notices, and fictional test inputs.

## 2026-09-06 - Add ongoing context interviews

**Decision:** Adapt Herk-2's grill-me skill for the student kit and ship matching Claude/Codex packages. Save every answer to brainstorms/, preserve resumable Q&A history, and update canonical context only with confirmed facts during requested context-building sessions.

**Why:** Onboarding is an initial snapshot. Ongoing interviews capture changing priorities, decisions, and preferences while keeping tentative ideas distinct from current business facts.

---

## 2026-09-10 — TrueNAS mount repair + peer recovery runbook

**Decision:** Fix broken TrueNAS SMB mounts and write a Hermes peer/Tailscale recovery runbook to reduce rebuild frequency.

**Why:** User spends more time fixing the system than using it. Peer connections and Tailscale settings break repeatedly, causing downtime. The user's explicit diagnosis: "I spend more time fixing the system than using it." Two concrete fixes applied:
1. Removed dangling GVFS symlink at `/mnt/public`, mounted `//truenas-scale/public` and `//truenas-scale/Home-Directories` via CIFS using `/root/.smbcredentials`, added persistent `/etc/fstab` entries with `nofail`.
2. Created `references/hermes-peer-recovery.md` — a step-by-step runbook covering Tailscale down, API server down, peer registration lost, and best-practice rules to prevent breaks.

**Evidence:** Both mounts verified working (`ls /mnt/public/` shows AIS-OS, Media Files, Scripts, ISOs; `ls /mnt/Home-Directories/` shows Backups, Desktop, Documents, etc.). Fstab entries confirmed via `cat /etc/fstab`.

**Alternatives considered:** Automating the peer setup with a skill (rejected — user wants documentation and user education first, not more automation). Mounting via systemd automount (rejected — simpler to use fstab with nofail).

**Owner:** Chuck Blackmon (runbook + mounts), promax Hermes (fstab persistence)
