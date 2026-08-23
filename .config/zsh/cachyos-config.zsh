# Based on /usr/share/cachyos-zsh-config/cachyos-config.zsh
# (cachyos-zsh-config 1.0.3-1). Powerlevel10k is omitted: Starship is the prompt.
# Do not edit the package file under /usr/share — pacman upgrades overwrite it.

# Path to your oh-my-zsh installation.
export ZSH="/usr/share/oh-my-zsh"
export FZF_BASE=/usr/share/fzf

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Vim keymap (OMZ lib/key-bindings.zsh would otherwise set emacs).
# KEYTIMEOUT=1 makes Esc leave insert quickly; do not rely on Esc Esc for sudo.
bindkey -v
KEYTIMEOUT=1
VI_MODE_SET_CURSOR=true

# Starship shows vicmd via vimcmd_symbol; keep OMZ vi-mode from filling RPS1.
RPS1=""
RPROMPT=""

# vi-mode first so later plugins (fzf) can rebind Ctrl-R etc.
# sudo: Alt-S (see binds below). extract: `x` / `extract`.
[[ -z "${plugins[*]}" ]] && plugins=(vi-mode git fzf extract sudo)

source $ZSH/oh-my-zsh.sh

unset RPS1

# zsh-native history (OMZ already sets share_history / hist_ignore_space / hist_ignore_dups).
# Drop bash leftovers that /etc/profile or a parent shell may have exported.
unset HISTCONTROL PROMPT_COMMAND
HISTORY_IGNORE="(c|clear|history|exit|q|pwd|bg|fg|ls|ll|la)"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Use custom `less` colors for `man` pages.
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# --- aliases ---

alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"
alias n="ninja"
alias c="clear"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"

# Help people new to Arch
alias apt="man pacman"
alias apt-get="man pacman"
alias please="sudo"
alias tb="nc termbin.com 9999"

# Orphans resolved at run time (the old alias expanded $(pacman -Qtdq) at source).
cleanup() {
  local orphans
  if ! orphans="$(pacman -Qtdq 2>/dev/null)"; then
    print "No orphaned packages."
    return 0
  fi
  sudo pacman -Rns ${=orphans}
}

alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

if (( $+commands[eza] )); then
  alias ls="eza -al --color=always --group-directories-first --icons=always"
  alias la="eza -a --color=always --group-directories-first --icons=always"
  alias ll="eza -l --color=always --group-directories-first --icons=always"
  alias lt="eza -aT --color=always --group-directories-first --icons=always"
  alias l.="eza -ad --color=always --group-directories-first --icons=always .*"
fi

# --- completions / widgets (order: fzf-tab, then wrapping plugins) ---

if [[ -r /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
  zstyle ":completion:*:git-checkout:*" sort false
  zstyle ":completion:*:descriptions" format "[%d]"
  zstyle ":completion:*" menu no
  zstyle ":fzf-tab:*" switch-group "<" ">"
  if (( $+commands[eza] )); then
    zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -1 --color=always \$realpath"
    zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "eza -1 --color=always \$realpath"
  fi
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Substring history: type a fragment, then Up/Down (insert) or j/k (normal).
bindkey -M viins "^[[A" history-substring-search-up
bindkey -M viins "^[[B" history-substring-search-down
bindkey -M vicmd "^[[A" history-substring-search-up
bindkey -M vicmd "^[[B" history-substring-search-down
if [[ -n ${terminfo[kcuu1]:-} ]]; then
  bindkey -M viins "${terminfo[kcuu1]}" history-substring-search-up
  bindkey -M vicmd "${terminfo[kcuu1]}" history-substring-search-up
fi
if [[ -n ${terminfo[kcud1]:-} ]]; then
  bindkey -M viins "${terminfo[kcud1]}" history-substring-search-down
  bindkey -M vicmd "${terminfo[kcud1]}" history-substring-search-down
fi
bindkey -M viins "^P" history-substring-search-up
bindkey -M viins "^N" history-substring-search-down
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

# Prefix sudo. Esc Esc is unreliable with KEYTIMEOUT=1.
bindkey -M viins "\es" sudo-command-line
bindkey -M vicmd "\es" sudo-command-line

# pkgfile "command not found" handler
source /usr/share/doc/pkgfile/command-not-found.zsh
