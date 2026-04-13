alias config='git --git-dir="$HOME/.dotfiles-git" --work-tree="$HOME"'

alias dotupdate='config pull && $HOME/.dotfiles/.bin/install'

# Xdebug (WSL/Linux only)
if [[ "$OSTYPE" == "linux"* ]]; then
    alias xdg='XDEBUG_MODE=debug PHP_IDE_CONFIG="serverName=wsl"'
fi

alias php80='_php_switch 8.0'
alias php81='_php_switch 8.1'
alias php82='_php_switch 8.2'
alias php83='_php_switch 8.3'
alias php84='_php_switch 8.4'

# bat (cat with syntax highlighting)
# Ubuntu ships bat as batcat due to a naming conflict
if [[ "$OSTYPE" == "linux"* ]] && command_exists batcat; then
    alias bat='batcat'
fi

if command_exists bat; then
    alias cat='bat --paging=never'
fi

# ─── fzf ──────────────────────────────────────────────────────────────────────

if command_exists fzf; then
    # Interactive git branch checkout
    alias fgco='git branch | fzf | xargs git checkout'

    # Interactive git branch delete
    alias fgbd='git branch | fzf -m | xargs git branch -d'

    # Interactive process kill
    alias fkill='ps aux | fzf -m | awk '"'"'{print $2}'"'"' | xargs kill'

    # Interactive cd into any subdirectory
    alias fcd='cd "$(find . -type d | fzf)"'

    # Interactive file open in editor
    alias fopen='nano "$(fzf)"'

    # Interactive history search and run
    alias fhist='eval "$(history | fzf | sed '"'"'s/ *[0-9]* *//'"'"')"'
fi

# ─── bat ──────────────────────────────────────────────────────────────────────

if [[ -n "$_BAT" ]]; then
    # Show all available themes with a preview
    alias bat-themes="$_BAT --list-themes | fzf --preview \"$_BAT --theme={} --color=always ~/.zshrc\""

    # Print with line ranges
    alias batp="$_BAT --paging=always"

    # Diff two files with syntax highlighting
    alias batdiff="$_BAT --diff"
fi
