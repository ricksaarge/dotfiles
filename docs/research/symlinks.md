# Research: Symlink Management

**SELECTED: GNU Stow**

**Why**: Directory structure = config (no YAML), standard Unix tool, sufficient features

---

## Decision

| Selected | Reason |
|----------|--------|
| GNU Stow | Simplicity + transparency + no config files |

**Rejected**: Dotbot (YAML overhead), manual scripts (reinventing wheel)

---

## Question

GNU Stow vs Dotbot vs manual scripts for symlink management?

---

## Tools Comparison

| Tool | Type | Configuration | Dependencies |
|------|------|---------------|--------------|
| GNU Stow | CLI tool | Directory structure | Stow binary |
| Dotbot | YAML-based installer | YAML config file | Self-contained Python |
| Manual scripts | Shell scripts | Code-based | None (bash only) |

---

## GNU Stow

### What It Is

Symlink farm manager originally designed for `/usr/local` software management.

**Core concept**: Directory structure defines symlinks

### How It Works

```bash
# Directory structure
stow-common/
  └── .gitconfig

# Command
stow -d . -t ~ stow-common

# Result
~/.gitconfig -> dotfiles/stow-common/.gitconfig
```

### Features

| Feature | Support |
|---------|---------|
| Symlink creation | ✅ Yes |
| Symlink removal | ✅ Yes (unstow) |
| Conflict detection | ✅ Yes |
| Dry run | ✅ Yes (-n flag) |
| Arbitrary commands | ❌ No |
| Configuration file | ❌ No (structure-based) |

### Pros

| Advantage | Impact |
|-----------|--------|
| Zero configuration | Just organize directories |
| Transparent | Direct symlinks, no abstraction |
| Standard Unix tool | Available in package managers |
| Simple mental model | Directory = symlinks |
| Minimal learning curve | Few commands to learn |
| Idempotent | Safe to re-run |

### Cons

| Disadvantage | Impact |
|--------------|--------|
| External dependency | Must install Stow |
| No automation | Just symlinks, no commands |
| Manual scripting needed | Shell wrapper for platform logic |
| No plugins | Limited to symlinking |

---

## Dotbot

### What It Is

Declarative dotfiles bootstrapper using YAML configuration.

**Core concept**: YAML config defines all installation steps

### How It Works

```yaml
# install.conf.yaml
- link:
    ~/.gitconfig: gitconfig
    ~/.vimrc: vimrc

- shell:
    - [brew bundle, Installing packages]
```

```bash
# Command
./install

# Result
Symlinks created + shell commands executed
```

### Features

| Feature | Support |
|---------|---------|
| Symlink creation | ✅ Yes |
| Symlink removal | ✅ Yes (clean) |
| Directory creation | ✅ Yes |
| Shell commands | ✅ Yes |
| Plugins | ✅ Yes |
| Configuration file | ✅ YAML/JSON |

### Pros

| Advantage | Impact |
|-----------|--------|
| Self-contained | No external dependencies |
| Declarative config | All in one YAML file |
| Automation | Symlinks + shell commands + more |
| Plugin system | Extensible functionality |
| Single install script | One-command setup |
| Idempotent | Safe to re-run |

### Cons

| Disadvantage | Impact |
|--------------|--------|
| Abstraction layer | Less transparent than Stow |
| YAML required | Configuration learning curve |
| Python dependency | Self-contained but needs Python |
| Less standard | Not in default package repos |

---

## Detailed Comparison

### Installation

**GNU Stow**:
```bash
# macOS
brew install stow

# Ubuntu
sudo apt install stow
```

**Dotbot**:
```bash
# Option 1: Git submodule (recommended)
git submodule add https://github.com/anishathalye/dotbot

# Option 2: PyPI
pipx install dotbot
```

### Basic Usage

**GNU Stow**:
```bash
# Install
stow -d . -t ~ stow-common
stow -d . -t ~ stow-macos

# Uninstall
stow -D -t ~ stow-common

# Dry run
stow -n -d . -t ~ stow-common
```

**Dotbot**:
```yaml
# install.conf.yaml
- link:
    ~/.gitconfig: stow-common/.gitconfig
    ~/.vimrc: stow-common/.vimrc
    ~/.zshrc:
      if: '[ "$(uname)" = Darwin ]'
      path: stow-macos/.zshrc
```

```bash
./install
```

### Platform-Specific Logic

**GNU Stow** (requires shell script):
```bash
#!/bin/bash
case "$(uname -s)" in
  Darwin)
    stow -d . -t ~ stow-common
    stow -d . -t ~ stow-macos
    ;;
  Linux)
    stow -d . -t ~ stow-common
    stow -d . -t ~ stow-ubuntu
    ;;
esac
```

**Dotbot** (in YAML):
```yaml
- link:
    ~/.gitconfig: stow-common/.gitconfig
    ~/.zshrc:
      if: '[ "$(uname)" = Darwin ]'
      path: stow-macos/.zshrc
    ~/.bashrc:
      if: '[ "$(uname)" = Linux ]'
      path: stow-ubuntu/.bashrc
```

### Complexity

| Aspect | GNU Stow | Dotbot |
|--------|----------|--------|
| Core tool | Very simple | Simple |
| Platform logic | Shell script (medium) | YAML conditionals (medium) |
| Total complexity | Low-Medium | Medium |

---

## Real-World Usage

### GNU Stow Adoption

| Project | Usage |
|---------|-------|
| webpro/dotfiles | Uses Stow |
| Many dotfiles repos | Common choice |
| Community | Large user base |

**Pattern**: Popular among simplicity-focused developers

### Dotbot Adoption

| Project | Usage |
|---------|-------|
| anishathalye/dotfiles | Creator's dotfiles |
| Various repos | Growing adoption |
| Community | Active development |

**Pattern**: Popular among automation-focused developers

---

## Decision Factors

### For This Project

| Factor | GNU Stow | Dotbot | Winner |
|--------|----------|--------|--------|
| Simplicity | Simpler core tool | More abstraction | Stow |
| Transparency | Very transparent | Less transparent | Stow |
| Dependencies | Needs Stow installed | Self-contained | Dotbot |
| Learning curve | Minimal | Medium | Stow |
| Flexibility | Just symlinks | Symlinks + automation | Dotbot |
| Our needs | Sufficient | More than needed | Stow |

### Project Requirements

| Requirement | GNU Stow | Dotbot |
|-------------|----------|--------|
| Cross-platform dotfiles | ✅ Yes (with script) | ✅ Yes (with YAML) |
| Platform-specific configs | ✅ Yes (stow-macos/) | ✅ Yes (conditionals) |
| Symlink management | ✅ Yes | ✅ Yes |
| Additional automation | ❌ Need scripts | ✅ Built-in |
| Simple mental model | ✅ Yes | ⚠️  More complex |

---

## Philosophy Alignment

### Project Principles

| Principle | GNU Stow | Dotbot |
|-----------|----------|--------|
| Simplicity | ✅ Perfect fit | ⚠️  More features than needed |
| Transparency | ✅ Perfect fit | ⚠️  Abstraction layer |
| Maintainability | ✅ Easy to understand | ✅ Centralized config |
| Standard tools | ✅ Unix philosophy | ⚠️  Custom tool |

---

## Decision

**REQUIRED**: GNU Stow

### Rationale

| Reason | Weight | Notes |
|--------|--------|-------|
| Simplicity | High | Aligns with core principles |
| Transparency | High | No abstraction, just symlinks |
| Standard tool | Medium | Available in package managers |
| Sufficient features | High | Meets all requirements |
| Community adoption | Medium | Well-established pattern |

### Trade-offs Accepted

| Trade-off | Mitigation |
|-----------|------------|
| External dependency | Install Stow in install.sh |
| Need shell scripts | Already using shell scripts |
| No built-in automation | Scripts handle automation |

---

## Implementation

### Directory Structure

```
dotfiles/
├── stow-common/
│   ├── .gitconfig
│   └── .vimrc
├── stow-macos/
│   └── .zshrc
└── stow-ubuntu/
    └── .bashrc
```

### Installation Script

```bash
#!/usr/bin/env bash
set -euo pipefail

# Detect platform
case "$(uname -s)" in
  Darwin)
    OS="macos"
    ;;
  Linux)
    OS="ubuntu"
    ;;
esac

# Install Stow if needed
if ! command -v stow &> /dev/null; then
  case "$OS" in
    macos)
      brew install stow
      ;;
    ubuntu)
      sudo apt install -y stow
      ;;
  esac
fi

# Stow packages
stow -d . -t ~ stow-common
stow -d . -t ~ "stow-$OS"
```

---

## Dotbot Alternative

**IF** requirements change in future:

| Scenario | Consider Dotbot |
|----------|-----------------|
| Need plugin ecosystem | Package managers, crontab, etc. |
| Want single config file | All in YAML vs scripts |
| Self-contained priority | No external dependencies |
| Complex workflows | Built-in command execution |

**Current assessment**: Not needed

---

## Edge Cases

### Existing Dotfiles

| Scenario | GNU Stow | Dotbot |
|----------|----------|--------|
| Conflict detection | ✅ Fails safely | ✅ Fails safely |
| Backup needed | Manual | Manual |
| Force overwrite | `--adopt` flag | Force option |

### Uninstall

| Operation | GNU Stow | Dotbot |
|-----------|----------|--------|
| Remove symlinks | `stow -D` | Re-run with different config |
| Clean broken links | Manual | Built-in clean |

---

## Testing

### Verification

```bash
# Check symlinks created
ls -la ~/ | grep stow-common

# Verify targets
readlink ~/.gitconfig
# Expected: dotfiles/stow-common/.gitconfig

# Test idempotency
./install.sh
./install.sh  # Should not fail
```

---

## Alternative: Manual Scripts

### Pros

| Advantage |
|-----------|
| Zero dependencies |
| Full control |
| Maximum transparency |

### Cons

| Disadvantage |
|--------------|
| Manual symlink management |
| Error-prone |
| Reinventing the wheel |

**Decision**: Not worth it, Stow is simple enough

---

## Future Considerations

| Feature | Priority | Tool |
|---------|----------|------|
| Current approach | - | GNU Stow |
| Plugin ecosystem | Low | Consider Dotbot |
| No dependencies | Very Low | Manual scripts |

---

## Related

- [index.md](index.md) - Research index
- [inspiration.md](inspiration.md) - Dotfiles projects
- [orchestrator.md](orchestrator.md) - Install orchestration

---

**Conclusion**: GNU Stow REQUIRED for symlink management (simplicity and transparency)
