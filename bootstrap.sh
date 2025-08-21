#!/usr/bin/env bash
set -euo pipefail

# Detect WSL2
is_wsl2() {
    grep -qiE "microsoft" /proc/version 2>/dev/null
}

# Detect Debian
is_debian() {
    [ -f /etc/debian_version ]
}

# Detect if GUI available
has_gui() {
    command -v xrandr >/dev/null 2>&1 || command -v gnome-shell >/dev/null 2>&1 || [ -n "${DISPLAY:-}" ]
}

### MAIN
if is_wsl2; then
    echo "Environment: WSL2"
elif is_debian; then
    if has_gui; then
        echo "Environment: Debian with UI"
    else
        echo "Environment: Debian console only"
    fi
else
    echo "Environment: Unknown"
fi

