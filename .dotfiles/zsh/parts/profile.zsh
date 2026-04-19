TERM="xterm-256color"

export CURRENT_UID="$(id -u):$(id -g)"

# Guard — only run in interactive zsh, prevents /bin/sh inheritance issues
if [[ -n "$ZSH_VERSION" && -o interactive ]]; then
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
        ##export MANPAGER="sh -c 'col -bx | $_BAT -l man -p'"  ## causes issues with devcontainer
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
        # ─── fzf widgets ──────────────────────────────────────────────────────────────
        
        function fzf-history-preview-widget {
            local bat_cmd="${_BAT:-bat}"
            local selected=$(fc -rl 1 | command fzf \
                --height=40% --layout=reverse --border \
                --preview "echo {} | sed 's/^[ ]*[0-9]*[ ]*//' | $bat_cmd --color=always --style=plain --language=bash -" \
                --preview-window=up:3:wrap \
                --query="$LBUFFER")
        
            if [[ -n "$selected" ]]; then
                LBUFFER=$(echo "$selected" | sed 's/^[ ]*[0-9]*[ ]*//')
            fi
            zle reset-prompt
        }
        zle -N fzf-history-preview-widget
        bindkey '^R' fzf-history-preview-widget
        
        function fzf-file-preview-widget {
            local bat_cmd="${_BAT:-bat}"
            local selected=$(find . -maxdepth 4 -not -path '*/.*' 2>/dev/null | command fzf \
                --height=40% --layout=reverse --border \
                --preview "[[ -d {} ]] && ls -CF {} || $bat_cmd --color=always --style=numbers --line-range :500 {}" \
                --preview-window=right:60%:wrap)
        
            if [[ -n "$selected" ]]; then
                LBUFFER="${LBUFFER}${selected}"
            fi
            zle reset-prompt
        }
        zle -N fzf-file-preview-widget
        bindkey '^T' fzf-file-preview-widget
        
        function fzf-cd-preview-widget {
            local dir=$(find . -maxdepth 3 -type d -not -path '*/.*' 2>/dev/null | command fzf \
                --height=40% --layout=reverse --border \
                --preview 'ls -CF {} | head -20' \
                --preview-window=right:50%)
        
            if [[ -n "$dir" ]]; then
                cd "$dir"
            fi
            zle reset-prompt
        }
        zle -N fzf-cd-preview-widget
        bindkey '\ec' fzf-cd-preview-widget
    fi
fi
