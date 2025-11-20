# task File Specification

**Taskfile-pattern task runner for dotfiles**

---

## Overview

| Property | Value |
|----------|-------|
| File | task |
| Size target | ~300 lines |
| Language | Bash |
| Shell flags | set -euo pipefail |
| Pattern | https://taskfile.build |

---

## Structure

| Section | Lines | Purpose |
|---------|-------|---------|
| Shebang + flags | 2 | Environment setup |
| Load bash-utility | 3 | Source labbots/bash-utility |
| Utilities | 10 | Private helper functions (_prefix) |
| Package managers | 30 | Homebrew, Stow install |
| Package installation | 30 | Brew, apt, cask tasks |
| Dotfiles | 40 | Stow commands per package |
| Configuration | 30 | Git config, macOS defaults |
| Workflows | 50 | Composite tasks (install, update) |
| Help | 40 | Command listing |
| Dispatcher | 10 | Function router |

---

## Naming Convention

### Utility Functions

**Source**: labbots/bash-utility

| Function | Source | Purpose |
|----------|--------|---------|
| os::detect_os | bash-utility | Detect OS (macos/linux) |
| check::command_exists | bash-utility | Check command exists |
| _info | Inline | Log to stdout |
| _error | Inline | Log to stderr, exit 1 |

### Public Tasks

**Format**: `action-object` (kebab-case)

| Task | Action | Object |
|------|--------|--------|
| install-homebrew | install | homebrew |
| install-stow | install | stow |
| install-brew-packages | install | brew-packages |
| stow-common | stow | common |
| configure-macos | configure | macos |

---

## Task Categories

### Package Managers

| Task | Platform | Purpose |
|------|----------|---------|
| install-homebrew | macOS | Install Homebrew |
| install-stow | Both | Install GNU Stow |

### Package Installation

| Task | Platform | Purpose |
|------|----------|---------|
| install-brew-packages | macOS | brew bundle |
| install-apt-packages | Ubuntu | xargs apt install |
| install-cask-apps | macOS | Included in Brewfile |

### Dotfiles

| Task | Platform | Purpose |
|------|----------|---------|
| stow-common | Both | Symlink stow-common/ |
| stow-macos | macOS | Symlink stow-macos/ |
| stow-ubuntu | Ubuntu | Symlink stow-ubuntu/ |
| stow-all | Both | Symlink all dotfiles |

### Configuration

| Task | Platform | Purpose |
|------|----------|---------|
| configure-git | Both | Generate .gitconfig from template |
| configure-macos | macOS | Run macos-defaults.sh |

### Workflows

| Task | Purpose |
|------|---------|
| install-dependencies | Install Homebrew + Stow |
| install-packages | Install all packages |
| install-dotfiles | Configure + symlink all |
| install | Full installation |
| update | Update packages |

---

## Implementation

### Utilities Section

```bash
#!/bin/bash
set -euo pipefail

# Load bash-utility (must be sourced from its directory due to relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/vendor/bash-utility" && source bash_utility.sh && cd "${SCRIPT_DIR}"

#------------------------------------------------------------------------------
# UTILITIES (private helpers)
#------------------------------------------------------------------------------
_info() { echo "[INFO] $1"; }
_error() { echo "[ERROR] $1" >&2; exit 1; }

# Use bash-utility for OS/command detection
_platform() { os::detect_os; }  # Returns: mac, linux
_has_cmd() { check::command_exists "$1"; }
```

### Package Manager Tasks

```bash
#------------------------------------------------------------------------------
# PACKAGE MANAGERS
#------------------------------------------------------------------------------
install-homebrew() {
    [[ "$(_platform)" != "macos" ]] && return
    if ! _has_cmd brew; then
        _info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install-stow() {
    _info "Installing GNU Stow..."
    if [[ "$(_platform)" == "macos" ]]; then
        brew install stow
    else
        sudo apt update
        sudo apt install -y stow
    fi
}
```

### Package Installation Tasks

```bash
#------------------------------------------------------------------------------
# PACKAGE INSTALLATION
#------------------------------------------------------------------------------
install-brew-packages() {
    [[ "$(_platform)" != "macos" ]] && return
    _info "Installing Homebrew packages..."
    brew bundle --file=Brewfile
}

install-apt-packages() {
    [[ "$(_platform)" != "ubuntu" ]] && return
    _info "Installing apt packages..."
    xargs sudo apt install -y < apt.txt
}

install-cask-apps() {
    [[ "$(_platform)" != "macos" ]] && return
    _info "macOS apps included in Brewfile"
    install-brew-packages
}
```

### Dotfiles Tasks

```bash
#------------------------------------------------------------------------------
# DOTFILES
#------------------------------------------------------------------------------
stow-common() {
    _info "Symlinking common dotfiles..."
    stow -d . -t ~ stow-common
}

stow-macos() {
    [[ "$(_platform)" != "macos" ]] && return
    _info "Symlinking macOS dotfiles..."
    stow -d . -t ~ stow-macos
}

stow-ubuntu() {
    [[ "$(_platform)" != "ubuntu" ]] && return
    _info "Symlinking Ubuntu dotfiles..."
    stow -d . -t ~ stow-ubuntu
}

stow-all() {
    stow-common
    stow-macos
    stow-ubuntu
}
```

### Configuration Tasks

```bash
#------------------------------------------------------------------------------
# CONFIGURATION
#------------------------------------------------------------------------------
configure-git() {
    [[ ! -f .env ]] && _error ".env not found"
    source .env
    [[ -z "${GIT_USER_NAME:-}" ]] && _error "GIT_USER_NAME required in .env"
    [[ -z "${GIT_USER_EMAIL:-}" ]] && _error "GIT_USER_EMAIL required in .env"

    _info "Generating .gitconfig..."
    envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
}

configure-macos() {
    [[ "$(_platform)" != "macos" ]] && return
    _info "Configuring macOS defaults..."
    ./macos-defaults.sh
}
```

### Workflow Tasks

```bash
#------------------------------------------------------------------------------
# WORKFLOWS
#------------------------------------------------------------------------------
install-dependencies() {
    _info "Installing dependencies for $(_platform)..."
    if [[ "$(_platform)" == "macos" ]]; then
        install-homebrew
    fi
    install-stow
}

install-packages() {
    install-brew-packages
    install-apt-packages
}

install-dotfiles() {
    configure-git
    stow-all
}

install() {
    _info "Full installation for $(_platform)"
    install-dependencies
    install-packages
    install-dotfiles
    configure-macos
    _info "Done! Restart terminal."
}

update() {
    _info "Updating packages..."
    if [[ "$(_platform)" == "macos" ]]; then
        brew update && brew upgrade
    else
        sudo apt update && sudo apt upgrade -y
    fi
}
```

### Help Task

```bash
#------------------------------------------------------------------------------
# HELP
#------------------------------------------------------------------------------
help() {
    cat << 'EOF'
Dotfiles Task Runner

Usage: ./task <command>

WORKFLOWS:
  install              Full installation
  update               Update all packages
  install-dependencies Install system dependencies
  install-packages     Install all packages
  install-dotfiles     Symlink all dotfiles

PACKAGE MANAGERS:
  install-homebrew     Install Homebrew (macOS)
  install-stow         Install GNU Stow

PACKAGE INSTALLATION:
  install-brew-packages Install Brewfile packages
  install-apt-packages Install apt.txt packages
  install-cask-apps    Install macOS apps

DOTFILES:
  stow-common          Symlink common dotfiles
  stow-macos           Symlink macOS dotfiles (macOS only)
  stow-ubuntu          Symlink Ubuntu dotfiles (Ubuntu only)
  stow-all             Symlink all dotfiles

CONFIGURATION:
  configure-git        Generate .gitconfig from template
  configure-macos      Apply macOS defaults (macOS only)

Run './task help' for this message
EOF
}
```

### Dispatcher

```bash
#------------------------------------------------------------------------------
# DISPATCHER
#------------------------------------------------------------------------------
TIMEFORMAT="Completed in %3lR"

if [[ $# -eq 0 ]]; then
    help
    exit 0
fi

if declare -f "$1" &>/dev/null; then
    time "$@"
else
    echo "Error: Unknown command '$1'"
    echo ""
    echo "Run './task help' for available commands"
    exit 1
fi
```

---

## Usage Examples

### Full Installation

```bash
./task install
```

### Granular Operations

```bash
# Update packages only
./task update

# Install Homebrew packages only
./task install-brew-packages

# Symlink dotfiles only
./task stow-all

# Re-run macOS configuration
./task configure-macos

# Install specific dependency
./task install-stow

# Regenerate .gitconfig
./task configure-git

# Symlink specific package
./task stow-common
```

### Development Workflow

```bash
# Edit Brewfile
vim Brewfile

# Install new packages
./task install-brew-packages

# Edit dotfile
vim stow-common/.vimrc

# Re-symlink
./task stow-common
```

---

## Platform Detection

### Task Guards

**Pattern**: Check platform at task start

```bash
task-name() {
    [[ "$(_platform)" != "macos" ]] && return
    # macOS-only logic
}
```

**Result**: Silent skip on wrong platform

### Platform Variable

```bash
_platform() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "ubuntu" ;;
        *) _error "Unsupported OS: $(uname -s)" ;;
    esac
}
```

---

## Error Handling

| Behavior | Implementation |
|----------|----------------|
| Fail fast | set -euo pipefail |
| Exit on error | -e flag |
| Undefined vars | -u flag |
| Pipeline failures | -o pipefail |
| Error messages | _error() to stderr |
| Exit codes | 0=success, 1=failure |
| Unknown command | Dispatcher catches |

---

## Idempotency

| Task | First Run | Second Run |
|------|-----------|------------|
| install-homebrew | Installs | Skips (exists) |
| install-stow | Installs | Skips (apt/brew handles) |
| install-brew-packages | Installs all | Skips installed |
| stow-common | Creates symlinks | Updates symlinks |
| configure-macos | Applies settings | Overwrites (safe) |

**All tasks MUST be safe to re-run.**

---

## Validation

### Syntax Check

```bash
bash -n task
```

### Test Idempotency

```bash
./task install
./task install  # MUST succeed
```

### Test Individual Tasks

```bash
./task install-homebrew
./task install-stow
./task stow-common
./task configure-git
```

---

## File Permissions

```bash
chmod +x task
```

**MUST** be executable.

---

## Related

- [macos-defaults.md](macos-defaults.md) - macOS settings script
- [package-management.md](package-management.md) - Brewfile/apt.txt
- [stow-packages.md](stow-packages.md) - Stow organization
- [configuration.md](configuration.md) - .env handling
- [../research/taskfile-analysis.md](../research/taskfile-analysis.md) - Pattern overview
- [../research/taskfile-real-world.md](../research/taskfile-real-world.md) - Real-world example
