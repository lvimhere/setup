# Shared environment for native Linux + WSL (bash/zsh).
# From ~/.bashrc or ~/.zshrc:
#   SETUP_ROOT="${SETUP_ROOT:-$HOME/Projects/setup}"
#   [[ -f "$SETUP_ROOT/.config/shell/env.sh" ]] && . "$SETUP_ROOT/.config/shell/env.sh"

if [ -n "${BASH_SOURCE[0]:-}" ]; then
  _setup_shell_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${ZSH_VERSION:-}" ]; then
  # shellcheck disable=SC2296
  _setup_shell_dir="$(cd -- "$(dirname -- "${(%):-%x}")" && pwd)"
else
  _setup_shell_dir="${SETUP_ROOT:-${HOME}/Projects/setup}/.config/shell"
fi
_setup_root="$(cd -- "${_setup_shell_dir}/../.." && pwd)"
export SETUP_ROOT="${SETUP_ROOT:-$_setup_root}"
unset _setup_shell_dir _setup_root

export PATH="${HOME}/.local/bin:${PATH}"

# WSL often exports XDG_RUNTIME_DIR=/run/user/$UID without creating it.
# Zellij (and other IPC clients) then panic with PermissionDenied.
if [ -z "${XDG_RUNTIME_DIR:-}" ] || [ ! -d "$XDG_RUNTIME_DIR" ] || [ ! -w "$XDG_RUNTIME_DIR" ]; then
  export XDG_RUNTIME_DIR="${HOME}/.cache/xdg-runtime"
  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR"
fi

export ZELLIJ_SOCKET_DIR="${ZELLIJ_SOCKET_DIR:-${HOME}/.cache/zellij-sock}"
mkdir -p "$ZELLIJ_SOCKET_DIR"
chmod 700 "$ZELLIJ_SOCKET_DIR"

# Keep clipcopy on PATH for Zellij copy_command.
if [ -x "$SETUP_ROOT/.config/shell/clipcopy" ]; then
  mkdir -p "${HOME}/.local/bin"
  ln -sfn "$SETUP_ROOT/.config/shell/clipcopy" "${HOME}/.local/bin/clipcopy"
fi

# win32yank: Windows Neovim path has spaces; Neovim executable() often misses it.
if [ -x "/mnt/c/Program Files/Neovim/bin/win32yank.exe" ]; then
  mkdir -p "${HOME}/.local/bin"
  ln -sfn "/mnt/c/Program Files/Neovim/bin/win32yank.exe" "${HOME}/.local/bin/win32yank.exe"
fi

# Interactive-only conveniences (bash/zsh)
case $- in
  *i*)
    if [ -r /proc/version ] && grep -qi microsoft /proc/version 2>/dev/null; then
      if [ -x /usr/bin/curl ]; then
        alias curl='/usr/bin/curl'
      elif [ -x /usr/sbin/curl ]; then
        alias curl='/usr/sbin/curl'
      fi
    fi
    ;;
esac
