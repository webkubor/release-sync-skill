#!/usr/bin/env bash
# Release Sync — 一键安装（把同步门禁拷进包目录并接线 prepublishOnly）
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "用法: ./install.sh <包目录>  [--dry-run]" >&2
  echo "  把 version-sync-gate.mjs 拷进 <包目录>/scripts/ 并在 prepublishOnly 末尾接上调用。" >&2
  exit 1
fi

TARGET="${1%/}"
DRY="${2:-}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -f "$TARGET/package.json" ] || { echo "✖ $TARGET 没有 package.json" >&2; exit 1; }
mkdir -p "$TARGET/scripts"
cp "$HERE/scripts/version-sync-gate.mjs" "$TARGET/scripts/version-sync-gate.mjs"

if [ "$DRY" != "--dry-run" ] && command -v node >/dev/null 2>&1; then
  node -e "
    const fs=require('fs');
    const p='$TARGET/package.json';
    const j=JSON.parse(fs.readFileSync(p,'utf8'));
    const s=j.scripts && j.scripts.prepublishOnly;
    if (s && s.includes('version-sync-gate')) { console.log('· prepublishOnly 已接线，跳过'); process.exit(0); }
    const sep=(s&&s.trim().endsWith('&&'))?' ':(s?' && ':'');
    j.scripts = j.scripts || {};
    j.scripts.prepublishOnly = (s||'') + sep + 'node scripts/version-sync-gate.mjs';
    fs.writeFileSync(p, JSON.stringify(j, null, 2) + '\n');
    console.log('· 已把 version-sync-gate.mjs 拷入 ' + '$TARGET' + '/scripts/ 并接线 prepublishOnly');
  "
else
  echo "· 已复制脚本（跳过 package.json 改动：--dry-run 或无 node）" >&2
fi
echo "✓ 完成。跑 'node scripts/version-sync-gate.mjs' 验证。"