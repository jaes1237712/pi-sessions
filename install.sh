#!/usr/bin/env bash
# Configure this checkout as Pi's shared session store.
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
bin_dir="$HOME/.local/bin"
bashrc="$HOME/.bashrc"
marker_begin="# >>> pi-sessions >>>"
marker_end="# <<< pi-sessions <<<"
old_marker_begin="# >>> pi-sessions completion >>>"
old_marker_end="# <<< pi-sessions completion <<<"

mkdir -p "$bin_dir" "$repo_root/sessions"
chmod +x "$repo_root/bin/sync-sessions"
ln -sfn "$repo_root/bin/sync-sessions" "$bin_dir/sync-sessions"

# Remove commands from the old per-device/import design.
rm -f "$bin_dir/sync-desktop" "$bin_dir/sync-laptop" "$bin_dir/import-project-sessions"

touch "$bashrc"
tmp=$(mktemp)
awk -v begin="$marker_begin" -v end="$marker_end" \
    -v old_begin="$old_marker_begin" -v old_end="$old_marker_end" '
  $0 == begin || $0 == old_begin { skipping = 1; next }
  $0 == end || $0 == old_end { skipping = 0; next }
  $0 == "# Pi session storage (device-specific)" { next }
  $0 ~ /^[[:space:]]*export PI_CODING_AGENT_SESSION_DIR=/ { next }
  !skipping { print }
' "$bashrc" > "$tmp"
mv "$tmp" "$bashrc"

cat >> "$bashrc" <<EOF

$marker_begin
# Added by $repo_root/install.sh
export PI_CODING_AGENT_SESSION_DIR="$repo_root/sessions"
$marker_end
EOF

echo "Pi session directory: $repo_root/sessions"
echo "Installed command: $bin_dir/sync-sessions"
echo "Reload this shell before starting Pi: source ~/.bashrc"
