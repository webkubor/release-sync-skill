---
name: release-sync
description: "Vite/Node 包发版时的『版本号 → 文档』自动同步。发新版时把 package.json 的 version 自动写进分类台账（如 vite-plugins/README.md 版本列）和包内 SKILL.md 的 frontmatter version，并校验一致性，从根上消除『代码迭代了、文档/台账/SKILL 版本还停在旧版』的老化。触发条件: 准备 npm publish 发新版、打 v* tag、发版后发现台账或 SKILL 版本滞后、要审计哪些文档版本号落后时触发。触发词: 发版、发布、publish、版本同步、版本号同步、台账同步、SKILL version 同步、release-sync、version-sync。"
version: 0.1.1
license: MIT
author: webkubor
category: devops
platforms: [linux, macos]
url: https://github.com/webkubor/CortexOS
metadata:
  openclaw:
    tags: [release, version, sync, publish, skill-version, changelog]
    requires:
      bins: [node]
---

# Release Sync — 发版版本号自动同步

> 本仓已独立开源（`webkubor/release-sync-skill`）；CortexOS 内保留登记形态（`CortexOS/skills/release-sync/`），
> 真源脚本在 `CortexOS/scripts/release-gate/`，由 `check-release-gate-sync --fix` 下发到各仓。

## 概述

Vite/Node 包发新版本时，把 `package.json` 里的 `version` 自动写进所有「记录当前版本」的文档，并校验一致性。解决最常见的老化：代码迭代了新版本，但分类台账（`vite-plugins/README.md` 版本列）、包自带 `SKILL.md` 的 `version` 还停在旧版本——`cs skill validate` 因此标红，人类/agent 也分不清装的是不是最新。

本 Skill 把「多个版本号位置对齐」这个约定做成可执行脚本，挂进 `prepublishOnly`，发版即同步、同步即校验。它区分两类版本号并**只动该动的那类**（见「使用说明」）。

## 触发条件

- 准备 `npm publish` 发新版、或打 `v*` tag 时，希望台账和 SKILL 版本跟着走
- 发版后有人发现 `vite-plugins/README.md` 版本列、或某仓库 `SKILL.md` 的 `version` 滞后于 `package.json`
- 要审计「目前哪些仓库的文档版本号落后了、落后到多少」
- 给一个新的 npm 包接入发版门禁时，把本脚本一并接上

## 快速开始

```bash
# 在包目录里直接跑（读该目录的 package.json）
node scripts/version-sync-gate.mjs

# 只报告、不改写（首次接入 / 审计推荐）
VERSION_SYNC_DRY_RUN=1 node scripts/version-sync-gate.mjs

# 显式指定目标包目录（多仓批处理 / CI）
node scripts/version-sync-gate.mjs /绝对/路径/到/包   # 或 相对路径
```

## 使用说明

新增一个包要接入时，两步：

1. 把 `scripts/version-sync-gate.mjs` 拷进包目录的 `scripts/`（真源在 `CortexOS/scripts/release-gate/`，用同步脚本下发）；默认以脚本所在目录的上一级为包目录，也可传参数指向任意包目录
2. 在 `package.json#scripts.prepublishOnly` 末尾接上：

```json
"prepublishOnly": "npm run build && node scripts/prepublish-gate.mjs && node scripts/readme-gate.mjs && node scripts/version-sync-gate.mjs"
```

脚本做的三件事：

| 动作 | 目标 | 找不到怎么办 |
|---|---|---|
| 台账版本列同步 | `<包目录>/../README.md`（分类台账）里对应插件行的版本号 → 当前 version | 找不到该行 → exit 1 拦下（插件没登记进台账） |
| SKILL.md version 同步 | 包根 `SKILL.md` 的 frontmatter `version:` → 当前 version | 无 SKILL.md 或无 version 字段 → 跳过/提示，不拦 |
| 一致性校验 | 幂等可重复，不产生无意义 diff | — |

**它不碰什么**：文档/文档站里 `0.10.0+`、`0.14.0+` 这类「功能引入版本」标记属于历史事实，**坚决不改写**。真正的「当前最新版」应走 npm 实时徽章（`img.shields.io/npm/v/<pkg>`），不该写死。

## 环境要求

- Node.js（脚本为 `.mjs`，需 ESM）
- 可选：`CortexOS` 的 `check-release-gate-sync.mjs --fix` 用于把真源下发到各仓
- 可选环境变量：
  - `VERSION_SYNC_OFF=1` — 全跳过
  - `VERSION_SYNC_DRY_RUN=1` — 只报告不改写

## 常见问题

- **门禁报「台账里找不到对应行」**：插件没登记进分类台账（如 `vite-plugins/README.md` 表格），先按其 README 的登记步骤补一行。
- **它会不会改了文档站的功能标记**：不会，见「使用说明」的边界说明——只动台账版本列和 SKILL version。

## 相关 Skills

- `cs-pay` — CS 体系里同类的「统一入口 + 底层脚本」形态参考
- 发布门禁配套：`CortexOS/scripts/release-gate/prepublish-gate.mjs`（产物/CHANGELOG 门禁）、`readme-gate.mjs`（README 首屏门禁）