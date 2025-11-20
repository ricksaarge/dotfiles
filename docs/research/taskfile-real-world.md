# Real-World Taskfile Analysis

**PROOF: Taskfile pattern scales to 1,442 lines production use**

**Why matters**: Validates granular task approach works at scale (60+ tools, multi-distro)

---

## Conclusion

| Finding | Evidence |
|---------|----------|
| Pattern scales | 1,442 lines, production use |
| Granular works | 60+ individual tool commands |
| Multi-platform | Arch/Ubuntu/Fedora detection |

**Validates**: Taskfile pattern choice for dotfiles

---

## Source

https://codeberg.org/janikvonrotz/dotfiles/src/branch/main/task

**Stats**: 1,442 lines, 60+ tools, multi-distro support

---

## Key Insights

### Granular Commands

**NOT monolithic install** - Each tool/action is separate command:

```bash
./task install-docker
./task install-nvim
./task install-fonts
./task setup-git
./task backup-android
./task restore-thunderbird
```

### Package Manager Abstraction

**Auto-detects** package manager:

```bash
# Detects: pacman (Arch), apt (Ubuntu), dnf (Fedora)
if command -v pacman; then
    install-docker() { pacman -S docker; }
elif command -v apt; then
    install-docker() { apt install docker.io; }
fi
```

### Command Categories

| Category | Example Commands |
|----------|------------------|
| Package install | install-docker, install-nvim, install-fonts |
| Environment | setup-git, setup-venv, setup-env |
| Backup/Restore | backup-android, restore-thunderbird |
| System config | setup-passwordless-sudo, setup-bluetooth |
| Execution | run-open-webui, run-ollama |

---

## Pattern Applied to Your Dotfiles

### Granular Task Structure

```bash
#!/bin/bash
set -euo pipefail

#------------------------------------------------------------------------------
# UTILITIES
#------------------------------------------------------------------------------
_info() { echo "[INFO] $1"; }
_error() { echo "[ERROR] $1" >&2; exit 1; }

_platform() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "ubuntu" ;;
        *) _error "Unsupported OS" ;;
    esac
}

#------------------------------------------------------------------------------
# PACKAGE MANAGERS
#------------------------------------------------------------------------------
install-homebrew() {
    [[ "$(_platform)" != "macos" ]] && return
    if ! command -v brew &>/dev/null; then
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
    _info "Installing macOS apps (casks already in Brewfile)"
    brew bundle --file=Brewfile
}

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

#------------------------------------------------------------------------------
# CONFIGURATION
#------------------------------------------------------------------------------
configure-macos() {
    [[ "$(_platform)" != "macos" ]] && return
    _info "Configuring macOS defaults..."
    ./macos-defaults.sh
}

configure-git() {
    [[ ! -f .env ]] && _error ".env not found"
    source .env
    _info "Generating .gitconfig..."
    envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
}

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
  install-brew-packages Install Brewfile packages
  install-apt-packages Install apt.txt packages
  install-cask-apps    Install macOS apps

DOTFILES:
  stow-common          Symlink common dotfiles
  stow-macos           Symlink macOS dotfiles
  stow-ubuntu          Symlink Ubuntu dotfiles
  stow-all             Symlink all dotfiles
  configure-git        Generate .gitconfig

CONFIGURATION:
  configure-macos      Apply macOS defaults

Run './task help' to see this message
EOF
}

#------------------------------------------------------------------------------
# DISPATCHER
#------------------------------------------------------------------------------
TIMEFORMAT="Completed in %3lR"

if declare -f "$1" &>/dev/null; then
    time "$@"
else
    echo "Unknown command: $1"
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
# Just update packages
./task update

# Just install Homebrew packages
./task install-brew-packages

# Just symlink dotfiles (skip package install)
./task stow-all

# Re-run macOS configuration
./task configure-macos

# Install a single dependency
./task install-stow

# Update .gitconfig template
./task configure-git
```

### Development Workflow

```bash
# Update Brewfile
vim Brewfile

# Install new packages only
./task install-brew-packages

# Test new dotfile
vim stow-common/.vimrc

# Symlink without full install
./task stow-common
```

---

## Benefits vs Traditional install.sh

| Aspect | install.sh | Taskfile (granular) |
|--------|-----------|---------------------|
| Full install | `./install.sh` | `./task install` |
| Update packages | Re-run all | `./task update` |
| Add package | Re-run all | `./task install-brew-packages` |
| Fix stow conflict | Re-run all | `./task stow-all` |
| Re-apply macOS settings | Re-run all | `./task configure-macos` |
| Discoverability | None | `./task help` |

---

## Real-World Scenarios

### Scenario 1: Added new Brewfile entry

**install.sh approach**:
```bash
./install.sh  # Re-runs everything (5-10 min)
```

**Taskfile approach**:
```bash
./task install-brew-packages  # Just packages (1 min)
```

### Scenario 2: Changed macOS defaults

**install.sh approach**:
```bash
# Edit install.sh to skip steps? Or re-run all?
./install.sh  # Inefficient
```

**Taskfile approach**:
```bash
./task configure-macos  # Just settings (10 sec)
```

### Scenario 3: Fixed stow conflict

**install.sh approach**:
```bash
mv ~/.gitconfig ~/.gitconfig.backup
./install.sh  # Re-runs everything
```

**Taskfile approach**:
```bash
mv ~/.gitconfig ~/.gitconfig.backup
./task stow-all  # Just symlinks (5 sec)
```

### Scenario 4: New machine

**Both**:
```bash
./install.sh   # OR
./task install # Same workflow
```

---

## Discoverability Value

### Help Output

```
$ ./task help

WORKFLOWS:
  install              Full installation
  update               Update all packages

PACKAGE MANAGERS:
  install-homebrew     Install Homebrew (macOS)
  install-brew-packages Install Brewfile packages
  install-apt-packages Install apt.txt packages

DOTFILES:
  stow-common          Symlink common dotfiles
  stow-macos           Symlink macOS dotfiles
  stow-all             Symlink all dotfiles

CONFIGURATION:
  configure-macos      Apply macOS defaults
```

**Value**: Clear visibility of capabilities.

---

## Decision Matrix Updated

| Factor | install.sh | Taskfile (granular) | Winner |
|--------|-----------|---------------------|--------|
| Fresh install | Simple | Simple | Tie |
| Partial updates | Re-run all | Granular commands | Taskfile |
| Development speed | Slow iteration | Fast iteration | Taskfile |
| Discoverability | None | help command | Taskfile |
| Complexity | Lower | Higher | install.sh |
| Maintainability | Medium | High | Taskfile |
| Zero dependencies | Yes | Yes | Tie |

---

## Recommendation Update

**Use Taskfile pattern with granular commands**

**Why**:

1. **Real-world proven** - janikvonrotz's 1,442-line task file shows pattern scales
2. **Development velocity** - Iterate faster with granular commands
3. **User flexibility** - Power users can run specific tasks
4. **Same full install** - `./task install` works like `./install.sh`
5. **Future-proof** - Easy to add `update`, `backup`, `restore`
6. **Zero cost** - Still pure bash, no new dependencies

**Structure benefits**:
- Each package manager = separate task
- Each dotfile group = separate task
- Each config step = separate task
- Compose tasks for workflows

---

## Migration Path

1. Create `task` file with granular commands
2. Keep `install.sh` as alias: `#!/bin/bash\n./task install "$@"`
3. Users can use either
4. Deprecate install.sh later

---

## Related

- [taskfile-analysis.md](taskfile-analysis.md) - Pattern overview
- [index.md](index.md) - Research summary
- [../specs/install-script.md](../specs/install-script.md) - Current spec (needs update)
