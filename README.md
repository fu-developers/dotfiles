# Dotfiles

Personal development environment configuration for macOS and Linux (Ubuntu/WSL2).

## What's included

- ZSH + Oh My Zsh with custom plugins and theme
- Git configuration with local identity override
  - By default, only name is given
  - Email set on repo level but can be added manually to `~/.gitconfig.local` if all repo's use same email
- AWS CLI v2 + Session Manager plugin
- Terraform
- NVM (Node Version Manager)
- Yarn
- PHP 8.0–8.4 + Composer
- Custom ZSH aliases, functions, and profile
  - - You can configure which theme you like among other things within the machine specific config [See Linked](#local-suggestions)

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

Your name and email are stored in `~/.gitconfig.local`, which is gitignored. Each machine has its own copy. To update it
manually:

```ini
# ~/.gitconfig.local
[user]
name = First Last
email = you@example.com
```

## Local ZSH config

`~/.dotfiles/zsh/local.zsh` is sourced automatically but never tracked by git. Use it for machine-specific aliases,
exports, or anything you don't want committed.

### Local Suggestions
- ZSH_THEME and other settings for Oh My Zsh
- Custom Functions
- Aliases
- Development Environment Variables

## Updating

Re-run the install script, or use the `dotupdate` alias from any terminal:

```bash
dotupdate
```

## Managing dotfiles

Use the `config` alias to run git commands against the dotfiles repo:

```bash
config status
config checkout -b new-branch
config add ~/.dotfiles/zsh/function.zsh
config commit -m "update generic functions"
config push
```

Submit a pr to merge back in for others to pull in
