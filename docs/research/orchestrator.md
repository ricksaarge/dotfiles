# Research: Install Orchestrator

**SELECTED: Taskfile pattern (bash)**

**Why**: Granular tasks, zero dependencies, development velocity, proven at scale

---

## Decision

| Selected | Reason |
|----------|--------|
| Taskfile pattern | Granular + discoverable + pure bash |

**Rejected**: install.sh (no granularity), Makefile (requires binary), Just (requires binary)

---

## Question

Shell script vs Makefile for install orchestration?

---

## Comparison

| Aspect | Shell Script | Makefile |
|--------|-------------|----------|
| Cross-platform | Native on all platforms | Requires `make` installed |
| Readability | Intuitive for scripts | Less intuitive for logic |
| Conditionals | Native `if/else/case` | Awkward syntax |
| Platform detection | Easy with `uname` | Harder to implement |
| Dependencies | Built-in bash | Requires GNU Make |
| Idempotency | Manual implementation | Built-in via targets |
| Parallel execution | Manual with `&` | Built-in with `-j` |
| macOS compatibility | Perfect | Requires install |
| Ubuntu compatibility | Perfect | Requires install |
| Error handling | `set -e`, `trap` | `-k` flag, `.IGNORE` |

---

## Shell Script Advantages

| Advantage | Impact |
|-----------|--------|
| No dependencies | Works immediately on macOS/Ubuntu |
| Platform detection | Easy with `uname -s` + platform checks |
| Conditional logic | Native bash syntax |
| String manipulation | Rich bash features |
| User interaction | Easy prompts, colors, progress |
| File operations | Native commands |

---

## Makefile Advantages

| Advantage | Impact |
|-----------|--------|
| Dependency graph | Automatic task ordering |
| Idempotency | Built-in file timestamp checking |
| Parallel execution | `make -j4` for speed |
| Standard interface | Familiar `make install` |
| Selective execution | `make target` for specific tasks |

---

## Real-World Usage

### Shell Script Implementations

| Project | Approach | Complexity |
|---------|----------|------------|
| mathiasbynens | `bootstrap.sh` + `.macos` | High |
| nygaard | Single `install.sh` | Low |
| driesvints | `install.sh` + helpers | Medium |
| webpro | `install.sh` modular | Medium |

**Pattern**: Shell scripts dominant in dotfiles

### Makefile Implementations

| Project | Approach | Notes |
|---------|----------|-------|
| Rare in dotfiles | - | Uncommon pattern |
| Build systems | Common | Different use case |

---

## Decision Factors

### For This Project

| Factor | Shell Script | Makefile | Winner |
|--------|-------------|----------|--------|
| Platform support | Perfect | Needs install | Shell |
| Complexity | Medium | Medium | Tie |
| Maintainability | High | Medium | Shell |
| Dependencies | Zero | Requires make | Shell |
| Community pattern | Standard | Rare | Shell |

---

## Idempotency Handling

### Shell Script Pattern

```bash
#!/bin/bash
set -e

# Check if already done
if [ -f ~/.zshrc ]; then
  echo "zshrc already exists, skipping"

  ln -s "$PWD/config/.zshrc" ~/.zshrc
  echo "zshrc linked"
fi
```

### Makefile Pattern

```makefile
~/.zshrc: config/.zshrc
	ln -s $(PWD)/config/.zshrc ~/.zshrc
```

**Winner**: Makefile (built-in), but shell script pattern is simple enough

---

## Platform Detection

### Shell Script

```bash
#!/bin/bash

case "$(uname -s)" in
  Darwin)
    echo "macOS detected"
    ;;
  Linux)
    # Ubuntu detection
      # (already identified as Linux)
    
      echo "Linux detected"
    fi
    ;;
esac
```

**Complexity**: Low

### Makefile

```makefile
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OS := macos
endif
ifeq ($(UNAME_S),Linux)
    OS := linux
endif
```

**Complexity**: Medium (WSL detection harder)

---

## Recommendation

**DECISION**: Shell script

### Rationale

| Reason | Weight |
|--------|--------|
| Zero dependencies | High |
| Platform detection easier | High |
| Dotfiles community standard | Medium |
| Better for orchestration | Medium |
| Ubuntu compatibility | High |

### Implementation

| Component | Approach |
|-----------|----------|
| Main entry | `install.sh` |
| Platform detection | `scripts/detect.sh` |
| Utilities | `scripts/utils.sh` |
| OS-specific | `os/*/install.sh` |
| Package install | `scripts/packages.sh` |
| Symlinks | `scripts/symlink.sh` |

---

## Hybrid Approach

**Optional**: Provide both

| File | Purpose |
|------|---------|
| `install.sh` | Primary installation |
| `Makefile` | Convenience wrapper |

**Makefile contents**:
```makefile
.PHONY: install update

install:
	./install.sh

update:
	git pull && ./install.sh
```

**Decision**: Not needed (KISS principle)

---

## Alternative Tools

| Tool | Purpose | Decision |
|------|---------|----------|
| Ansible | Config management | Too heavy |
| Chef/Puppet | Infrastructure | Too heavy |
| Stow | Symlink management | Consider separately |
| Nix | Package management | Out of scope |

---

## Implementation Pattern

### Recommended Structure

```bash
#!/usr/bin/env bash
set -euo pipefail

# Load utilities
source "$(dirname "$0")/scripts/utils.sh"

# Detect platform
source "$(dirname "$0")/scripts/detect.sh"

# Main installation
main() {
  log_info "Installing dotfiles for $OS_TYPE"

  install_packages
  setup_symlinks
  configure_os

  log_success "Installation complete"
}

main "$@"
```

---

## Error Handling

### Shell Script Best Practices

| Practice | Command |
|----------|---------|
| Exit on error | `set -e` |
| Undefined vars fail | `set -u` |
| Pipe failures | `set -o pipefail` |
| Cleanup trap | `trap cleanup EXIT` |
| Verbose mode | `set -x` (optional) |

---

## Related

- [index.md](index.md) - Research index
- [inspiration.md](inspiration.md) - Dotfiles implementations
- [settings.md](settings.md) - Settings management

---

**Conclusion**: Shell script REQUIRED for install orchestration
