# Portable between CachyOS and Ubuntu (WSL). Tools are only wired up when installed.

# Homebrew on Linux (how the WSL bootstrap installs the CLI tools)
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Show system info on terminal start (must run before p10k instant prompt)
command -v fastfetch >/dev/null && fastfetch

export EDITOR="nvim"
export VISUAL="nvim"
alias vi="nvim"
command -v kitty >/dev/null && export TERMINAL="kitty"

if [[ -r /usr/share/cachyos-zsh-config/cachyos-config.zsh ]]; then
  # CachyOS defaults: oh-my-zsh, p10k (+ ~/.p10k.zsh), syntax highlighting, autosuggestions
  source /usr/share/cachyos-zsh-config/cachyos-config.zsh
else
  # Same setup elsewhere, from ~/.oh-my-zsh (installed by bootstrap-wsl.sh)
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="powerlevel10k/powerlevel10k"
  DISABLE_MAGIC_FUNCTIONS="true"
  COMPLETION_WAITING_DOTS="true"
  # syntax-highlighting must come last
  plugins=(git fzf extract zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
  source $ZSH/oh-my-zsh.sh
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  alias c="clear"
fi

# History (HISTCONTROL/PROMPT_COMMAND in the CachyOS config are bash-only)
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# No "correct 'foo' to 'Foo' [nyae]?" prompts
unsetopt CORRECT CORRECT_ALL

# CachyOS defines this in double quotes, so the orphan list is frozen at startup
command -v pacman >/dev/null && alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'

# Modern replacements (Ubuntu's apt names bat/fd "batcat"/"fdfind")
_bat=${commands[bat]:+bat}; _bat=${_bat:-${commands[batcat]:+batcat}}
_fd=${commands[fd]:+fd}; _fd=${_fd:-${commands[fdfind]:+fdfind}}
if command -v eza >/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first --git"
  alias tree="eza --tree --icons"
fi
[[ -n $_bat ]] && alias cat="$_bat --paging=never"

# fzf: use fd (fast, respects .gitignore), preview files with bat
if [[ -n $_fd ]]; then
  export FZF_DEFAULT_COMMAND="$_fd --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$_fd --type d --hidden --exclude .git"
fi
[[ -n $_bat ]] && export FZF_CTRL_T_OPTS="--preview '$_bat --color=always --style=numbers --line-range=:200 {}'"
unset _bat _fd

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export PATH="$HOME/.local/bin:$PATH"

if [[ -d $HOME/Android/Sdk ]]; then
  export ANDROID_HOME=$HOME/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin
fi

# atuin: searchable shell history on Ctrl-R (up arrow left as normal history)
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# zoxide: replaces cd (cd <dir> jumps by frecency, cdi for interactive fzf picker)
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

# dotfiles: bare repo in ~/.dotfiles, work tree is $HOME (dot status / dot add / dot commit / dot push)
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
