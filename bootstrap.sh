#!/usr/bin/env bash
set -euo pipefail

detect_env() {
    if grep -qiE "microsoft" /proc/version 2>/dev/null; then
        echo "WSL2"
        return
    fi

    if [ -n "${PREFIX:-}" ] && echo "$PREFIX" | grep -qi "com.termux"; then
        echo "Termux"
        return
    fi

    if [ "$(uname -s)" = "Darwin" ]; then
        echo "macOS"
        return
    fi

    if [ -f /etc/debian_version ]; then
        if command -v xrandr >/dev/null 2>&1 || \
           command -v gnome-shell >/dev/null 2>&1 || \
           [ -n "${DISPLAY:-}" ]; then
            echo "Debian-UI"
        else
            echo "Debian-Console"
        fi
        return
    fi

    echo "Unknown"
}

case "$(detect_env)" in
    WSL2)           echo "Environment: WSL2" ;;
    Termux)         echo "Environment: Android Termux" ;;
    macOS)          echo "Environment: macOS" ;;
    Debian-UI)      echo "Environment: Debian with UI" ;;
    Debian-Console) echo "Environment: Debian console only" ;;
    *)              echo "Environment: Unknown" ;;
esac

