# Implementation Specifications

**Component-level specs for AI implementation**

---

## Components

| Component | Spec | Purpose |
|-----------|------|---------|
| task | [task-file.md](task-file.md) | Taskfile orchestrator |
| macos-defaults.sh | [macos-defaults.md](macos-defaults.md) | macOS system settings |
| Brewfile | [package-management.md](package-management.md) | macOS packages |
| apt.txt | [package-management.md](package-management.md) | Ubuntu packages |
| Stow packages | [stow-packages.md](stow-packages.md) | Dotfile organization |
| .env | [configuration.md](configuration.md) | PII handling |
| vendor/ | External | labbots/bash-utility |

---

## Implementation Order

| Step | Component | Dependency |
|------|-----------|------------|
| 1 | vendor/bash-utility/ | git clone |
| 2 | .env.example | None |
| 3 | Stow packages | None |
| 4 | Brewfile/apt.txt | None |
| 5 | task | bash-utility |
| 6 | macos-defaults.sh | None |

---

## Error Handling

**REQUIRED in all scripts:**

```bash
set -euo pipefail
```

| Flag | Behavior |
|------|----------|
| -e | Exit on error |
| -u | Exit on undefined var |
| -o pipefail | Exit on pipe failure |

---

## Idempotency

**REQUIRED: All operations MUST be safe to re-run**

| Operation | Method |
|-----------|--------|
| Install Homebrew | Check `command -v brew` |
| Install packages | Package manager handles |
| Stow dotfiles | Stow detects existing |
| macOS defaults | Overwrite (safe) |
| Clone vendor | Check directory exists |

---

## Testing

```bash
# Syntax check
bash -n task
bash -n macos-defaults.sh

# Idempotency test
./task install && ./task install

# Verify symlinks
ls -la ~/ | grep -E '\->'

# Verify packages
brew list              # macOS
dpkg -l | grep stow    # Ubuntu
```

---

## Related

- [../index.md](../index.md) - Requirements & architecture
- [../research/index.md](../research/index.md) - Decision rationale
