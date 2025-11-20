# .zprofile - macOS zsh login shell configuration
# This file is sourced for login shells

#------------------------------------------------------------------------------
# PATH Configuration
#------------------------------------------------------------------------------
# Ensure system paths are set
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Homebrew
if [[ -d /opt/homebrew/bin ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
fi

#------------------------------------------------------------------------------
# XDG Base Directory Specification
#------------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

#------------------------------------------------------------------------------
# Custom Paths
#------------------------------------------------------------------------------
# Load from .env if exists
if [[ -f ~/.env ]]; then
	source ~/.env
fi

# iCloud Drive shortcut
if [[ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]]; then
	export ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
fi

#------------------------------------------------------------------------------
# 1Password SSH Agent
#------------------------------------------------------------------------------
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
