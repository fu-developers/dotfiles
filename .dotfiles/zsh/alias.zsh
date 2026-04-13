alias config='git --git-dir="$HOME/.dotfiles-git" --work-tree="$HOME"'

alias dotupdate='config pull && $HOME/.dotfiles/.bin/install'

# Xdebug (WSL/Linux only)
if [[ "$OSTYPE" == "linux"* ]]; then
    alias xdg='XDEBUG_MODE=debug PHP_IDE_CONFIG="serverName=wsl"'
fi

# Switch PHP Versions
_php_switch() {
    local version="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew unlink php 2>/dev/null || true
        brew link --overwrite --force "php@${version}"
    else
        sudo update-alternatives --set php "/usr/bin/php${version}"
    fi
}

alias php80='_php_switch 8.0'
alias php81='_php_switch 8.1'
alias php82='_php_switch 8.2'
alias php83='_php_switch 8.3'
alias php84='_php_switch 8.4'