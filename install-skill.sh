#!/usr/bin/env bash
# Install this skill into the detected agent skill directories.
# Keep install.sh free for a package-specific installer, such as release-sync.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$HERE/scripts/install_skill.py" "$@"
