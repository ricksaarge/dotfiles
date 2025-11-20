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
# Taps
tap "homebrew/cask"

# CLI Tools
brew "git"
brew "stow"
brew "vim"
brew "starship"

# Development Tools
brew "python"
brew "node"
brew "docker"

# GUI Applications
cask "visual-studio-code"
cask "iterm2"
cask "docker"
```

### Sections

| Section | Directive | Purpose |
|---------|-----------|---------|
| Taps | tap "name" | Add third-party repos |
| CLI tools | brew "name" | Command-line packages |
| GUI apps | cask "name" | macOS applications |

### Required Packages

| Package | Type | Purpose |
|---------|------|---------|
| git | brew | Version control |
| stow | brew | Symlink manager |
| vim | brew | Text editor |
| starship | brew | Terminal prompt |

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
| visual-studio-code | cask | Code editor |
| iterm2 | cask | Terminal emulator |
| docker | cask | Docker Desktop |
| alfred | cask | Launcher |
| rectangle | cask | Window manager |

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

- [install-script.md](install-script.md) - Installation orchestration
- [stow-packages.md](stow-packages.md) - Configuration management
- [../architecture/index.md](../architecture/index.md) - Architecture decisions
