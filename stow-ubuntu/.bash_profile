# .bash_profile - Ubuntu bash login shell configuration
# This file is sourced for login shells

#------------------------------------------------------------------------------
# PATH Configuration
#------------------------------------------------------------------------------
# Ensure system paths are set
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

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
if [ -f ~/.env ]; then
	source ~/.env
fi

#------------------------------------------------------------------------------
# Load .bashrc
#------------------------------------------------------------------------------
# Source .bashrc for login shells
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
