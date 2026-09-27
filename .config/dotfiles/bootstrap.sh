#!/usr/bin/env bash
# Sets up these dotfiles on a new machine. Safe to re-run.
#
# Fresh machine:
#   sudo pacman -S --needed git github-cli && gh auth login
#   bash <(gh api repos/Ercronix/dotfiles/contents/.config/dotfiles/bootstrap.sh -H 'Accept: application/vnd.github.raw')
#
# Flags: --no-packages   skip installing packages
set -euo pipefail

REPO="Ercronix/dotfiles"
GIT_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

PACMAN_PKGS=(
  git github-cli zsh cachyos-zsh-config zsh-theme-powerlevel10k oh-my-zsh-git
  zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting
  hyprland hyprpaper dms-shell dms-shell-hyprland dms-shell-niri matugen
  kitty neovim waybar wofi wlogout waypaper yazi btop fastfetch micro
  atuin zoxide eza fzf bat fd ripgrep git-delta zed
  ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-nerd-fonts-symbols
)
AUR_PKGS=(quickshell-git dankcalendar-bin)

install_packages=1
for arg in "$@"; do
  case "$arg" in
    --no-packages) install_packages=0 ;;
    *) echo "unknown flag: $arg" >&2; exit 1 ;;
  esac
done

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
dot() { git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"; }

# --- packages ---------------------------------------------------------------
if (( install_packages )); then
  if command -v pacman >/dev/null; then
    step "Installing packages"
    sudo pacman -S --needed "${PACMAN_PKGS[@]}" || warn "some pacman packages failed (not in your repos?) — continuing"
    aur=$(command -v paru || command -v yay || true)
    if [[ -n "$aur" ]]; then
      "$aur" -S --needed "${AUR_PKGS[@]}" || warn "some AUR packages failed — continuing"
    else
      warn "no AUR helper found, skipping: ${AUR_PKGS[*]}"
    fi
  else
    warn "not an Arch-based system, skipping packages. Install manually: ${PACMAN_PKGS[*]} ${AUR_PKGS[*]}"
  fi
fi

# --- GitHub auth ------------------------------------------------------------
step "Checking GitHub login"
gh auth status >/dev/null 2>&1 || gh auth login

# --- clone ------------------------------------------------------------------
if [[ -d "$GIT_DIR" ]]; then
  step "$GIT_DIR already exists, fetching"
  dot fetch
else
  step "Cloning $REPO into $GIT_DIR"
  gh repo clone "$REPO" "$GIT_DIR" -- --bare
fi
dot config status.showUntrackedFiles no
dot config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dot fetch -q
dot branch -q -u origin/main main

# --- checkout ---------------------------------------------------------------
# A bare clone has no index until the first checkout, so its absence means "not checked out yet".
if [[ ! -f "$GIT_DIR/index" ]]; then
  step "Checking out dotfiles"
  moved=0
  while IFS= read -r f; do
    [[ -e "$HOME/$f" || -L "$HOME/$f" ]] || continue
    # identical files don't need a backup
    if [[ -f "$HOME/$f" && ! -L "$HOME/$f" ]] &&
       [[ "$(dot hash-object "$HOME/$f")" == "$(dot rev-parse "HEAD:$f")" ]]; then
      rm "$HOME/$f"
      continue
    fi
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$BACKUP_DIR/$f"
    moved=$((moved + 1))
  done < <(dot ls-tree -r --name-only HEAD)
  dot checkout
  (( moved )) && echo "Backed up $moved existing file(s) to $BACKUP_DIR"
else
  step "Already checked out, pulling"
  dot pull --ff-only || warn "pull failed (local changes?) — resolve with 'dot status'"
fi

# --- shell ------------------------------------------------------------------
if [[ "$(basename "${SHELL:-}")" != zsh ]] && command -v zsh >/dev/null; then
  step "Setting zsh as login shell"
  chsh -s "$(command -v zsh)" || warn "chsh failed — run: chsh -s $(command -v zsh)"
fi

# --- Claude Code ------------------------------------------------------------
if ! command -v claude >/dev/null && [[ ! -x "$HOME/.local/bin/claude" ]]; then
  step "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash || warn "Claude Code install failed"
fi
export PATH="$HOME/.local/bin:$PATH"
if command -v claude >/dev/null; then
  step "Registering MCP servers"
  "$HOME/.config/dotfiles/setup-mcp.sh" || warn "MCP setup failed — re-run ~/.config/dotfiles/setup-mcp.sh later"
fi

# --- machine-specific -------------------------------------------------------
# DMS regenerates these from the wallpaper, so each machine keeps its own.
DMS_COLOR_FILES=(
  .config/DankMaterialShell/firefox.css
  .config/gtk-3.0/dank-colors.css
  .config/gtk-4.0/dank-colors.css
  .config/hypr/dms/colors.lua
  .config/kitty/dank-tabs.conf
  .config/kitty/dank-theme.conf
  .config/niri/dms/colors.kdl
  .config/zed/themes/dank-zed-theme.json
)
step "Ignoring local changes to DMS color files"
dot update-index --skip-worktree "${DMS_COLOR_FILES[@]}"

outputs=".config/hypr/dms/outputs.lua"
if [[ -t 0 ]]; then
  read -rp $'\nKeep monitor layout ('"$outputs"') local to this machine? [y/N] ' ans
  [[ "$ans" == [yY]* ]] && dot update-index --skip-worktree "$outputs" && echo "Local changes to $outputs will be ignored."
fi

step "Done"
echo "Open a new terminal (or log out and back in) to pick everything up."
echo "Then: 'dot status' / 'dot pull' / 'dot commit -am msg && dot push'"
