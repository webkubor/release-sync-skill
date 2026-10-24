# Contributing

感谢你为 Release Sync 贡献。

## 改脚本

`scripts/version-sync-gate.mjs` 的**真源在 `CortexOS/scripts/release-gate/`**，这里只是副本。
改逻辑请改真源，然后跑下面命令把真源下发到所有已接入仓库：

```bash
node $CORTEXOS_ROOT/scripts/check-release-gate-sync.mjs --fix
```

## 改 SKILL.md

- 遵守 [SKILL_SPEC](../../docs/SKILL_SPEC.md)：frontmatter 必含 `name` / `description` / `version`
- 改完用 `cs skill validate <本目录>` 自检
- 打 git tag 时保持 `git tag == SKILL.md version` 强同步

## 发版

```bash
cs skill bump release-sync <patch|minor|major> --write
git tag v<新版本> && git push --tags
```