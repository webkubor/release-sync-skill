# Release Sync Skill

<p align="center">
  <img src="https://img.shields.io/badge/Skill-release--sync-0.1.1-3fb950?style=for-the-badge" alt="skill version" />
  <a href="https://github.com/webkubor/release-sync-skill/releases"><img src="https://img.shields.io/github/v/release/webkubor/release-sync-skill?style=for-the-badge&color=6d7f9c&label=release" alt="release" /></a>
  <a href="https://github.com/webkubor/release-sync-skill/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-777?style=for-the-badge" alt="MIT" /></a>
</p>

发版时自动同步「版本号 → 文档」：把 `package.json` 的版本写进**分类台账版本列**和**包内 `SKILL.md` 的 frontmatter version**，并校验一致性。解决最常见的老化：代码迭代了新版本，但台账 / SKILL 版本还停在旧版——`cs skill validate` 因此标红，agent 也分不清装的是不是最新。

隶属 **CortexOS**（你的 CS 决策中心）的工具型 Skill，真源脚本与发布门禁套件同源：
`CortexOS/scripts/release-gate/version-sync-gate.mjs`。

## 使用

```bash
# 在要发版的包目录里
node scripts/version-sync-gate.mjs

# 只报告不改写（首次接入 / 审计）
VERSION_SYNC_DRY_RUN=1 node scripts/version-sync-gate.mjs

# 显式指定目标包目录（多仓批处理 / CI）
node scripts/version-sync-gate.mjs /绝对/路径/到/包
node scripts/version-sync-gate.mjs ./relative/pkg
```

接入方式见 [SKILL.md](./SKILL.md)。

## 组成

| 文件 | 说明 |
|---|---|
| `SKILL.md` | Skill 唯一入口（任何 Agent 从这里读起；frontmatter 含 `name`/`description`/`version`） |
| `scripts/version-sync-gate.mjs` | 同步门禁脚本（拷贝，真源在 CortexOS） |
| `LICENSE`（MIT） / `CONTRIBUTING.md` | 开源仓骨架 |

## 迭代节奏（跟 CS 体系）

- 改脚本/边界 → `patch`
- 加可选能力 / 兼容新输入 → `minor`
- 破坏性改动（接口变更）→ `major`
- 打 git tag 时保持 **git tag == SKILL.md version** 强同步（`cs skill bump` 同步 version 字段）

## 关联

- **CortexOS**：`CortexOS/skills/release-sync/`（本仓在 CS 内的登记形态） · `CortexOS/scripts/release-gate/`（真源）
- 配套发布门禁：`prepublish-gate.mjs`（产物/CHANGELOG）、`readme-gate.mjs`（README 首屏）
- **SKILL_SPEC**：`CortexOS/docs/SKILL_SPEC.md`（SKILL 规范 + 外部仓版本强同步 SOP）