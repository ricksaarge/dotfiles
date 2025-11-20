# Taskfile Pattern Analysis

**SELECTED: Taskfile pattern (bash script with task functions)**

**Why**: Granular commands, zero dependencies, discoverable via help, proven at 1442 lines

---

## Decision

| Selected | Reason |
|----------|--------|
| Taskfile pattern | Pure bash + granular + discoverable |

**Rejected**: Single install.sh (no task granularity)

---

## Overview

| Property | Value |
|----------|-------|
| Tool | Taskfile (https://taskfile.build) |
| Type | Bash script pattern/convention |
| Dependencies | Zero (pure bash) |
| Origin | Adrian Cooney's Taskfile pattern |

---

## What is Taskfile?

**NOT a binary tool** - It's a bash script pattern/convention.

**Core concept**: Single bash script named `Taskfile` in project root with standardized function names.

### Pattern

```bash
#!/bin/bash

function install {
    # Installation logic
}

function build {
    # Build logic
}

function help {
    echo "Available tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
```

### Usage

```bash
# Add alias
alias task='./Taskfile'

# Run tasks
task install
task build
task help
```

---

## Comparison to Current Approach

| Aspect | install.sh | Taskfile Pattern | Winner |
|--------|-----------|------------------|--------|
| Dependencies | Zero | Zero | Tie |
| Entry point | ./install.sh | ./Taskfile <task> | install.sh |
| Structure | Functions + main() | Functions + ${@:-default} | Tie |
| Discoverability | None | help command | Taskfile |
| Naming | Custom | Action-Object pattern | Taskfile |
| Time tracking | None | Built-in TIMEFORMAT | Taskfile |
| Simplicity | Single purpose | Multi-purpose | install.sh |

---

## Taskfile.build Conventions

### Naming Pattern

**Action + Object** (kebab-case):

| Pattern | Examples |
|---------|----------|
| install-X | install-dependencies, install-homebrew |
| configure-X | configure-macos, configure-shell |
| generate-X | generate-gitconfig |
| check-X | check-env, check-platform |

### Standard Actions

| Action | Purpose |
|--------|---------|
| install | Install dependencies/packages |
| build | Build/compile artifacts |
| test | Run tests |
| lint | Lint code |
| deploy | Deploy application |
| clean | Clean build artifacts |
| help | List available tasks |

---

## Example Taskfile for Dotfiles

```bash
#!/bin/bash
set -euo pipefail

PATH=./node_modules/.bin:$PATH

#------------------------------------------------------------------------------
# UTILITIES
#------------------------------------------------------------------------------
function _info { echo "[INFO] $1"; }
function _error { echo "[ERROR] $1" >&2; exit 1; }
function _has-cmd { command -v "$1" &>/dev/null; }

#------------------------------------------------------------------------------
# ENVIRONMENT
#------------------------------------------------------------------------------
function check-env {
    [[ -f ".env" ]] || _error ".env not found"
    set -a; source .env; set +a
    [[ -z "${GIT_USER_NAME:-}" ]] && _error "GIT_USER_NAME required"
    [[ -z "${GIT_USER_EMAIL:-}" ]] && _error "GIT_USER_EMAIL required"
}

#------------------------------------------------------------------------------
# PLATFORM
#------------------------------------------------------------------------------
function detect-platform {
    case "$(uname -s)" in
        Darwin) export OS="macos" ;;
        Linux)  export OS="ubuntu" ;;
        *)      _error "Unsupported OS" ;;
    esac
    _info "Platform: $OS"
}

#------------------------------------------------------------------------------
# DEPENDENCIES
#------------------------------------------------------------------------------
function install-xcode-clt {
    [[ "$OS" != "macos" ]] && return
    xcode-select -p &>/dev/null && return
    _info "Installing Xcode Command Line Tools..."
    xcode-select --install
    read -p "Press Enter after installation..."
}

function install-homebrew {
    [[ "$OS" != "macos" ]] && return
    _has-cmd brew && return
    _info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install-stow {
    _has-cmd stow && return
    case "$OS" in
        macos)  brew install stow ;;
        ubuntu) sudo apt update && sudo apt install -y stow ;;
    esac
}

function install-dependencies {
    detect-platform
    install-xcode-clt
    install-homebrew
    install-stow
}

#------------------------------------------------------------------------------
# PACKAGES
#------------------------------------------------------------------------------
function install-packages-macos {
    [[ "$OS" != "macos" ]] && return
    _info "Installing packages via Homebrew..."
    brew bundle
}

function install-packages-ubuntu {
    [[ "$OS" != "ubuntu" ]] && return
    _info "Installing packages via apt..."
    xargs sudo apt install -y < apt.txt
}

function install-packages {
    install-packages-macos
    install-packages-ubuntu
}

#------------------------------------------------------------------------------
# DOTFILES
#------------------------------------------------------------------------------
function generate-gitconfig {
    check-env
    _info "Generating .gitconfig..."
    envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
}

function install-dotfiles {
    generate-gitconfig
    _info "Symlinking dotfiles..."
    stow -d . -t ~ stow-common
    stow -d . -t ~ "stow-$OS"
}

#------------------------------------------------------------------------------
# OS CONFIGURATION
#------------------------------------------------------------------------------
function configure-macos {
    [[ "$OS" != "macos" ]] && return
    _info "Configuring macOS defaults..."
    ./macos-defaults.sh
}

function configure-os {
    configure-macos
}

#------------------------------------------------------------------------------
# MAIN TASKS
#------------------------------------------------------------------------------
function install {
    check-env
    install-dependencies
    install-packages
    install-dotfiles
    configure-os
    _info "Done! Restart terminal."
}

function help {
    echo "Usage: ./Taskfile <task>"
    echo ""
    echo "Tasks:"
    compgen -A function | grep -v "^_" | sed 's/^/  /'
}

#------------------------------------------------------------------------------
# EXECUTION
#------------------------------------------------------------------------------
TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
```

---

## Advantages

| Benefit | Description |
|---------|-------------|
| Zero dependencies | Pure bash, no binary install |
| Discoverability | help command lists all tasks |
| Composability | Tasks call other tasks |
| Time tracking | Built-in execution timing |
| Multi-purpose | Run individual steps or full install |
| Standard pattern | Recognizable across projects |

---

## Disadvantages

| Drawback | Description |
|----------|-------------|
| Execution model | time ${@:-help} less intuitive than main() |
| Naming overhead | Action-Object more verbose |
| Function prefix | Need _prefix for private functions |
| Pattern complexity | More structure than simple script |

---

## Use Cases

### Taskfile Pattern Best For

- Multi-command projects (build, test, deploy)
- Reusable task libraries
- Developer workflows with many operations
- Projects with complex CI/CD

### Simple Script Best For

- Single-purpose installers
- One-time setup scripts
- Minimal operations (1-3 tasks)
- Personal dotfiles (this project)

---

## Decision for This Project

### Current Approach

```bash
#!/usr/bin/env bash
set -euo pipefail

# Utilities
info() { echo "[INFO] $1"; }

# Functions
install_dependencies() { ... }
install_packages() { ... }

# Main
main() {
    install_dependencies
    install_packages
}

main "$@"
```

### Taskfile Approach

```bash
#!/bin/bash
set -euo pipefail

function install-dependencies { ... }
function install-packages { ... }
function install {
    install-dependencies
    install-packages
}

time ${@:-install}
```

### Analysis

| Criterion | install.sh | Taskfile | Winner |
|-----------|-----------|----------|--------|
| Primary use | Single install command | Single install command | Tie |
| Sub-tasks needed | No (run full install) | No (run full install) | Tie |
| Complexity | ~150 lines | ~150 lines (same) | Tie |
| Pattern familiarity | Standard bash | Taskfile convention | install.sh |
| Time to understand | Low | Medium (learn pattern) | install.sh |

---

## Recommendation

**KEEP current install.sh approach**

**Rationale**:

1. **Single purpose** - Dotfiles installer runs once (full install)
2. **No sub-tasks** - Don't need `task install-homebrew` separately
3. **Simplicity** - `./install.sh` clearer than `./Taskfile install`
4. **No discovery needed** - One command, no help system needed
5. **Standard** - Shell script + main() is universal pattern

**Taskfile adds structure without benefit** for this use case.

---

## When to Use Taskfile Pattern

Consider Taskfile if:

| Scenario | Example |
|----------|---------|
| Multiple commands | task build, task test, task deploy |
| Developer workflow | task lint, task format, task check |
| Reusable tasks | Source functions across projects |
| Complex CI/CD | task ci-test, task ci-deploy |

**Not applicable** to single-purpose dotfiles installer.

---

## Alternative: Hybrid

Keep install.sh, add Taskfile for **development tasks**:

```bash
#!/bin/bash
# Taskfile - development tasks

function lint-docs {
    grep -rn "should\|might\|could" docs/ --include="*.md"
}

function check-line-length {
    wc -l docs/**/*.md | awk '$1 > 500 {print}'
}

function validate-docs {
    lint-docs
    check-line-length
}

time ${@:-help}
```

**Separate concerns**: install.sh = production, Taskfile = development.

---

## Conclusion

**Original analysis (contradicted by final decision)**:

| Original Recommendation | Reason |
|--------------------------|--------|
| Keep install.sh | Single-purpose installer |
| MAY add Taskfile | For development tasks only |
| NOT replacing install.sh | No benefit, adds complexity |

---

## FINAL DECISION (Override)

**SELECTED: Taskfile pattern**

**Reason for override**: Granular task execution during development

| Benefit | Impact |
|---------|--------|
| Granular re-run | `./task stow-common` vs full re-install |
| Development velocity | Test single component changes |
| Discoverability | `./task help` shows all tasks |
| Proven at scale | 1442-line real-world example |

**Trade-off accepted**: Slightly more complex entry point for better dev experience

---

## Related

- [index.md](index.md) - Decision summary
- [../specs/install-script.md](../specs/install-script.md) - Current spec
- https://taskfile.build - Pattern documentation
- https://github.com/adriancooney/Taskfile - Original pattern
