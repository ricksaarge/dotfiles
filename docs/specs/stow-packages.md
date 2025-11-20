# Stow Packages

**Dotfile organization and symlinking**

---

## Overview

GNU Stow manages dotfile symlinks.

**Structure**: 3 packages (stow-common, stow-macos, stow-ubuntu)

---

## Package Organization

| Package | Platform | Contains |
|---------|----------|----------|
| stow-common | Both | Cross-platform dotfiles |
| stow-macos | macOS | macOS-specific dotfiles |
| stow-ubuntu | Ubuntu | Ubuntu-specific dotfiles |

---

## stow-common/

### Purpose

Cross-platform dotfiles shared between macOS and Ubuntu.

### Contents

| File | Purpose |
|------|---------|
| .gitconfig.template | Git config template with ${VARS} |
| .gitconfig | Generated config (gitignored) |
| .vimrc | Vim configuration |
| .config/starship.toml | Terminal prompt config (shared) |

### MUST NOT Include

Shell configs (platform-specific).

---

## stow-macos/

### Purpose

macOS-specific dotfiles.

### Contents

| File | Purpose |
|------|---------|
| .zshrc | Zsh config + Starship init |
| .zprofile | Zsh login shell config |

### .zshrc Requirements

**MUST** include Starship init:

```bash
eval "$(starship init zsh)"
```

**MUST** run after Starship installation.

---

## stow-ubuntu/

### Purpose

Ubuntu-specific dotfiles.

### Contents

| File | Purpose |
|------|---------|
| .bashrc | Bash config + Starship init |
| .bash_profile | Bash login shell config |

### .bashrc Requirements

**MUST** include Starship init:

```bash
eval "$(starship init bash)"
```

**MUST** run after Starship installation.

---

## Stow Execution

### Command Sequence

```bash
# 1. Common dotfiles (both platforms)
stow -d . -t ~ stow-common

# 2. Platform-specific dotfiles
stow -d . -t ~ "stow-$OS"
```

### Parameters

| Flag | Value | Purpose |
|------|-------|---------|
| -d | . | Stow directory (repo root) |
| -t | ~ | Target directory (home) |
| Package | stow-common or stow-$OS | Package name |

### Result

| Source | Symlink Target |
|--------|----------------|
| stow-common/.gitconfig | ~/.gitconfig |
| stow-common/.vimrc | ~/.vimrc |
| stow-common/.config/starship.toml | ~/.config/starship.toml |
| stow-macos/.zshrc | ~/.zshrc (macOS) |
| stow-ubuntu/.bashrc | ~/.bashrc (Ubuntu) |

---

## Conflict Handling

### Stow Behavior

Stow fails if target file exists and is NOT a symlink.

### Error Example

```
ERROR: stow: WARNING! stowing stow-common would cause conflicts:
  * existing target is neither a link nor a directory: .gitconfig
```

### Resolution

```bash
# Move existing file
mv ~/.gitconfig ~/.gitconfig.backup

# Re-run stow
stow -d . -t ~ stow-common
```

**Script behavior**: Exit 1 on conflict (fail fast).

---

## Idempotency

### Re-stowing

```bash
# First run: creates symlinks
stow -d . -t ~ stow-common

# Second run: updates symlinks (safe)
stow -d . -t ~ stow-common
```

**Behavior**: Stow detects existing symlinks and updates them.

---

## Directory Structure in Packages

### Nested Directories

Stow preserves directory structure.

**Example**:

```
stow-common/
└── .config/
    ├── starship.toml
    └── nvim/
        └── init.vim
```

**Result**:

```
~/
└── .config/
    ├── starship.toml -> dotfiles/stow-common/.config/starship.toml
    └── nvim/
        └── init.vim -> dotfiles/stow-common/.config/nvim/init.vim
```

---

## Adding New Dotfiles

### Process

| Step | Action |
|------|--------|
| 1 | Determine platform (common/macos/ubuntu) |
| 2 | Add file to appropriate stow-*/ directory |
| 3 | Commit to git |
| 4 | Run `./task stow-common` (re-stow) |

### Example: Add tmux config

```bash
# Create file (cross-platform)
vim stow-common/.tmux.conf

# Commit
git add stow-common/.tmux.conf
git commit -m "Add tmux config"

# Deploy
./task stow-common
```

---

## Generated vs Static Files

### Static Files

**Committed to git**:

- .vimrc
- .zshrc
- .bashrc
- .config/starship.toml

### Generated Files

**NOT committed** (gitignored):

- .gitconfig (generated from .gitconfig.template)

**Generation** happens in `configure-git` task before stow.

---

## .gitconfig Template

### Template File

**Location**: stow-common/.gitconfig.template

**Content**:

```ini
[user]
    name = ${GIT_USER_NAME}
    email = ${GIT_USER_EMAIL}
[github]
    user = ${GITHUB_USERNAME}
[core]
    editor = vim
```

### Generated File

**Location**: stow-common/.gitconfig (gitignored)

**Generation**:

```bash
envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
```

**MUST** run before stow commands.

---

## Shell Config Pattern

### macOS (.zshrc)

```bash
# Starship prompt (REQUIRED)
eval "$(starship init zsh)"

# Aliases
alias ll="ls -la"
alias gs="git status"

# Environment
export EDITOR=vim
```

### Ubuntu (.bashrc)

```bash
# Starship prompt (REQUIRED)
eval "$(starship init bash)"

# Aliases
alias ll="ls -la"
alias gs="git status"

# Environment
export EDITOR=vim
```

---

## Validation

### Check Symlinks

```bash
# List symlinks in home directory
ls -la ~/ | grep stow

# Verify specific file
ls -l ~/.gitconfig
# Output: ~/.gitconfig -> dotfiles/stow-common/.gitconfig
```

### Test Config Loading

```bash
# Restart shell
exec $SHELL

# Verify Starship
echo $STARSHIP_CONFIG
# Output: /Users/user/.config/starship.toml
```

---

## Removal

### Unstow Packages

```bash
# Remove common dotfiles
stow -D -d . -t ~ stow-common

# Remove platform-specific
stow -D -d . -t ~ "stow-$OS"
```

**Result**: Removes symlinks, leaves files in stow-*/ directories.

---

## Related

- [install-script.md](install-script.md) - Stow execution
- [configuration.md](configuration.md) - .gitconfig generation
- [package-management.md](package-management.md) - Starship installation
- [../architecture/index.md](../architecture/index.md) - Directory structure
