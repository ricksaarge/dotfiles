# Research: Shell Configuration

**SELECTED: Platform-specific configs (zsh for macOS, bash for Ubuntu)**

**Why**: Respect platform defaults, cleaner than universal .profile hacks

---

## Decision

| Selected | Reason |
|----------|--------|
| Platform-specific | stow-macos/.zshrc + stow-ubuntu/.bashrc |

**Rejected**: Universal .profile (forces shell switching, fragile)

---

## Problem

Different default shells across platforms:
- macOS: zsh (default since Catalina 10.15)
- Ubuntu: bash (default)

**Impact**: Shell configuration files must be platform-specific

---

## Default Shells by Platform

| Platform | Default Shell | Version | Since |
|----------|---------------|---------|-------|
| macOS | zsh | 5.8+ | Catalina (2019) |
| Ubuntu | bash | 5.0+ | Always |

---

## Shell Configuration Files

### zsh (macOS)

| File | Purpose | Load Order |
|------|---------|------------|
| `.zshenv` | Always loaded | 1 |
| `.zprofile` | Login shells | 2 |
| `.zshrc` | Interactive shells | 3 |
| `.zlogin` | Login shells (after .zshrc) | 4 |
| `.zlogout` | Logout | 5 |

**Primary config**: `.zshrc`

### bash (Ubuntu)

| File | Purpose | Load Order |
|------|---------|------------|
| `.bash_profile` | Login shells | 1 |
| `.bashrc` | Interactive shells | 2 |
| `.bash_logout` | Logout | 3 |

**Primary config**: `.bashrc`

---

## Stow Directory Strategy

### Option 1: Platform-Specific Only

```
stow-macos/
  └── .zshrc

stow-ubuntu/
  └── .bashrc
```

**Pros**:
- Clear separation
- No conditional logic in configs
- Easy to maintain

**Cons**:
- Duplicated shared logic
- Harder to keep in sync

### Option 2: Shared + Platform-Specific

```
stow-common/
  └── shell/
      └── aliases.sh      # Sourced by both

stow-macos/
  └── .zshrc             # Sources shell/aliases.sh

stow-ubuntu/
  └── .bashrc            # Sources shell/aliases.sh
```

**Pros**:
- Shared logic in one place
- DRY principle
- Easier to maintain common aliases

**Cons**:
- More complex structure
- Sourcing dependencies

### Option 3: Conditional Single File

```
stow-common/
  └── .shellrc           # Sourced by both shells
```

**Pros**:
- Single source of truth
- Maximum code reuse

**Cons**:
- Shell-specific features break
- Complex conditional logic
- Not idiomatic

---

## Decision

**REQUIRED**: Option 1 (Platform-Specific Only)

### Rationale

| Reason | Weight |
|--------|--------|
| Simplicity | High |
| No dependencies | High |
| Idiomatic per platform | High |
| Clear ownership | Medium |

### Implementation

| Platform | Stow Package | Files |
|----------|--------------|-------|
| macOS | `stow-macos/` | `.zshrc`, `.zprofile` |
| Ubuntu | `stow-ubuntu/` | `.bashrc`, `.bash_profile` |

---

## Shared Configuration

**For truly shared items** (git, vim, etc.):

```
stow-common/
├── .gitconfig
├── .vimrc
└── .config/
    └── (app configs)
```

**NOT for shell configs** - keep separate

---

## Shell Feature Compatibility

### Common Features

| Feature | zsh | bash | Notes |
|---------|-----|------|-------|
| Aliases | ✅ | ✅ | Compatible syntax |
| Functions | ✅ | ✅ | Compatible syntax |
| Environment vars | ✅ | ✅ | Compatible syntax |
| Path manipulation | ✅ | ✅ | Compatible syntax |

### zsh-Specific Features

| Feature | Support |
|---------|---------|
| Extended globbing | zsh only |
| Array indexing (1-based) | zsh only |
| Prompt themes (oh-my-zsh) | zsh only |
| Auto-correction | zsh only |

### bash-Specific Features

| Feature | Support |
|---------|---------|
| Array indexing (0-based) | bash only |
| `[[` vs `[` differences | bash only |

---

## Migration Strategy

### macOS Users

**No action needed** if already using zsh

**If using bash on macOS**:
- Not supported
- User must switch to zsh
- Or manually maintain .bashrc

### Ubuntu Users

**No action needed** - bash default

**If user wants zsh on Ubuntu**:
- Not supported initially
- Add to future enhancements

---

## File Content Strategy

### macOS .zshrc

```bash
# Platform: macOS
# Shell: zsh

# Environment
export EDITOR="vim"
export PATH="$HOME/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Aliases (macOS-specific)
alias ll="ls -lah"
alias update="brew update && brew upgrade"

# zsh-specific features
setopt AUTO_CD
setopt CORRECT
```

### Ubuntu .bashrc

```bash
# Platform: Ubuntu
# Shell: bash

# Environment
export EDITOR="vim"
export PATH="$HOME/bin:$PATH"

# Aliases (Ubuntu-specific)
alias ll="ls -lah --color=auto"
alias update="sudo apt update && sudo apt upgrade"

# bash-specific features
shopt -s autocd
shopt -s cdspell
```

---

## Stow Execution

### Installation

```bash
# macOS
stow -d . -t ~ stow-common
stow -d . -t ~ stow-macos

# Ubuntu
stow -d . -t ~ stow-common
stow -d . -t ~ stow-ubuntu
```

**Result**:
- macOS: `~/.zshrc` symlinked
- Ubuntu: `~/.bashrc` symlinked
- Both: `~/.gitconfig`, `~/.vimrc` symlinked

---

## Testing

### Verification

| Platform | Command | Expected |
|----------|---------|----------|
| macOS | `echo $SHELL` | `/bin/zsh` |
| macOS | `ls -la ~/.zshrc` | Symlink to stow-macos/.zshrc |
| Ubuntu | `echo $SHELL` | `/bin/bash` |
| Ubuntu | `ls -la ~/.bashrc` | Symlink to stow-ubuntu/.bashrc |

---

## Edge Cases

### User Has Custom Shell

| Scenario | Action |
|----------|--------|
| User uses fish | Not supported |
| User uses tcsh | Not supported |
| User uses sh | Not supported |

**Decision**: Support only default shells

### Conflicting Files

| Scenario | Action |
|----------|--------|
| Existing .zshrc | Stow fails (safe) |
| Existing .bashrc | Stow fails (safe) |

**Decision**: User must backup/remove first

---

## Future Enhancements

| Feature | Priority | Complexity |
|---------|----------|------------|
| Optional zsh on Ubuntu | Low | Medium |
| Optional bash on macOS | Very Low | Low |
| Fish shell support | Very Low | High |
| Shared aliases extraction | Medium | Medium |

---

## Related

- [index.md](index.md) - Research index
- [inspiration.md](inspiration.md) - Dotfiles projects
- [settings.md](settings.md) - Settings management

---

**Conclusion**: Platform-specific shell configs REQUIRED in separate Stow packages
