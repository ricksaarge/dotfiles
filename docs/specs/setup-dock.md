# Dock Configuration

**macOS Dock app management**

---

## Overview

| Property | Value |
|----------|-------|
| File | stow-macos/bin/setup-dock |
| Symlink | ~/bin/setup-dock |
| Language | Bash |
| Dependency | dockutil (brew) |
| Task | `./task setup-dock` |

---

## Behavior

| Step | Action |
|------|--------|
| 1 | Verify dockutil installed |
| 2 | Validate all app paths exist |
| 3 | Remove all current Dock items |
| 4 | Add apps in defined order |
| 5 | Restart Dock |

**Idempotent**: Safe to re-run. Missing apps are skipped with warning.

---

## App List

| Position | Category | App | Path |
|----------|----------|-----|------|
| 1 | Browser | Google Chrome | /Applications/ |
| 2 | Knowledge | Obsidian | /Applications/ |
| 3 | AI | Claude | /Applications/ |
| 4 | AI | ChatGPT | /Applications/ |
| 5 | Development | VS Code | /Applications/ |
| 6 | Development | Terminal | /System/Applications/Utilities/ |
| 7 | Communication | Messages | /System/Applications/ |
| 8 | Communication | WhatsApp | /Applications/ |
| 9 | Communication | Slack | /Applications/ |
| 10 | Reading | Apple News | /System/Applications/ |
| 11 | Reading | Medium | ~/Applications/Chrome Apps.localized/ |
| 12 | Media | Spotify | /Applications/ |

---

## Curation Rules

**Dock-worthy**: Apps actively switched to multiple times daily.

**NOT in Dock** (use Spotlight):

| Category | Apps | Reason |
|----------|------|--------|
| Background daemons | Docker, ExpressVPN, 1Password | Menu bar / always running |
| Voice tools | Wispr Flow, Plaud, Speechify | Background listeners |
| Occasional use | Termius, Discord | Spotlight is sufficient |

---

## App Sources

| Source | Example |
|--------|---------|
| /Applications/ | Homebrew cask installs |
| /System/Applications/ | Built-in macOS apps (News, Messages) |
| ~/Applications/Chrome Apps.localized/ | Chrome web apps (Medium) |

---

## Validation

```bash
# Check dockutil
command -v dockutil

# Dry run: list missing apps
for app in "${apps[@]}"; do
  [[ ! -d "$app" ]] && echo "Missing: $app"
done
```

---

## Related

- [macos-defaults.md](macos-defaults.md) - Dock appearance settings
- [package-management.md](package-management.md) - dockutil installation
- [task-file.md](task-file.md) - Task runner integration
