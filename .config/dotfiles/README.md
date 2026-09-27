# dotfiles

Bare git repo: git data lives in `~/.dotfiles`, the work tree is `$HOME`.
Only explicitly added files are tracked (untracked files are hidden).

## Daily use

```sh
dot status
dot add ~/.config/foo/config    # start tracking a new file
dot commit -am "tweak kitty"
dot push
dot pull                        # on the other PC
```

## Setup on a new machine

Quick way (installs packages, clones, backs up conflicting files, checks out, sets zsh, installs Claude Code + MCP):

```sh
sudo pacman -S --needed git github-cli && gh auth login
bash <(gh api repos/Ercronix/dotfiles/contents/.config/dotfiles/bootstrap.sh -H 'Accept: application/vnd.github.raw')
```

Add `--no-packages` to skip package installs. Safe to re-run. Manual steps below.

```sh
git clone --bare git@github.com:Ercronix/dotfiles.git ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dot fetch && dot branch -u origin/main main
# back up any existing files that would be overwritten, then check out
mkdir -p ~/.dotfiles-backup
dot checkout 2>&1 | grep -E '^\s+\.' | awk '{print $1}' | \
  xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv ~/{} ~/.dotfiles-backup/{}'
dot checkout
```

Neovim config is included here (formerly Ercronix/nvim-config).

## Machine-specific

`~/.config/hypr/dms/outputs.lua` holds monitor layout — adjust per machine (or `dot update-index --skip-worktree` it).

DMS color files (`dank-colors.css`, `dank-theme.conf`, `colors.lua`, …) are regenerated from the wallpaper, so `bootstrap.sh` marks them `--skip-worktree` and they stay out of `dot status`. Undo with `dot update-index --no-skip-worktree <file>`; list them with `dot ls-files -v | grep '^S'`.

## Claude Code MCP servers

`~/.claude.json` is not tracked (it holds account state and tokens). After `claude` login and `gh auth login`, run:

```sh
~/.config/dotfiles/setup-mcp.sh     # or: GITHUB_MCP_TOKEN=<pat> ~/.config/dotfiles/setup-mcp.sh
```
