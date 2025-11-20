# Documentation Index

**AISD documentation for dotfiles management system**

---

## Requirements

**Dotfiles management for macOS and Ubuntu**

| Platform | Version | Package Manager | Shell |
|----------|---------|-----------------|-------|
| macOS | 10.15+ | Homebrew | zsh |
| Ubuntu | 20.04+ | apt | bash |

**FORBIDDEN**: Windows, WSL, other distros

### Installation Workflow

| Step | Command | Max Time |
|------|---------|----------|
| 1 | `git clone <repo> && cd dotfiles` | 1m |
| 2 | `cp .env.example .env` | 1m |
| 3 | Edit `.env` with PII | 2m |
| 4 | `./task install` | 30m |

**MUST** be idempotent (safe to re-run).

### Core Requirements

| Requirement | Constraint |
|-------------|------------|
| Fresh install | <30m (macOS), <10m (Ubuntu) |
| Re-run errors | Zero |
| Manual steps | FORBIDDEN |
| Exit on error | REQUIRED (set -e) |

---

## Architecture

### Technology Stack

| Component | Choice | File |
|-----------|--------|------|
| Symlink manager | GNU Stow | N/A |
| Orchestrator | Taskfile (bash) | task |
| Style guide | style.ysap.sh | N/A |
| Utilities | labbots/bash-utility | vendor/bash-utility/ |
| macOS packages | Homebrew | Brewfile |
| Ubuntu packages | apt | apt.txt |
| macOS settings | defaults | macos-defaults.sh |
| Prompt | Starship | .config/starship.toml |

### Directory Structure

```
dotfiles/
├── task                    # Taskfile orchestrator
├── macos-defaults.sh       # macOS settings
├── Brewfile                # macOS packages
├── apt.txt                 # Ubuntu packages
├── .env.example            # PII template (committed)
├── .env                    # PII values (gitignored)
├── vendor/
│   └── bash-utility/       # labbots/bash-utility
├── stow-common/            # Cross-platform dotfiles
├── stow-macos/             # macOS dotfiles
├── stow-ubuntu/            # Ubuntu dotfiles
└── docs/                   # AISD documentation
```

---

## Specifications

| Component | Spec |
|-----------|------|
| task | [specs/task-file.md](specs/task-file.md) |
| macos-defaults.sh | [specs/macos-defaults.md](specs/macos-defaults.md) |
| Packages | [specs/package-management.md](specs/package-management.md) |
| Stow | [specs/stow-packages.md](specs/stow-packages.md) |
| Config | [specs/configuration.md](specs/configuration.md) |

**MUST** read [specs/index.md](specs/index.md) before implementing.

---

## Research

[research/index.md](research/index.md) - Decision rationale, tool comparisons

---

## Validation

```bash
# Check forbidden words
grep -rn "should\|might\|could\|typically" docs/ --include="*.md"

# Check line limits
wc -l docs/**/*.md | awk '$1 > 500 {print $2 ": " $1}'
```
