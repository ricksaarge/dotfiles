# .bashrc - Ubuntu bash configuration
# This file is sourced for interactive non-login shells

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

#------------------------------------------------------------------------------
# Shell Options
#------------------------------------------------------------------------------
shopt -s checkwinsize  # Update LINES and COLUMNS after each command
shopt -s globstar      # Enable ** recursive glob pattern

#------------------------------------------------------------------------------
# Completion
#------------------------------------------------------------------------------
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

#------------------------------------------------------------------------------
# PATH Configuration
#------------------------------------------------------------------------------
# Add user bin directory (from dotfiles)
export PATH="$HOME/bin:$PATH"

#------------------------------------------------------------------------------
# Environment Variables
#------------------------------------------------------------------------------
export EDITOR=vim
export VISUAL=vim

# Load custom environment if exists
[ -f ~/.env ] && source ~/.env

#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------
alias ll='ls -alh --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ls='ls --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases (supplement .gitconfig)
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --all'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#------------------------------------------------------------------------------
# Local Bin
#------------------------------------------------------------------------------
# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

#------------------------------------------------------------------------------
# FZF
#------------------------------------------------------------------------------
# Setup fzf if installed
if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
	source /usr/share/doc/fzf/examples/completion.bash
fi
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
	source /usr/share/doc/fzf/examples/key-bindings.bash
fi

#------------------------------------------------------------------------------
# nvm - Node Version Manager
#------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
# nvm bash completion
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

#------------------------------------------------------------------------------
# pyenv - Python Version Manager
#------------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &> /dev/null; then
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

#------------------------------------------------------------------------------
# Starship Prompt
#------------------------------------------------------------------------------
eval "$(starship init bash)"
