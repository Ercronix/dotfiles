#!/usr/bin/env bash
# Sets up the terminal (zsh + p10k + CLI tools + dotfiles) on Ubuntu, e.g. under WSL. Safe to re-run.
#
# Fresh WSL Ubuntu:
#   sudo apt update && sudo apt install -y git gh && gh auth login
#   bash <(gh api repos/Ercronix/dotfiles/contents/.config/dotfiles/bootstrap-wsl.sh -H 'Accept: application/vnd.github.raw')
#
# Then on Windows: install WezTerm + the Nerd Font this script downloads (it tells you where).
set -euo pipefail

REPO="Ercronix/dotfiles"
BREW="/home/linuxbrew/.linuxbrew/bin/brew"
ZSH_DIR="$HOME/.oh-my-zsh"

APT_PKGS=(zsh git gh curl unzip build-essential procps file)
# Ubuntu's apt versions are old, renamed (batcat/fdfind) or missing, so these come from Homebrew
BREW_PKGS=(eza bat fzf fd ripgrep zoxide atuin yazi neovim fastfetch zellij git-delta btop micro)
OMZ_PLUGINS=(zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting zsh-users/zsh-history-substring-search)
NERD_FONT="CascadiaCode"   # ships as "CaskaydiaCove Nerd Font"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
clone_or_pull() {
  if [[ -d "$2/.git" ]]; then
    git -C "$2" pull -q --ff-only || warn "could not update $2"
  else
    git clone -q --depth=1 "https://github.com/$1" "$2"
  fi
}

command -v apt-get >/dev/null || { echo "This script is for Ubuntu/Debian. On Arch use bootstrap.sh." >&2; exit 1; }

# --- packages ---------------------------------------------------------------
step "Installing apt packages"
sudo apt-get update -q
sudo apt-get install -y "${APT_PKGS[@]}"

step "Installing Homebrew and CLI tools"
[[ -x "$BREW" ]] || NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$("$BREW" shellenv)"
brew install "${BREW_PKGS[@]}" || warn "some brew packages failed — continuing"

# --- zsh --------------------------------------------------------------------
# .zshrc loads these from ~/.oh-my-zsh when the CachyOS zsh config isn't there
step "Installing oh-my-zsh, powerlevel10k and plugins"
clone_or_pull ohmyzsh/ohmyzsh "$ZSH_DIR"
clone_or_pull romkatv/powerlevel10k "$ZSH_DIR/custom/themes/powerlevel10k"
for p in "${OMZ_PLUGINS[@]}"; do
  clone_or_pull "$p" "$ZSH_DIR/custom/plugins/${p#*/}"
done

# --- dotfiles ---------------------------------------------------------------
# bootstrap.sh does the clone, backup, checkout, chsh and Claude Code setup
step "Running bootstrap.sh"
if [[ -f "$HOME/.config/dotfiles/bootstrap.sh" ]]; then
  bash "$HOME/.config/dotfiles/bootstrap.sh" --no-packages
else
  gh auth status >/dev/null 2>&1 || gh auth login
  bash <(gh api "repos/$REPO/contents/.config/dotfiles/bootstrap.sh" -H 'Accept: application/vnd.github.raw') --no-packages
fi

# --- Windows side -----------------------------------------------------------
if [[ -n "${WSL_DISTRO_NAME:-}" ]] && command -v cmd.exe >/dev/null; then
  # cmd.exe complains when started from a \\wsl$ path, so run it from C:
  win_home=$(wslpath "$(cd /mnt/c && cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")

  step "Writing WezTerm config to $win_home/.wezterm.lua"
  target="$win_home/.wezterm.lua"
  new=$(sed "s/__WSL_DISTRO__/$WSL_DISTRO_NAME/" "$HOME/.config/wezterm/wezterm.lua")
  if [[ -f "$target" ]] && [[ "$(<"$target")" != "$new" ]]; then
    cp "$target" "$target.bak"
    echo "Backed up the existing config to $target.bak"
  fi
  printf '%s\n' "$new" > "$target"

  font_dir="$win_home/Downloads/$NERD_FONT-NerdFont"
  if [[ ! -d "$font_dir" ]]; then
    step "Downloading $NERD_FONT Nerd Font"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$NERD_FONT.zip" &&
      unzip -q "$tmp/font.zip" -d "$font_dir" || warn "font download failed"
    rm -rf "$tmp"
  fi

  step "Finish on Windows"
  echo "1. Install WezTerm:  winget install wez.wezterm"
  echo "2. Install the font: open $(wslpath -w "$font_dir"), select all .ttf files, right-click > Install"
  echo "3. Start WezTerm. It opens straight into $WSL_DISTRO_NAME."
else
  warn "not running under WSL, skipped the WezTerm config and font"
fi

step "Done"
echo "Open a new terminal to pick everything up."
