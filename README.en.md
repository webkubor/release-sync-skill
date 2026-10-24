# 🔄 Release Sync

<p align="center">
  <a href="https://github.com/webkubor/release-sync-skill/releases"><img src="https://img.shields.io/github/v/release/webkubor/release-sync-skill?style=for-the-badge&color=3fb950&label=release" alt="release" /></a>
  <a href="https://github.com/webkubor/release-sync-skill"><img src="https://img.shields.io/badge/skill-version-0.1.1-646cff?style=for-the-badge" alt="skill version" /></a>
  <img src="https://img.shields.io/badge/node-%3E%3D18-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="node" />
  <img src="https://img.shields.io/badge/license-MIT-777?style=for-the-badge" alt="MIT" />
</p>

<p align="center">
  <strong>Keep version numbers in sync everywhere, automatically, at publish time.</strong><br>
  On release, write <code>package.json</code>'s version into your <b>category ledger</b> and <b>SKILL.md</b> frontmatter —<br>
  and verify consistency, so docs never drift behind the code again.
</p>

> English | [中文](./README.md)

---

## Why This

| | Manual docs edits | Validate-only | **release-sync** |
|---|---|---|---|
| Ledger / SKILL version auto-updates on release | ❌ always forgotten | ❌ reports only | ✅ rewrites |
| Blocks publish when package isn't in the ledger | ❌ | ⚠️ partial | ✅ exit 1 |
| Enforces tag == SKILL version sync | ❌ by habit | ⚠️ | ✅ machine-checked |
| Batch multiple packages / CI-friendly | — | ⚠️ | ✅ pass a path |
| Change once, propagate everywhere | — | — | ✅ canonical source |

**In one line**: turn "version numbers live in N places and always go stale" into a machine-checked
release gate — sync them on publish, or fail the publish.

---

## The problem

Code moves to `0.15.1`, but:

- the **category ledger** (`vite-plugins/README.md` version column) still shows the old version
- the package's own `SKILL.md` `version:` is even older
- `cs skill validate` goes red, and nobody can tell which version is installed

The root cause is not laziness — **nothing turns red when docs go stale**. release-sync makes
"docs version must equal `package.json`" a mechanical check: rewrite on release, fail otherwise.

## What it does

On publish (before `npm publish` / on `v*` tag), writes `package.json#version` into:

| Target | What | If missing |
|---|---|---|
| **Ledger version column** | the package's row in `<pkg>/../README.md` | row absent → exit 1, block publish |
| **SKILL.md frontmatter `version:`** | the package's own skill version (SKILL_SPEC strong-sync rule) | no SKILL.md → skip, not an error |

**It never touches** "feature-introduced-version" marks like `0.10.0+` in docs — those are
historical facts and must NOT follow the release. Use a live npm badge
(`img.shields.io/npm/v/<pkg>`) for "latest".

**Idempotent**: re-running with the same version produces no diff.

---

## Install

### Option A — one-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/webkubor/release-sync-skill/main/install.sh | bash -s -- <your-package-dir>
```

Copies the script into `<pkg>/scripts/` and wires it into `prepublishOnly`.

### Option B — manual

```bash
cp scripts/version-sync-gate.mjs <pkg>/scripts/
```

`<pkg>/package.json`:

```json
"prepublishOnly": "npm run build && node scripts/prepublish-gate.mjs && node scripts/readme-gate.mjs && node scripts/version-sync-gate.mjs"
```

---

## Usage

```bash
# inside a package (default target = one level above scripts/)
node scripts/version-sync-gate.mjs

# explicit target package (batch / CI)
node scripts/version-sync-gate.mjs /abs/path/to/package
node scripts/version-sync-gate.mjs ./relative/pkg

# report only, don't write (audit)
VERSION_SYNC_DRY_RUN=1 node scripts/version-sync-gate.mjs

# escape hatch: skip everything
VERSION_SYNC_OFF=1 node scripts/version-sync-gate.mjs
```

**Batch in CI**:

```bash
for p in ./packages/a ./packages/b ./packages/c; do
  node scripts/version-sync-gate.mjs "$p" || exit 1
done
```

---

## Ecosystem

| Piece | Note |
|---|---|
| `SKILL.md` / `scripts/` | the skill + sync script (canonical source in CortexOS; one change, sync everywhere) |
| `install.sh` | one-click onboarding (copy + wire prepublishOnly) |
| CHANGELOG / Release | `v*` tag auto-builds a release and **enforces tag == SKILL version** |
| Companion gates | `prepublish-gate` (artifact/CHANGELOG), `readme-gate` (README first-screen) — same CortexOS release-gate suite |

Already wired into **7 real repositories** (2 Vite plugins + 4 dsh plugins + cs-mcp), covering
multi-column ledgers / scoped package names / no-ledger layouts.

## License

MIT — see [LICENSE](./LICENSE). Issues & PRs welcome.