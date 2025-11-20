# Dotfiles

[![macOS](https://img.shields.io/badge/macOS-Compatible-blue.svg)](https://www.apple.com/macos/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-Compatible-orange.svg)](https://ubuntu.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GNU Stow](https://img.shields.io/badge/GNU%20Stow-Managed-green.svg)](https://www.gnu.org/software/stow/)
[![1Password](https://img.shields.io/badge/1Password-Integration-0094F5.svg)](https://1password.com/)

Personal dotfiles managed with GNU Stow, featuring automated setup and 1Password integration.

## Quick Start

```bash
git clone git@github.com:ricksaarge/dotfiles.git ~/dotfiles
cd ~/dotfiles
cp .env.example .env
# Edit .env with your information
./task install
```

## Features

- **Automated Installation** - Single command setup with `./task install`
- **Cross-Platform** - macOS and Ubuntu support
- **GNU Stow** - Clean symlink management
- **1Password Integration** - SSH authentication and Git commit signing
- **Package Management** - Brewfile (macOS) and apt.txt (Ubuntu)
- **Modern Shell** - Starship prompt with Nerd Font icons

## Structure

```
dotfiles/
├── task                    # Main installation script
├── Brewfile                # macOS packages (Homebrew Bundle)
├── apt.txt                 # Ubuntu packages
├── .env.example            # Configuration template
├── stow-common/            # Cross-platform dotfiles
│   ├── .gitconfig          # Git config (requires .env)
│   ├── .vimrc              # Vim configuration
│   ├── .tmux.conf          # Tmux configuration
│   └── .config/
│       └── starship.toml   # Starship prompt (ASCII)
├── stow-macos/             # macOS-specific dotfiles
│   ├── .zshrc              # Zsh configuration
│   ├── .zprofile           # Zsh login shell
│   ├── .gitconfig.platform # 1Password Git signing
│   ├── .ssh/
│   │   ├── config          # 1Password SSH agent
│   │   └── allowed_signers # SSH signature verification
│   └── .config/
│       └── starship-nerd.toml  # Starship (Nerd Fonts)
└── stow-ubuntu/            # Ubuntu-specific dotfiles
    ├── .bashrc
    └── .bash_profile
```

## Installation

### Prerequisites

**macOS**:
```bash
# Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Ubuntu**:
```bash
sudo apt update
sudo apt install -y git
```

### Setup

1. **Clone**:
   ```bash
   git clone git@github.com:ricksaarge/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Configure**:
   ```bash
   cp .env.example .env
   nano .env  # Edit with your info
   ```

   Required variables:
   ```bash
   GIT_USER_NAME="Your Name"
   GIT_USER_EMAIL="your.email@example.com"
   GITHUB_USERNAME="yourusername"
   ```

3. **Install**:
   ```bash
   ./task install
   ```

   This will:
   - Install Homebrew (macOS) or update apt (Ubuntu)
   - Install packages from Brewfile/apt.txt
   - Install GNU Stow
   - Generate `.gitconfig.local` from `.env`
   - Stow dotfiles to `$HOME`
   - Apply macOS defaults (macOS only)

## Task Commands

The `./task` script provides automated setup:

```bash
./task install              # Full setup (recommended)
./task install-homebrew     # Install Homebrew (macOS)
./task install-packages     # Install from Brewfile/apt.txt
./task install-stow         # Install GNU Stow
./task configure-git        # Generate .gitconfig.local
./task stow                 # Symlink dotfiles
./task macos-defaults       # Apply macOS settings
./task help                 # Show all commands
```

## 1Password Setup

### SSH Agent

**Enable in 1Password**:
1. Open 1Password → Settings → Developer
2. Enable "Use the SSH agent"
3. Add your SSH key to 1Password

**Already configured in dotfiles**:
- `.zshrc` and `.zprofile` set `SSH_AUTH_SOCK`
- `.ssh/config` points to 1Password agent socket

**Test**:
```bash
ssh -T git@github.com
# Should authenticate via 1Password
```

### Git Commit Signing

**Add signing key to GitHub**:
1. Copy your SSH public key:
   ```bash
   cat ~/.ssh/allowed_signers | awk '{print $2" "$3}'
   ```
2. Go to https://github.com/settings/keys
3. Click "New SSH Key"
4. **Key type**: Select "Signing Key"
5. Paste key and save

**Already configured in dotfiles**:
- `.gitconfig.platform` enables SSH signing
- Uses 1Password's `op-ssh-sign`
- Commits auto-signed (no `-S` flag needed)

**Test**:
```bash
git commit --allow-empty -m "Test"
git log --show-signature -1
# Should show "Good 'git' signature"
```

**Verify on GitHub**:
```bash
git push
# Commits show "Verified" badge ✅
```

## Configuration Files

### Git Configuration (3 files)

| File | Source | Purpose |
|------|--------|---------|
| `.gitconfig` | `stow-common` | Universal settings, aliases |
| `.gitconfig.local` | Generated from `.env` | Name, email, signing key |
| `.gitconfig.platform` | `stow-macos` | 1Password SSH signing (macOS) |

**Chain**: `.gitconfig` includes `.gitconfig.local` and `.gitconfig.platform`

### Starship Prompt (2 configs)

| Config | Platform | Features |
|--------|----------|----------|
| `starship.toml` | Ubuntu/SSH | ASCII-only, universal |
| `starship-nerd.toml` | macOS | Nerd Font icons, colors |

**macOS** uses Nerd Font version (set in `.zshrc`)

## Package Management

### macOS (Brewfile)

```bash
# Install packages
brew bundle install

# Check status
brew bundle check

# Update Brewfile
brew bundle dump --force
```

**Includes**: Git, Stow, Starship, Node, Python, Docker, and more

### Ubuntu (apt.txt)

```bash
# Packages installed via ./task install-packages
```

**Includes**: Build tools, curl, wget, git, tmux, vim

## Customization

### Add Personal Configs

```bash
# Add to appropriate stow directory
cp ~/.config/myapp/config.yml stow-common/.config/myapp/

# Re-stow
stow --restow stow-common
```

### Platform-Specific Overrides

Files in `stow-macos/` or `stow-ubuntu/` override `stow-common/`

## Updating

```bash
cd ~/dotfiles
git pull
./task install  # Re-run to update
```

## Troubleshooting

### Stow Conflicts

```bash
# Backup and remove conflicting files
mv ~/.gitconfig ~/.gitconfig.backup

# Or adopt existing files (overwrites repo)
stow --adopt stow-common
```

### SSH Agent Not Working

```bash
# Check 1Password SSH agent socket
ls -la ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Check environment variable
echo $SSH_AUTH_SOCK
# Should match socket path above

# Restart shell
exec zsh
```

### Git Signing Shows "Unverified"

1. Ensure signing key added to GitHub (see "1Password Setup" above)
2. Verify key type is "Signing Key" (not "Authentication Key")
3. Check local signing works:
   ```bash
   git log --show-signature -1
   # Should show "Good 'git' signature"
   ```

### Task Script Fails

```bash
# Check .env exists and is valid
cat .env

# Check required variables set
grep GIT_USER .env

# Run with debug
bash -x ./task install
```

## Security

### Safe to Commit

✅ Public SSH keys
✅ Configuration templates
✅ Shell scripts
✅ Package lists

### Never Commit

❌ `.env` (in `.gitignore`)
❌ `.gitconfig.local` (generated, in `.gitignore`)
❌ Private SSH keys
❌ Tokens/passwords

### Private Keys

**Location**: 1Password vault (encrypted)
**Access**: Via SSH agent socket
**On Disk**: None (not written to `~/.ssh/`)

## Development

### Tools & Formats

This repository uses custom tools and formats:

| Tool | Purpose | Repository |
|------|---------|------------|
| **AISD** | AI-Structured Documentation format | [ricksaarge/aisd](https://github.com/ricksaarge/aisd) |
| **todo-md** | Task list format for TODO.md | [ricksaarge/todo-md](https://github.com/ricksaarge/todo-md) |
| **fortunes** | Fortune quotes collection | [ricksaarge/fortunes](https://github.com/ricksaarge/fortunes) |

See [AGENTS.md](AGENTS.md) for AI agent instructions.

### Inspiration

This dotfiles approach was inspired by these repositories:

| Source | Complexity | Key Features |
|--------|------------|--------------|
| [nygaard.dev](https://nygaard.dev/blog/macos-dotfiles) | Low | GNU Stow + Brew Bundle simplicity |
| [webpro/dotfiles](https://github.com/webpro/dotfiles/) | Medium | Balanced approach, good documentation |
| [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) | High | Comprehensive macOS defaults reference |

See [docs/research/inspiration.md](docs/research/inspiration.md) for full analysis.

## License

MIT

## Author

Ricardo Gemignani ([@ricksaarge](https://github.com/ricksaarge))
