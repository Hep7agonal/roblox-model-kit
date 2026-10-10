#!/usr/bin/env bash
# Installs Lune for CI / Claude Code on the web (Linux x86_64).
set -euo pipefail
LUNE_VERSION="${LUNE_VERSION:-0.9.3}"
if command -v lune >/dev/null 2>&1; then lune --version; exit 0; fi
mkdir -p "$HOME/.local/bin"
curl -fsSL -o /tmp/lune.zip "https://github.com/lune-org/lune/releases/download/v${LUNE_VERSION}/lune-${LUNE_VERSION}-linux-x86_64.zip"
unzip -o -q /tmp/lune.zip -d "$HOME/.local/bin"
chmod +x "$HOME/.local/bin/lune"
if [ -n "${GITHUB_PATH:-}" ]; then echo "$HOME/.local/bin" >> "$GITHUB_PATH"; fi
export PATH="$HOME/.local/bin:$PATH"
lune --version
