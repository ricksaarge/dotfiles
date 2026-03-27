# Package Management

**Package file specifications**

---

## Overview

| Platform | File | Format | Installation |
|----------|------|--------|--------------|
| macOS | Brewfile | Homebrew Bundle DSL | brew bundle |
| Ubuntu | apt.txt | One per line | xargs apt install |

---

## Brewfile

### Format

Ruby DSL for Homebrew Bundle.

### Structure

```ruby
# CLI Tools
brew "git"
brew "stow"
brew "vim"
brew "starship"
brew "mas"

# GUI Applications
cask "visual-studio-code"
cask "google-chrome"
cask "docker-desktop"

# Mac App Store
mas "Dark Noise", id: 1465439395
```

### Sections

| Section | Directive | Purpose |
|---------|-----------|---------|
| Taps | tap "name" | Add third-party repos |
| CLI tools | brew "name" | Command-line packages |
| GUI apps | cask "name" | macOS applications |
| App Store | mas "name", id: N | Mac App Store apps (requires mas CLI) |

### Required Packages

| Package | Type | Purpose |
|---------|------|---------|
| git | brew | Version control |
| stow | brew | Symlink manager |
| vim | brew | Text editor |
| starship | brew | Terminal prompt |
| mas | brew | Mac App Store CLI |

**MUST** include starship BEFORE symlinking shell configs.

### Installation

```bash
brew bundle --file=Brewfile
```

**Idempotent**: Skips installed packages.

---

## apt.txt

### Format

Plain text, one package per line.

### Example

```
git
stow
vim
python3
python3-pip
nodejs
npm
docker.io
```

### Required Packages

| Package | Purpose |
|---------|---------|
| git | Version control |
| stow | Symlink manager |
| vim | Text editor |

### Starship Installation

**NOT in apt repos**: MUST install separately.

```bash
# In task file
install-starship() {
  if ! has_cmd starship; then
    info "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
}
```

### Installation

```bash
xargs sudo apt install -y < apt.txt
```

**Idempotent**: apt skips installed packages.

---

## Package Categories

### CLI Tools

| Package | macOS | Ubuntu | Purpose |
|---------|-------|--------|---------|
| git | brew | apt | Version control |
| stow | brew | apt | Symlink manager |
| vim | brew | apt | Text editor |
| tmux | brew | apt | Terminal multiplexer |
| curl | brew | apt | HTTP client |
| wget | brew | apt | File downloader |
| jq | brew | apt | JSON processor |
| starship | brew | curl | Terminal prompt |

### Development Tools

| Package | macOS | Ubuntu | Purpose |
|---------|-------|--------|---------|
| python | brew | apt (python3) | Python runtime |
| node | brew | apt (nodejs) | Node.js runtime |
| docker | cask | apt (docker.io) | Containerization |
| go | brew | apt (golang) | Go runtime |

### GUI Applications (macOS only)

| Package | Type | Purpose |
|---------|------|---------|
| google-chrome | cask | Web browser |
| visual-studio-code | cask | Code editor |
| termius | cask | SSH client |
| docker-desktop | cask | Containerization |
| claude | cask | AI assistant |
| claude-code | cask | AI development |
| chatgpt | cask | AI assistant |
| obsidian | cask | Knowledge management |
| 1password | cask | Password manager |
| slack | cask | Team communication |
| discord | cask | Community chat |
| zoom | cask | Video conferencing |
| microsoft-teams | cask | Team communication |
| whatsapp | cask | Messaging |
| spotify | cask | Music streaming |
| vlc | cask | Media player |
| dropbox | cask | Cloud storage |
| wispr-flow | cask | Voice dictation |
| plaud | cask | AI voice recorder |
| expressvpn | manual | VPN service (cask installer broken, install from expressvpn.com) |
| meld | cask | Visual diff tool |

### Mac App Store Applications

| Package | ID | Purpose |
|---------|-----|---------|
| Dark Noise | 1465439395 | Ambient sound generator |
| CotEditor | 1024640650 | Lightweight text editor |
| Speechify | 1624912180 | Text-to-speech reader (manual install) |

---

## Known Issues

### Casks Requiring Interactive Install

These casks use `.pkg` or custom installers that require `sudo`. They fail during `brew bundle install` in non-interactive contexts.

| Cask | Issue | Workaround |
|------|-------|------------|
| microsoft-teams | `.pkg` installer | `brew install --cask microsoft-teams` |
| wispr-flow | Needs sudo for permissions | `brew install --cask wispr-flow` |
| plaud | Needs sudo for permissions | `brew install --cask plaud` |
| expressvpn | Install helper broken via CLI | Install manually from expressvpn.com |

### Mac App Store Limitations

| App | Issue |
|-----|-------|
| Speechify | App Store ID `1624912180` not found via mas, install manually from speechify.com |

**MUST** be signed into Mac App Store for `mas install` to work.

---

## Configuration vs Installation

### Installation Scope

Package managers ONLY install binaries/apps.

### Configuration Scope

Dotfiles handle configuration files.

| Tool | Installation | Configuration |
|------|--------------|---------------|
| Git | Brewfile/apt.txt | .gitconfig (Stow) |
| Vim | Brewfile/apt.txt | .vimrc (Stow) |
| Starship | Brewfile/curl | .config/starship.toml (Stow) |
| VSCode | Brewfile (cask) | .config/Code/ (Stow) |
| Python | Brewfile/apt.txt | NOT in dotfiles |
| Node | Brewfile/apt.txt | NOT in dotfiles |
| Docker | Brewfile/apt.txt | Manual/separate script |

---

## Out of Scope

### Runtime Dependencies

**NOT in package files**:

- Python packages (pip install)
- Node packages (npm install -g)
- Docker configuration
- IDE extensions

**Rationale**: Dotfiles = configuration files, NOT runtime dependencies.

### Future Enhancement

Create separate setup scripts if needed:

- setup-python.sh - pip install packages
- setup-node.sh - npm install -g packages
- setup-docker.sh - Docker daemon config

**Current approach**: Install runtimes, configure manually.

---

## Installation Order

| Order | Action | Task |
|-------|--------|------|
| 1 | Install package manager | install-homebrew |
| 2 | Install packages | install-brew-packages |
| 3 | Install Starship (Ubuntu) | install-starship |
| 4 | Symlink configs | stow-* |

**MUST** install Starship BEFORE symlinking shell configs.

---

## Validation

### macOS

```bash
# List installed packages
brew list

# Verify specific package
brew list starship

# Check Brewfile validity
brew bundle check --file=Brewfile
```

### Ubuntu

```bash
# List installed packages
dpkg -l

# Verify specific package
dpkg -l | grep stow

# Check package availability
apt-cache show starship
```

---

## Maintenance

### Add Package

**macOS**:

```ruby
# Add to Brewfile
brew "package-name"
```

**Ubuntu**:

```
# Add to apt.txt
package-name
```

### Remove Package

**macOS**:

```bash
# Remove from Brewfile
# Then: brew bundle cleanup
```

**Ubuntu**:

```bash
# Remove from apt.txt
# Then: sudo apt autoremove package-name
```

### Update All Packages

**macOS**:

```bash
brew update
brew upgrade
```

**Ubuntu**:

```bash
sudo apt update
sudo apt upgrade
```

---

## Related

- [task-file.md](task-file.md) - Installation orchestration
- [stow-packages.md](stow-packages.md) - Configuration management
