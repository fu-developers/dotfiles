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

# ─── Resolve bat binary ───────────────────────────────────────────────────────

if command_exists batcat; then
    _BAT="batcat"
elif command_exists bat; then
    _BAT="bat"
fi

# ─── bat ──────────────────────────────────────────────────────────────────────

if [[ -n "$_BAT" ]]; then
    export BAT_THEME="base16"
    export BAT_STYLE="numbers,changes,header"
    export MANPAGER="sh -c 'col -bx | $_BAT -l man -p'"
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
    if [[ -n "$_BAT" ]]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview '$_BAT --color=always --line-range=:50 {}'"
        export FZF_CTRL_T_OPTS="--preview '$_BAT --color=always --line-range=:100 {}' --preview-window=right:50%:wrap"
    fi

    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
fi
