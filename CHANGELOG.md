# Changelog

All notable changes to release-sync.

## 0.1.1 - 2026-10-24

- **多仓批处理模式**：`version-sync-gate.mjs` 支持显式传目标包目录（绝对/相对路径），CI 里一次同步多个包；不加参数仍是原有默认（脚本所在目录上一级即包目录）。
- **台账改写精度修复**：按列改写而非整行重组——版本列含反引号（`` `0.1.0` ``）、作用列含干扰版本号（`0.14.0 起`）都能正确定位改写且保留单元格原格式。

## 0.1.0 - 2026-10-24

- **首次发布**：独立开源 release-sync-skill（前身 `CortexOS/skills/release-sync` 的对外形态）。
  - 发布门禁 `version-sync-gate.mjs`：发版时把 `package.json#version` 自动写进分类台账版本列 + 包内 `SKILL.md` 的 frontmatter `version`，并校验一致性（缺台账行则 exit 1）。
  - 兼容多列台账（`dsh-plugins/README.md` 的「版本 | 谁在用」）、scope 包名（`@scope/pkg`）、去 scope 目录名三种台账形态。
  - 逃生舱：`VERSION_SYNC_OFF=1`（全跳） / `VERSION_SYNC_DRY_RUN=1`（只报告）。
  - 已接入 7 个仓库的 `prepublishOnly`（两个 vite 插件 + 四个 dsh 插件 + cs-mcp）。