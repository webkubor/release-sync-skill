# 🔄 Release Sync

<p align="center">
  <a href="https://github.com/webkubor/release-sync-skill/releases"><img src="https://img.shields.io/github/v/release/webkubor/release-sync-skill?style=for-the-badge&color=3fb950&label=release" alt="release" /></a>
  <a href="https://github.com/webkubor/release-sync-skill"><img src="https://img.shields.io/badge/skill-version-0.1.1-646cff?style=for-the-badge" alt="skill version" /></a>
  <img src="https://img.shields.io/badge/node-%3E%3D18-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="node" />
  <img src="https://img.shields.io/badge/license-MIT-777?style=for-the-badge" alt="MIT" />
</p>

<p align="center">
  <strong>发版一次，版本号全仓同步。</strong><br>
  发新版时自动把 <code>package.json</code> 的版本写进 <b>分类台账</b> 和 <b>SKILL.md</b> 的 frontmatter，<br>
  并校验一致性 —— 文档不会再比代码老。
</p>

<p align="center">
  <a href="#install-安装">安装</a> · <a href="#为什么需要它">为什么需要它</a> · <a href="#它做什么">它做什么</a> · <a href="#使用">使用</a> · <a href="#平台建议">生态</a>
</p>

---

## Why This

| | 手改文档 | 只校验不自动 | **release-sync** |
|---|---|---|---|
| 台账/SKILL 版本随发版自动同步 | ❌ 每次手改、必漏 | ❌ 只报不变 | ✅ 发版即改 |
| 发版时拦住「没登记进台账」 | ❌ | ⚠️ 部分 | ✅ exit 1 拦下 |
| 与大版本强同步（tag == SKILL version） | ❌ 靠自觉 | ⚠️ | ✅ 机器校验 |
| 多仓批处理 / CI 可跑 | — | ⚠️ | ✅ 传参即可 |
| 改一次，所有仓库生效 | — | — | ✅ 真源下发 |

**一句话**：把「版本号散在 N 处、发版必漏」这个约定，变成「发版时机器帮你对一遍、不对就拦」。

---

## 为什么需要它

代码迭代到 `0.15.1` 了，但——

- `vite-plugins/README.md` 台账版本列还停在上个版本
- 包自带的 `SKILL.md` 的 `version:` 还停在更早
- 于是 `cs skill validate` 标红，agent / 协作方分不清装的是不是最新

这不是懒，是**没有人因为文档旧了而变红**。release-sync 把「文档版本必须等于 package.json」做成机械判据：发版时自动改写，改不动就拦。

---

## 它做什么

发版（`npm publish` 前 / 推 `v*` tag）时，自动把 `package.json#version` 写进：

| 位置 | 说明 | 找不到怎么办 |
|---|---|---|
| **分类台账版本列** | `<包>/../README.md`（如 `vite-plugins/README.md`）里对应插件行的版本号 | 该行不存在 → exit 1 拦下发布 |
| **SKILL.md frontmatter `version:`** | 包自带 skill 的版本字段（SKILL_SPEC 强同步规则） | 无 SKILL.md → 跳过，不拦 |

**它不碰**：文档站里 `0.10.0+` / `0.14.0+` 这类「功能引入版本」标记——那是历史事实，随发版更新反而是错的。「最新版」应走 npm 实时徽章，不该写死。

**幂等**：重复跑（同样版本）不产生任何 diff。

---

## Install 安装

### 方式一：一键脚本（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/webkubor/release-sync-skill/main/install.sh | bash -s -- <你的包目录>
# 或本地：./install.sh <你的包目录>
```

自动把脚本拷进 `<包>/scripts/`，并在 `prepublishOnly` 末尾接上调用。

### 方式二：手动两步

```bash
cp scripts/version-sync-gate.mjs <包>/scripts/
```

`<包>/package.json`：

```json
"prepublishOnly": "npm run build && node scripts/prepublish-gate.mjs && node scripts/readme-gate.mjs && node scripts/version-sync-gate.mjs"
```

---

## 使用

```bash
# 在包目录里（默认 = 脚本所在目录上一级）
node scripts/version-sync-gate.mjs

# 显式指定目标包目录（多仓批处理 / CI）
node scripts/version-sync-gate.mjs /绝对/路径/到/包
node scripts/version-sync-gate.mjs ./relative/pkg

# 只报告不改写（首次接入审计）
VERSION_SYNC_DRY_RUN=1 node scripts/version-sync-gate.mjs

# 逃生舱：全跳过
VERSION_SYNC_OFF=1 node scripts/version-sync-gate.mjs
```

**CI 多仓批量**：

```bash
node scripts/version-sync-gate.mjs ./packages/a
node scripts/version-sync-gate.mjs ./packages/b   # 可在发布循环里依次跑
```

---

## 生态

| 组件 | 说明 |
|---|---|
| `SKILL.md` / `scripts/` | Skill 本体 + 同步脚本（真源在 CortexOS，一套改、全仓更新） |
| `install.sh` | 一键接入（拷贝 + 接线 prepublishOnly） |
| CHANGELOG / Release | 推 `v*` tag 自动建 Release，并校验 **tag == SKILL version** 强同步 |
| 配套门禁 | `prepublish-gate`（产物/CHANGELOG 完整性）、`readme-gate`（README 首屏包装）——同为 CortexOS 发布门禁套件 |

已在 **7 个真实仓库**接入（两个 Vite 插件 + 四个 dsh 插件 + cs-mcp），覆盖多列表格台账 / scope 包名 / 无台账三类形态。

## License

MIT — 见 [LICENSE](./LICENSE)。欢迎 [提 Issue](https://github.com/webkubor/release-sync-skill/issues) 或 PR。