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

```sh
git clone --bare git@github.com:Ercronix/dotfiles.git ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
# back up any existing files that would be overwritten, then check out
mkdir -p ~/.dotfiles-backup
dot checkout 2>&1 | grep -E '^\s+\.' | awk '{print $1}' | \
  xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv ~/{} ~/.dotfiles-backup/{}'
dot checkout
```

Neovim config lives in its own repo: `git clone git@github.com:Ercronix/nvim-config.git ~/.config/nvim`

## Machine-specific

`~/.config/hypr/dms/outputs.lua` holds monitor layout — adjust per machine (or `dot update-index --skip-worktree` it).
