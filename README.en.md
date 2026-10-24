# Release Sync Skill

> **Release Sync — keep version numbers in sync everywhere, automatically, at publish time.**

## What it does

When you publish a new version of a Vite/Node package, the release gate (`version-sync-gate.mjs`)
automatically writes the `package.json` version into:

- the **ledger version column** of your repo category README (e.g. `vite-plugins/README.md`)
- the **frontmatter `version:`** of the package's own `SKILL.md` (if present)

…and verifies consistency — if the package is not registered in the ledger, publishing fails.

It kills the most common kind of doc drift: code moves to a new version, but the ledger / SKILL
version stays old, so `cs skill validate` stays red and nobody can tell which version is installed.

Two kinds of version numbers exist in docs, and this gate only touches the right one:

| Kind | Example | Semantics | This gate |
|---|---|---|---|
| **current-version records** | ledger column, `SKILL.md` `version:` | the package version, must follow code | ✅ auto-updates |
| **feature-introduced-version marks** | `0.10.0+` in docs site | historical fact, must NOT follow code | ❌ never touches |

For "latest release" badges use the npm live badge (`img.shields.io/npm/v/<pkg>`) — don't hardcode.

## Install & use

**Option A — one-off (no wiring):**

```bash
# copy the script into your package
cp version-sync-gate.mjs <your-package>/scripts/

# run it there (reads package.json in cwd)
node scripts/version-sync-gate.mjs

# report only, don't write (audit)
VERSION_SYNC_DRY_RUN=1 node scripts/version-sync-gate.mjs
```

**Option B — wire into publish (recommended):**

```json
"prepublishOnly": "npm run build && node scripts/prepublish-gate.mjs && node scripts/readme-gate.mjs && node scripts/version-sync-gate.mjs"
```

Then `npm publish` (locally) and tag-based CI both run it automatically.

**Escape hatches:**

- `VERSION_SYNC_OFF=1` — skip everything
- `VERSION_SYNC_DRY_RUN=1` — report only, never write

## How it finds the ledger

- Located at `<package>/../README.md` (the category README one level above the package dir).
- Finds the table row that names the package (supports scoped names `@scope/pkg` and
  unscoped `pkg`), then finds the **pure-semver cell** after the package-name cell and rewrites it.
- Works with multi-column ledgers (version column + extra columns like "who uses it").
- No parent ledger / no SKILL.md ⇒ skips that check silently (not an error).

## Requirements

- Node.js (ESM, `.mjs`)

## Changelog

See [CHANGELOG.md](./CHANGELOG.md).

## License

MIT — see [LICENSE](./LICENSE).

## Ecosystem

- Canonical source of the script: **CortexOS** (`CortexOS/scripts/release-gate/`),
  distributed via `check-release-gate-sync.mjs --fix`.
- Companion release gates: `prepublish-gate.mjs` (artifact/CHANGELOG), `readme-gate.mjs`
  (README first-screen packaging).