# Research: Settings Management

**SELECTED: defaults write (custom script)**

**Why**: Mackup cannot manage macOS system preferences (Dock/Finder/input)

---

## Decision

| Selected | Reason |
|----------|--------|
| Custom defaults script | Only way to manage macOS system settings |

**Rejected**: Mackup (app configs only, no system preferences)

---

## Problem

Backup and restore:
- macOS system preferences (Dock, Finder, mouse speed)
- Application preferences (VSCode, Terminal)
- Cross-platform configurations

---

## Mackup Analysis

### What Mackup Does

| Feature | Status |
|---------|--------|
| Application configs | ✅ Supported |
| Dotfiles | ✅ Supported |
| Sync to cloud | ✅ Dropbox/Drive |
| 500+ apps | ✅ Built-in support |

### What Mackup Does NOT Do

| Feature | Status | Alternative |
|---------|--------|-------------|
| macOS system preferences | ❌ Not supported | `defaults write` |
| Dock configuration | ❌ Not supported | Custom script |
| Finder layout | ❌ Not supported | Custom script |
| Mouse/trackpad speed | ❌ Not supported | Custom script |
| System settings | ❌ Not supported | Custom script |

### Mackup Supported Apps

**Examples** (partial list):

| Category | Apps |
|----------|------|
| Editors | VSCode, Sublime, Vim, Emacs |
| Shells | Bash, Zsh, Fish |
| Dev tools | Git, SSH, AWS CLI, Docker |
| Terminal | iTerm2, Terminal |

**Full list**: https://github.com/lra/mackup/tree/master/mackup/applications

---

## macOS System Preferences

### Storage Location

| Setting | Plist File |
|---------|------------|
| Dock | `~/Library/Preferences/com.apple.dock.plist` |
| Finder | `~/Library/Preferences/com.apple.finder.plist` |
| Mouse | `~/Library/Preferences/.GlobalPreferences.plist` |
| Trackpad | `~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist` |
| Keyboard | `~/Library/Preferences/.GlobalPreferences.plist` |

### Management via `defaults`

**Read setting**:
```bash
defaults read com.apple.dock autohide
```

**Write setting**:
```bash
defaults write com.apple.dock autohide -bool true
killall Dock
```

**Export all**:
```bash
defaults read com.apple.dock > dock-settings.txt
```

---

## Approaches Comparison

| Approach | Pros | Cons | Complexity |
|----------|------|------|------------|
| Mackup | Many apps, cloud sync | No system prefs | Low |
| Custom scripts | Full control, system prefs | Manual maintenance | Medium |
| Plist backup | Complete backup | Binary format, fragile | High |
| Hybrid | Best of both | More moving parts | Medium |

---

## Custom Scripts Pattern

### mathiasbynens Approach

**File**: `.macos` (1000+ lines)

**Coverage**:
- General UI/UX settings
- Trackpad, mouse, keyboard
- Screen settings
- Finder preferences
- Dock configuration
- Safari settings
- Mail, Calendar, Messages
- Activity Monitor, TextEdit
- Mac App Store

**Pattern**:
```bash
#!/usr/bin/env bash

# Close System Preferences
osascript -e 'tell application "System Preferences" to quit'

# General UI/UX
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Restart affected apps
killall Dock Finder SystemUIServer
```

---

## Recommended Approach

### Hybrid Strategy

| Component | Tool | Coverage |
|-----------|------|----------|
| System preferences | Custom script | macOS only |
| App preferences | Symlinks | Cross-platform |
| Cloud backup | Optional (Mackup) | Not initial scope |

### Rationale

| Decision | Reason |
|----------|--------|
| Custom script for system | Mackup doesn't support |
| Symlinks for dotfiles | Simple, cross-platform |
| Skip Mackup initially | Adds complexity |
| Consider Mackup later | If cloud sync needed |

---

## Settings Categories

### macOS System Preferences

| Category | Settings | Script Location |
|----------|----------|-----------------|
| Dock | Autohide, size, position | `os/macos/dock.sh` |
| Finder | View options, sidebar | `os/macos/finder.sh` |
| Input | Mouse, trackpad, keyboard | `os/macos/input.sh` |
| UI | Dark mode, screenshots | `os/macos/ui.sh` |
| Security | Firewall, privacy | `os/macos/security.sh` |

### Application Preferences

| App | Method | Location |
|-----|--------|----------|
| VSCode | Symlink settings.json | `config/vscode/` |
| Git | Symlink .gitconfig | `config/.gitconfig` |
| Zsh | Symlink .zshrc | `config/.zshrc` |
| Vim | Symlink .vimrc | `config/.vimrc` |
| SSH | Symlink config | `config/ssh/config` |

---

## Script Organization

### Modular Approach

```
os/macos/
├── defaults.sh       # Main orchestrator
├── dock.sh          # Dock settings
├── finder.sh        # Finder settings
├── input.sh         # Mouse/trackpad/keyboard
├── ui.sh            # General UI/UX
└── apps.sh          # App-specific settings
```

### Main Orchestrator

```bash
#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/dock.sh"
source "$DIR/finder.sh"
source "$DIR/input.sh"
source "$DIR/ui.sh"
source "$DIR/apps.sh"

echo "macOS defaults applied"
killall Dock Finder SystemUIServer
```

---

## Key macOS Settings

### Dock Configuration

| Setting | Command | Value |
|---------|---------|-------|
| Autohide | `defaults write com.apple.dock autohide -bool` | `true` |
| Icon size | `defaults write com.apple.dock tilesize -int` | `36` |
| Position | `defaults write com.apple.dock orientation -string` | `bottom` |
| Minimize effect | `defaults write com.apple.dock mineffect -string` | `scale` |
| Show recent apps | `defaults write com.apple.dock show-recents -bool` | `false` |

### Finder Configuration

| Setting | Command | Value |
|---------|---------|-------|
| Show extensions | `defaults write NSGlobalDomain AppleShowAllExtensions -bool` | `true` |
| Show path bar | `defaults write com.apple.finder ShowPathbar -bool` | `true` |
| Show status bar | `defaults write com.apple.finder ShowStatusBar -bool` | `true` |
| Default view | `defaults write com.apple.finder FXPreferredViewStyle -string` | `Nlsv` (list) |
| Search scope | `defaults write com.apple.finder FXDefaultSearchScope -string` | `SCcf` (current) |

### Input Configuration

| Setting | Command | Value |
|---------|---------|-------|
| Trackpad tap | `defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool` | `true` |
| Mouse speed | `defaults write NSGlobalDomain com.apple.mouse.scaling -float` | `2.5` |
| Trackpad speed | `defaults write NSGlobalDomain com.apple.trackpad.scaling -float` | `3.0` |
| Key repeat | `defaults write NSGlobalDomain KeyRepeat -int` | `2` |
| Initial delay | `defaults write NSGlobalDomain InitialKeyRepeat -int` | `15` |

---


### Limited System Settings

| Platform | Settings Available |
|----------|-------------------|
| Ubuntu | Minimal (GNOME via gsettings) |

### Focus on Dotfiles

| Config | Purpose |
|--------|---------|
| `.bashrc` | Bash configuration |
| `.zshrc` | Zsh configuration |
| `.gitconfig` | Git settings |
| `.vimrc` | Vim settings |
| `.tmux.conf` | Tmux settings |

---

## Implementation Priority

| Priority | Component | Platform |
|----------|-----------|----------|
| 1 | Dock settings | macOS |
| 2 | Finder settings | macOS |
| 3 | Input settings | macOS |
| 4 | Shell configs | All |
| 5 | App configs | All |
| 6 | UI settings | macOS |

---

## Idempotency

**MUST** be safe to re-run:

```bash
# Always idempotent (overwrites)
defaults write com.apple.dock autohide -bool true

# Check before action
if ! defaults read com.apple.dock autohide &>/dev/null; then
  defaults write com.apple.dock autohide -bool true
fi
```

**Recommendation**: Just overwrite (simpler)

---

## Testing

### Verification Script

```bash
#!/usr/bin/env bash

# Check Dock autohide
autohide=$(defaults read com.apple.dock autohide)
if [ "$autohide" = "1" ]; then
  echo "✅ Dock autohide enabled"
else
  echo "❌ Dock autohide not enabled"
fi

# Check Finder extensions
extensions=$(defaults read NSGlobalDomain AppleShowAllExtensions)
if [ "$extensions" = "1" ]; then
  echo "✅ Show file extensions enabled"
else
  echo "❌ Show file extensions not enabled"
fi
```

---

## Decision Matrix

| Question | Decision | Rationale |
|----------|----------|-----------|
| Use Mackup? | No (initial) | Doesn't handle system prefs |
| Custom scripts? | Yes | Required for system settings |
| Backup plists? | No | Fragile, hard to maintain |
| Modular scripts? | Yes | Maintainability |
| Cloud sync? | Defer | Future consideration |

---

## Related

- [index.md](index.md) - Research index
- [inspiration.md](inspiration.md) - Dotfiles projects
- [orchestrator.md](orchestrator.md) - Install approach

---

**Conclusion**: Custom scripts REQUIRED for macOS system settings
