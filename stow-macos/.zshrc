# .zshrc - macOS zsh configuration
# This file is sourced for interactive shells

#------------------------------------------------------------------------------
# Shell Options
#------------------------------------------------------------------------------
setopt AUTO_CD              # cd by typing directory name
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history
setopt SHARE_HISTORY        # Share history between shells
setopt INC_APPEND_HISTORY   # Write to history file immediately

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#------------------------------------------------------------------------------
# Completion
#------------------------------------------------------------------------------
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#------------------------------------------------------------------------------
# Key Bindings
#------------------------------------------------------------------------------
bindkey -e  # Emacs key bindings

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

# 1Password SSH Agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Load custom environment if exists
[ -f ~/.env ] && source ~/.env

#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------
# Load aliases from dedicated file
if [[ -f ~/.aliases ]]; then
	source ~/.aliases
fi

#------------------------------------------------------------------------------
# Homebrew
#------------------------------------------------------------------------------
# Add Homebrew to PATH if installed
if [[ -d /opt/homebrew/bin ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
fi

#------------------------------------------------------------------------------
# FZF
#------------------------------------------------------------------------------
# Setup fzf if installed via Homebrew
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
	source /opt/homebrew/opt/fzf/shell/completion.zsh
fi
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
	source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

#------------------------------------------------------------------------------
# nvm - Node Version Manager
#------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
	source "/opt/homebrew/opt/nvm/nvm.sh"
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh"
fi
# nvm bash completion
if [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]]; then
	source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
elif [[ -s "$NVM_DIR/bash_completion" ]]; then
	source "$NVM_DIR/bash_completion"
fi

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
# Use Nerd Font config on macOS
export STARSHIP_CONFIG=~/.config/starship-nerd.toml
eval "$(starship init zsh)"

#------------------------------------------------------------------------------
# Fortune - Random Quotes
#------------------------------------------------------------------------------
# Display a random fortune if installed
if command -v fortune &> /dev/null; then
	if alias fortune-everything &> /dev/null; then
		fortune-everything
	else
		fortune
	fi
fi
