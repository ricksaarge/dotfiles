# Configuration Management

**Environment variables and PII handling**

---

## Overview

Configuration system for user-specific data outside version control.

**Components**: .env file, .env.example template, .gitconfig generation

---

## .env File

### Purpose

Store PII (Personally Identifiable Information) outside git.

### Location

`.env` in repo root (gitignored)

### Format

```bash
GIT_USER_NAME="John Doe"
GIT_USER_EMAIL="john@example.com"
GITHUB_USERNAME="johndoe"
```

---

## Environment Variables

### Required Variables

| Variable | Type | Purpose | Example |
|----------|------|---------|---------|
| GIT_USER_NAME | String | Git commits | "John Doe" |
| GIT_USER_EMAIL | String | Git commits | "john@example.com" |

### Optional Variables

| Variable | Type | Purpose | Example |
|----------|------|---------|---------|
| GITHUB_USERNAME | String | GitHub operations | "johndoe" |
| ICLOUD_PATH | String | Custom symlink | "$HOME/Library/..." |
| LOG_FILE | String | Log location | "~/.dotfiles.log" |
| LOG_LEVEL | String | Verbosity | "DEBUG" or "INFO" |

---

## .env.example Template

### Purpose

Template for users to create .env file.

### Location

`.env.example` in repo root (committed)

### Content

```bash
# .env.example
# Copy this to .env and fill in your information
# DO NOT commit .env to git!

# Git configuration (REQUIRED)
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# GitHub (OPTIONAL)
GITHUB_USERNAME="yourusername"

# Custom paths (OPTIONAL)
ICLOUD_PATH="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
```

---

## Loading .env

### Implementation

```bash
if [[ -f ".env" ]]; then
  info "Loading .env"
  set -a
  source .env
  set +a
else
  error ".env not found. Copy .env.example to .env"
fi
```

### Behavior

| Scenario | Action |
|----------|--------|
| .env exists | Load all variables |
| .env missing | Exit with error |

---

## Validation

### Required Variables

```bash
validate_env() {
  [[ -z "${GIT_USER_NAME:-}" ]] && error "GIT_USER_NAME required in .env"
  [[ -z "${GIT_USER_EMAIL:-}" ]] && error "GIT_USER_EMAIL required in .env"
}
```

### Email Format

```bash
if [[ ! "$GIT_USER_EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$ ]]; then
  error "GIT_USER_EMAIL format invalid"
fi
```

---

## .gitconfig Generation

### Template File

**Location**: `stow-common/.gitconfig.template`

**Content**:

```ini
[user]
    name = ${GIT_USER_NAME}
    email = ${GIT_USER_EMAIL}
[github]
    user = ${GITHUB_USERNAME}
[core]
    editor = vim
[init]
    defaultBranch = main
```

### Generated File

**Location**: `stow-common/.gitconfig` (gitignored)

### Generation Function

```bash
generate_gitconfig() {
  info "Generating .gitconfig from template"
  validate_env
  envsubst < stow-common/.gitconfig.template > stow-common/.gitconfig
}
```

**MUST** run before stow commands.

---

## Git Ignore Rules

### .gitignore Content

```gitignore
# Environment
.env
.env.local
.env.*.local

# Generated configs
stow-common/.gitconfig

# Logs
*.log
install.log
.dotfiles-install.log

# User-specific
.DS_Store
```

---

## File Tracking

### Committed Files

| File | Purpose |
|------|---------|
| .env.example | Template |
| .gitconfig.template | Git config template |
| .gitignore | Ignore rules |

### Ignored Files

| File | Reason |
|------|--------|
| .env | Contains PII |
| .gitconfig | Generated with PII |
| *.log | Runtime data |

---

## Workflow

### First-Time Setup

| Step | Command |
|------|---------|
| 1 | `git clone <repo>` |
| 2 | `cd dotfiles` |
| 3 | `cp .env.example .env` |
| 4 | `vim .env` (fill in PII) |
| 5 | `./task install` |

### task install Sequence

| Order | Action |
|-------|--------|
| 1 | Load .env |
| 2 | Validate env vars |
| 3 | Generate .gitconfig |
| 4 | Run stow (symlink .gitconfig) |

---

## Error Handling

### Missing .env

```bash
if [[ ! -f ".env" ]]; then
  error ".env not found. Copy .env.example to .env"
fi
```

**Exit code**: 1

### Missing Required Var

```bash
[[ -z "${GIT_USER_NAME:-}" ]] && error "GIT_USER_NAME required in .env"
```

**Exit code**: 1

### Invalid Email

```bash
if [[ ! "$GIT_USER_EMAIL" =~ ^[^@]+@[^@]+\.[^@]+$ ]]; then
  error "GIT_USER_EMAIL format invalid"
fi
```

**Exit code**: 1

---

## Security

### PII Data

| Data Type | Example | Used In |
|-----------|---------|---------|
| Name | "John Doe" | .gitconfig |
| Email | "john@example.com" | .gitconfig |
| GitHub username | "johndoe" | .gitconfig, aliases |

### Protection Methods

| Method | Implementation |
|--------|----------------|
| Git ignore | .env in .gitignore |
| Template system | .gitconfig.template with ${VARS} |
| Generation | envsubst creates .gitconfig |
| Validation | Check before use |

---

## Logging (Optional)

### Log Configuration

```bash
LOG_FILE="${LOG_FILE:-$HOME/.dotfiles-install.log}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"
```

### Log Function

```bash
log() {
  local level="$1"
  shift
  local msg="$*"
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] [$level] $msg" | tee -a "$LOG_FILE"
}

info() { log "INFO" "$@"; }
error() { log "ERROR" "$@"; exit 1; }
```

### Log Rotation

```bash
if [[ -f "$LOG_FILE" ]]; then
  size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE")
  if [[ $size -gt 1048576 ]]; then
    mv "$LOG_FILE" "$LOG_FILE.old"
  fi
fi
```

**Current spec**: Optional enhancement, simple logging sufficient.

---

## Advanced: Multiple Identities

### Conditional Includes

**File**: `stow-common/.gitconfig.template`

```ini
[user]
    name = ${GIT_USER_NAME}
    email = ${GIT_USER_EMAIL}

[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work

[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

**Scope**: Out of current spec, document for future.

---

## Validation

### Verify .env Loaded

```bash
echo $GIT_USER_NAME
# Output: John Doe
```

### Verify .gitconfig Generated

```bash
ls -la stow-common/.gitconfig
# Output: -rw-r--r-- ... .gitconfig

cat stow-common/.gitconfig
# Output: [user] name = John Doe ...
```

### Verify Symlink

```bash
ls -l ~/.gitconfig
# Output: ~/.gitconfig -> dotfiles/stow-common/.gitconfig

git config user.name
# Output: John Doe
```

---

## Related

- [install-script.md](install-script.md) - .env loading and validation
- [stow-packages.md](stow-packages.md) - .gitconfig symlinking
- [../requirements/index.md](../requirements/index.md) - PII requirements
