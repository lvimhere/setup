# Shared environment for native Linux + WSL (fish).
# From ~/.config/fish/config.fish:
#   set -q SETUP_ROOT; or set -gx SETUP_ROOT $HOME/setup
#   test -f $SETUP_ROOT/.config/shell/env.fish; and source $SETUP_ROOT/.config/shell/env.fish

if not set -q SETUP_ROOT
    set -gx SETUP_ROOT (dirname (dirname (status dirname)))
end

fish_add_path -m $HOME/.local/bin

if not set -q EDITOR
    set -gx EDITOR nvim
end
if not set -q VISUAL
    set -gx VISUAL $EDITOR
end

if not set -q XDG_RUNTIME_DIR; or not test -d $XDG_RUNTIME_DIR; or not test -w $XDG_RUNTIME_DIR
    set -gx XDG_RUNTIME_DIR $HOME/.cache/xdg-runtime
    mkdir -p $XDG_RUNTIME_DIR
    chmod 700 $XDG_RUNTIME_DIR
end

if not set -q ZELLIJ_SOCKET_DIR
    set -gx ZELLIJ_SOCKET_DIR $HOME/.cache/zellij-sock
end
mkdir -p $ZELLIJ_SOCKET_DIR
chmod 700 $ZELLIJ_SOCKET_DIR

if test -x $SETUP_ROOT/.config/shell/clipcopy
    mkdir -p $HOME/.local/bin
    ln -sfn $SETUP_ROOT/.config/shell/clipcopy $HOME/.local/bin/clipcopy
end

if test -x "/mnt/c/Program Files/Neovim/bin/win32yank.exe"
    mkdir -p $HOME/.local/bin
    ln -sfn "/mnt/c/Program Files/Neovim/bin/win32yank.exe" $HOME/.local/bin/win32yank.exe
end

# Per-directory tool versions. Skip if config.fish already activated.
if status is-interactive; and command -v mise >/dev/null; and not set -q MISE_SHELL
    mise activate fish | source
end

# Optional: skip silently when zoxide is not installed.
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# Starship prompt (overrides CachyOS fish prompt when installed).
if status is-interactive; and command -v starship >/dev/null
    starship init fish | source
end

# Official Yazi wrapper: `q` cds to last dir, `Q` keeps the original cwd.
if command -v yazi >/dev/null
    function y --description "Yazi; q cds here, Q keeps the original directory"
        set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if test -s "$tmp"
            read -lz cwd < "$tmp"
            if test -n "$cwd" -a "$cwd" != "$PWD" -a -d "$cwd"
                builtin cd -- "$cwd"
            end
        end
        command rm -f -- "$tmp"
    end
end
