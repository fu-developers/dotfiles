# Dotfiles

Personal development environment configuration for macOS and Linux (Ubuntu/WSL2).

## Contents

- [What's included](#whats-included)
- [Install](#install)
- [First-time setup](#first-time-setup)
- [Git identity](#git-identity)
- [Local ZSH config](#local-zsh-config)
- [Updating](#updating)
- [Managing dotfiles](#managing-dotfiles)

## What's included

- ZSH + Oh My Zsh with custom plugins and theme
- Git configuration with local identity override
    - By default, only name is set — email can be added manually to `~/.gitconfig.local`
- AWS CLI v2 + Session Manager plugin
- Terraform
- NVM (Node Version Manager)
- Yarn
- PHP 8.0–8.4 + Composer
- `fzf` — fuzzy finder with zsh history, file, and directory search
- `bat` — syntax highlighted cat replacement with git change indicators
- `nano` — configured with syntax highlighting, line numbers, and sensible defaults
- Custom ZSH aliases, functions, and profile

## Install

Run this in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nmathur94/dotfiles-public/master/.dotfiles/.bin/install)"
```

The script is idempotent — safe to re-run to update tools and pull the latest dotfiles.

## First-time setup

The install script will prompt you to:

- Set your git identity (name), saved to `~/.gitconfig.local` which is not tracked by git
- Optionally create `~/.dotfiles/zsh/local.zsh` for machine-specific config that won't be committed

## Git identity

Your name and email are stored in `~/.gitconfig.local`, which is gitignored. Each machine has its own copy. To update
manually:

```ini

# ~/.gitconfig.local

[user]
name = First Last
email = you@example.com
```

## Local ZSH config

`~/.dotfiles/zsh/local.zsh` is sourced automatically but never tracked by git. Use it for anything
machine-specific you don't want committed.

### Suggestions for local.zsh

- `ZSH_THEME` and other Oh My Zsh settings
- `ENABLE_CORRECTION="true"` to enable zsh autocorrect
- Custom aliases and functions
- Project or machine-specific environment variables

## ZSH config structure

```text
.dotfiles/zsh/
  _load.zsh ← entry point, controls load order for parts/
  parts/
    function.zsh ← shared functions, loaded first
    profile.zsh ← env vars, shell options, tool config
    alias.zsh ← aliases, loaded after functions and profile
  local.zsh ← machine-specific, gitignored, loaded last by OMZ
```

## Updating

Re-run the installation script, or use the `dotupdate` alias from any terminal:

```bash
dotupdate
```

## Managing dotfiles

Use the `config` alias to run git commands against the dotfiles repo:

```bash
config status
config checkout -b new-branch
config add ~/.dotfiles/zsh/parts/function.zsh
config commit -m "update functions"
config push
```

Submit a PR to merge changes back in for others to pull.
