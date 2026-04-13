TERM="xterm-256color"

export CURRENT_UID="$(id -u):$(id -g)"

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────

# Warn when a command takes longer than this (seconds)
REPORTTIME=10

# Show dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ─── bat ──────────────────────────────────────────────────────────────────────

if command_exists bat || command_exists batcat; then
    export BAT_THEME="base16"
    export BAT_STYLE="numbers,changes,header"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ─── fzf ──────────────────────────────────────────────────────────────────────

if command_exists fzf; then
    # Use fd if available — faster, respects .gitignore
    if command_exists fd; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --preview-window=right:50%:wrap
        --bind='ctrl-/:toggle-preview'
    "

    # Add bat preview if available
    if command_exists bat || command_exists batcat; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
        --preview 'bat --color=always --line-range=:50 {}'
        "
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:100 {}' --preview-window=right:50%:wrap"
    fi

    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
fi