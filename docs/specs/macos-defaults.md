# macOS Defaults Script

**macOS system preferences configuration**

---

## Overview

| Property | Value |
|----------|-------|
| File | macos-defaults.sh |
| Size target | 200-500 lines |
| Language | Bash |
| Shell flags | set -euo pipefail |

---

## Structure

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Configuring macOS defaults..."

# Close System Preferences
osascript -e 'tell application "System Preferences" to quit'

# Dock settings
defaults write com.apple.dock ...

# Finder settings
defaults write com.apple.finder ...

# Input settings
defaults write NSGlobalDomain ...

# Restart affected apps
killall Dock Finder SystemUIServer

echo "✓ macOS defaults configured"
```

---

## Settings Categories

| Category | Domain | Purpose |
|----------|--------|---------|
| Dock | com.apple.dock | Dock behavior and appearance |
| Finder | com.apple.finder | File browser settings |
| Input | NSGlobalDomain | Mouse, trackpad, keyboard |
| UI/UX | NSGlobalDomain | System UI preferences |

---

## Dock Settings

### Common Configurations

| Setting | Command | Value |
|---------|---------|-------|
| Auto-hide | defaults write com.apple.dock autohide -bool | true |
| Icon size | defaults write com.apple.dock tilesize -int | 36 |
| Magnification | defaults write com.apple.dock magnification -bool | false |
| Position | defaults write com.apple.dock orientation -string | "bottom" |
| Show recents | defaults write com.apple.dock show-recents -bool | false |
| Minimize effect | defaults write com.apple.dock mineffect -string | "scale" |

### Example

```bash
# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mineffect -string "scale"
```

---

## Finder Settings

### Common Configurations

| Setting | Command | Value |
|---------|---------|-------|
| Show path bar | defaults write com.apple.finder ShowPathbar -bool | true |
| Show status bar | defaults write com.apple.finder ShowStatusBar -bool | true |
| Default view | defaults write com.apple.finder FXPreferredViewStyle -string | "Nlsv" |
| Show extensions | defaults write NSGlobalDomain AppleShowAllExtensions -bool | true |
| Show hidden files | defaults write com.apple.finder AppleShowAllFiles -bool | false |

### View Styles

| Value | View |
|-------|------|
| icnv | Icon |
| Nlsv | List |
| clmv | Column |
| Flwv | Gallery |

### Example

```bash
# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
```

---

## Input Settings

### Mouse/Trackpad

| Setting | Command | Value |
|---------|---------|-------|
| Mouse speed | defaults write NSGlobalDomain com.apple.mouse.scaling -float | 2.5 |
| Trackpad speed | defaults write NSGlobalDomain com.apple.trackpad.scaling -float | 2.5 |
| Natural scroll | defaults write NSGlobalDomain com.apple.swipescrolldirection -bool | true |

### Keyboard

| Setting | Command | Value |
|---------|---------|-------|
| Key repeat rate | defaults write NSGlobalDomain KeyRepeat -int | 2 |
| Delay until repeat | defaults write NSGlobalDomain InitialKeyRepeat -int | 15 |

### Example

```bash
# Input
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

---

## UI/UX Settings

### Common Configurations

| Setting | Command | Value |
|---------|---------|-------|
| Dark mode | defaults write NSGlobalDomain AppleInterfaceStyle -string | "Dark" |
| Accent color | defaults write NSGlobalDomain AppleAccentColor -int | 1 |
| Scroll bar | defaults write NSGlobalDomain AppleShowScrollBars -string | "Automatic" |
| Click wallpaper | defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool | false |

### Example

```bash
# UI/UX
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
```

---

## Restarting Apps

### Required After Changes

```bash
killall Dock Finder SystemUIServer
```

**MUST** restart affected apps for changes to take effect.

---

## Execution

### From task file

```bash
configure-macos() {
  if [[ "$OS" == "macos" ]]; then
    info "Configuring macOS defaults..."
    ./macos-defaults.sh
  fi
}
```

### Standalone

```bash
./macos-defaults.sh
# or
./task configure-macos
```

**MUST** be executable:

```bash
chmod +x macos-defaults.sh
```

---

## Idempotency

**Behavior**: Overwrites existing values.

**Safe to re-run**: Yes, settings are overwritten.

**Test**:

```bash
./macos-defaults.sh  # First run
./macos-defaults.sh  # Second run (safe)
```

---

## Error Handling

| Error | Cause | Result |
|-------|-------|--------|
| Invalid domain | Typo in domain name | Exit 1 (set -e) |
| Invalid value | Wrong type (bool vs int) | Exit 1 |
| Permission denied | Requires admin rights | Exit 1 |
| App not found | killall on non-existent app | Exit 1 |

**Behavior**: Script stops at first error (set -e).

---

## Discovering Settings

### Read Current Value

```bash
defaults read com.apple.dock autohide
```

### Find Domain

```bash
# List all defaults
defaults domains

# Search for specific app
defaults find <keyword>
```

### Monitor Changes

```bash
# Before change
defaults read com.apple.dock > before.txt

# Make change via System Preferences

# After change
defaults read com.apple.dock > after.txt

# Diff
diff before.txt after.txt
```

---

## Template Structure

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Configuring macOS defaults..."

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

#------------------------------------------------------------------------------
# DOCK
#------------------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36
# ... more dock settings

#------------------------------------------------------------------------------
# FINDER
#------------------------------------------------------------------------------
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# ... more finder settings

#------------------------------------------------------------------------------
# INPUT
#------------------------------------------------------------------------------
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5
defaults write NSGlobalDomain KeyRepeat -int 2
# ... more input settings

#------------------------------------------------------------------------------
# UI/UX
#------------------------------------------------------------------------------
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# ... more UI settings

#------------------------------------------------------------------------------
# RESTART AFFECTED APPS
#------------------------------------------------------------------------------
killall Dock Finder SystemUIServer

echo "✓ macOS defaults configured"
echo "Some changes may require logout/restart"
```

---

## Validation

### Verify Settings

```bash
# Check specific setting
defaults read com.apple.dock autohide
# Output: 1 (true)

# Check all dock settings
defaults read com.apple.dock
```

### Visual Verification

Restart apps and verify in System Preferences.

---

## Reverting Changes

### Individual Setting

```bash
defaults delete com.apple.dock autohide
killall Dock
```

### All Dock Settings

```bash
defaults delete com.apple.dock
killall Dock
```

**Warning**: Resets to macOS defaults.

---

## Related

- [install-script.md](install-script.md) - Script execution
- [../architecture/index.md](../architecture/index.md) - macOS settings decision
- [../research/index.md](../research/index.md) - Settings management research
