# Show system info on terminal start (must run before p10k instant prompt,
# which is enabled at the top of cachyos-config.zsh)
command -v fastfetch >/dev/null && fastfetch

export EDITOR="nvim"
export VISUAL="nvim"
alias vi="nvim"
export TERMINAL="kitty"

# CachyOS defaults: oh-my-zsh, p10k (+ ~/.p10k.zsh), syntax highlighting, autosuggestions
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# History (HISTCONTROL/PROMPT_COMMAND in the CachyOS config are bash-only)
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# No "correct 'foo' to 'Foo' [nyae]?" prompts
unsetopt CORRECT CORRECT_ALL

# CachyOS defines this in double quotes, so the orphan list is frozen at startup
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'

# Modern replacements
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias tree="eza --tree --icons"
alias cat="bat --paging=never"

# fzf: use fd (fast, respects .gitignore), preview files with bat
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export PATH="$HOME/.local/bin:$PATH"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

# atuin: searchable shell history on Ctrl-R (up arrow left as normal history)
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# zoxide: replaces cd (cd <dir> jumps by frecency, cdi for interactive fzf picker)
eval "$(zoxide init zsh --cmd cd)"

# dotfiles: bare repo in ~/.dotfiles, work tree is $HOME (dot status / dot add / dot commit / dot push)
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
