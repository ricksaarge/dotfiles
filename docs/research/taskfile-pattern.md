# Taskfile Pattern Research

**SELECTED: Bash script pattern (NOT Taskfile.dev binary)**

**Why**: Zero dependencies, pure bash, hyphen-separated function names, proven at 1442 lines

---

## Decision

| Selected | Reason |
|----------|--------|
| Bash script with functions | No Go binary dependency |

**Rejected**: Taskfile.dev (requires Go binary), Make (requires make binary)

---

## Pattern Structure

**Source**: [janikvonrotz/dotfiles](https://codeberg.org/janikvonrotz/dotfiles/src/branch/main/task)

### Function Naming

**Format**: `action-object` (hyphen-separated, NOT `::`)

```bash
install-docker()
setup-hyprland()
backup-android-data()
configure-git()
```

**NO `task::` prefix** - that was incorrect assumption

### Dispatcher

```bash
#!/bin/bash
set -eo pipefail

# Functions defined here
install-homebrew() { ... }
configure-git() { ... }

# Dispatcher at end
if declare -f "$1" >/dev/null 2>&1; then
  "$1" "${@:2}"
else
  echo "Unknown command: $1"
  exit 1
fi
```

### Help System

```bash
help() {
  echo "Available commands:"
  declare -F | awk '{print $3}' | grep -v '^_' | sort
}

# Usage
./task help
./task help | grep install
```

---

## Platform Detection

```bash
# Export for global access
if command -v pacman >/dev/null 2>&1; then
  export PACKAGE_MANAGER="pacman"
elif command -v apt >/dev/null 2>&1; then
  export PACKAGE_MANAGER="apt"
elif command -v brew >/dev/null 2>&1; then
  export PACKAGE_MANAGER="brew"
fi
```

---

## Function Patterns

### Installation

```bash
install-homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}
```

### Configuration

```bash
configure-git() {
  [[ -f .env ]] || { echo ".env not found"; exit 1; }
  source .env
  envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
}
```

### Composite Tasks

```bash
install() {
  install-homebrew
  install-stow
  install-brew-packages
  configure-git
  stow-all
}
```

---

## Private Functions

**Prefix**: `_function_name`

```bash
_info() { echo "[INFO] $1"; }
_error() { echo "[ERROR] $1" >&2; exit 1; }
_has_cmd() { command -v "$1" >/dev/null 2>&1; }
```

**NOT callable** from command line (filtered by help)

---

## Example Usage

```bash
# Full install
./task install

# Granular operations
./task install-homebrew
./task configure-git
./task stow-common

# List commands
./task help
```

---

## File Structure

```bash
#!/bin/bash
set -eo pipefail

#------------------------------------------------------------------------------
# UTILITIES (private)
#------------------------------------------------------------------------------
_info() { ... }
_error() { ... }

#------------------------------------------------------------------------------
# PACKAGE MANAGERS
#------------------------------------------------------------------------------
install-homebrew() { ... }
install-stow() { ... }

#------------------------------------------------------------------------------
# PACKAGES
#------------------------------------------------------------------------------
install-brew-packages() { ... }
install-apt-packages() { ... }

#------------------------------------------------------------------------------
# DOTFILES
#------------------------------------------------------------------------------
stow-common() { ... }
stow-macos() { ... }

#------------------------------------------------------------------------------
# CONFIGURATION
#------------------------------------------------------------------------------
configure-git() { ... }
configure-macos() { ... }

#------------------------------------------------------------------------------
# WORKFLOWS
#------------------------------------------------------------------------------
install() { ... }
update() { ... }
help() { ... }

#------------------------------------------------------------------------------
# DISPATCHER
#------------------------------------------------------------------------------
if declare -f "$1" >/dev/null 2>&1; then
  "$1" "${@:2}"
else
  echo "Unknown command: $1"
  exit 1
fi
```

---

## Comparison: Pattern vs Taskfile.dev

| Aspect | Bash Pattern | Taskfile.dev |
|--------|--------------|--------------|
| Dependency | Zero (bash only) | Go binary |
| File | `task` (bash script) | `Taskfile.yml` (YAML) |
| Functions | Bash functions | YAML tasks |
| Platform | macOS/Linux built-in | Install required |
| Complexity | Simple | Additional abstraction |

---

## Key Insights

### 1. **No `::` Separator**

❌ **Wrong**: `task::install-homebrew`
✅ **Correct**: `install-homebrew`

### 2. **Hyphen Separation**

Use hyphens for multi-word functions:
- `install-homebrew` (not `install_homebrew`)
- `configure-git` (not `configure_git`)
- `stow-common` (not `stow_common`)

### 3. **Private Prefix**

Use underscore for internal functions:
- `_info` (private)
- `_error` (private)
- `install-homebrew` (public)

---

## Proven Scale

**janikvonrotz/dotfiles**: 1,442 lines, 60+ commands

Demonstrates pattern works for:
- Multi-distro (Arch, Ubuntu, Fedora)
- 60+ individual tools
- Complex workflows
- Production use

---

## Related

- [taskfile-analysis.md](taskfile-analysis.md) - Pattern evaluation
- [taskfile-real-world.md](taskfile-real-world.md) - 1442-line example
- [../specs/task-file.md](../specs/task-file.md) - Implementation spec
