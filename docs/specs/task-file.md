# task File Specification

**Taskfile-pattern task runner for dotfiles**

---

## Overview

| Property | Value |
|----------|-------|
| File | task |
| Language | Bash |
| Shell flags | set -euo pipefail |
| Pattern | Taskfile (function-based dispatcher) |
| Dependency | vendor/bash-utility |

---

## Structure

| Section | Purpose |
|---------|---------|
| Shebang + flags | Environment setup |
| Load bash-utility | Source labbots/bash-utility |
| Utilities | Private helper functions (_prefix) |
| Package managers | Homebrew, Stow install |
| Packages | Brew, apt installation |
| Dotfiles | Stow commands per package |
| Language setup | nvm, pyenv |
| Configuration | Git config, macOS defaults |
| Workflows | Composite tasks (install, update) |
| Help | Command listing |
| Dispatcher | Function router |

---

## Naming Convention

### Private Functions

| Function | Purpose |
|----------|---------|
| `_info` | Log to stdout |
| `_success` | Log success message |
| `_error` | Log to stderr, exit 1 |
| `_platform` | Detect OS (returns: mac, linux) |
| `_has_cmd` | Check command exists |

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
| install-brew-packages | macOS | `brew bundle install` |
| install-apt-packages | Ubuntu | `xargs apt install < apt.txt` |
| install-starship | Ubuntu | Curl installer (not in apt) |

### Dotfiles

| Task | Platform | Purpose |
|------|----------|---------|
| stow-common | Both | Symlink stow-common/ |
| stow-macos | macOS | Symlink stow-macos/ |
| stow-ubuntu | Ubuntu | Symlink stow-ubuntu/ |

### Language Setup

| Task | Platform | Purpose |
|------|----------|---------|
| setup-nvm | Both | Install Node.js via nvm |
| setup-pyenv | Both | Install Python via pyenv |

### Configuration

| Task | Platform | Purpose |
|------|----------|---------|
| configure-git | Both | Generate ~/.gitconfig.local from .env |
| configure-macos | macOS | Run ~/bin/macos-defaults |

### Workflows

| Task | Purpose |
|------|---------|
| install | Full installation (all steps) |
| update | Update all packages |
| help | Show available commands |

---

## Platform Detection

### Implementation

```bash
_platform() {
    os::detect_os  # Returns: mac, linux
}
```

### Task Guards

```bash
task-name() {
    [[ "$(_platform)" != "mac" ]] && return
    # macOS-only logic
}
```

**Result**: Silent skip on wrong platform.

---

## Error Handling

| Behavior | Implementation |
|----------|----------------|
| Fail fast | set -euo pipefail |
| Exit on error | -e flag |
| Undefined vars | -u flag |
| Pipeline failures | -o pipefail |
| Error messages | `_error()` to stderr |
| Exit codes | 0=success, 1=failure |

---

## Idempotency

| Task | First Run | Second Run |
|------|-----------|------------|
| install-homebrew | Installs | Skips (exists) |
| install-stow | Installs | Skips (pkg manager handles) |
| install-brew-packages | Installs all | Skips installed |
| stow-common | Creates symlinks | Updates symlinks |
| configure-git | Creates file | Overwrites (safe) |
| configure-macos | Applies settings | Overwrites (safe) |

**All tasks MUST be safe to re-run.**

---

## Dispatcher

```bash
if declare -f "$1" >/dev/null 2>&1; then
    "$1" "${@:2}"
else
    echo "Unknown command: $1"
    help
    exit 1
fi
```

---

## Usage

### Full Installation

```bash
./task install
```

### Individual Tasks

```bash
./task install-homebrew
./task install-brew-packages
./task stow-common
./task configure-git
./task configure-macos
./task setup-nvm
./task setup-pyenv
```

### Update

```bash
./task update
```

### Help

```bash
./task help
```

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

---

## Related

- [macos-defaults.md](macos-defaults.md) - macOS settings script
- [package-management.md](package-management.md) - Brewfile/apt.txt
- [stow-packages.md](stow-packages.md) - Stow organization
- [configuration.md](configuration.md) - .env handling
