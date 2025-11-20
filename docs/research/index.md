# Research Index

**Decision rationale and analysis**

**Each file starts with SELECTED decision + rationale**

---

## Documents

| Document | Selected |
|----------|----------|
| [bash-utilities.md](bash-utilities.md) | labbots/bash-utility |
| [bash-style-guides.md](bash-style-guides.md) | style.ysap.sh |
| [logging-decision.md](logging-decision.md) | Inline helpers |
| [orchestrator.md](orchestrator.md) | Taskfile pattern |
| [taskfile-pattern.md](taskfile-pattern.md) | Bash script (NOT .dev) |
| [settings.md](settings.md) | defaults script |
| [symlinks.md](symlinks.md) | GNU Stow |
| [shells.md](shells.md) | Platform-specific |
| [prompts.md](prompts.md) | Starship |
| [inspiration.md](inspiration.md) | Low complexity |

**Supporting evidence:**

| Document | Purpose |
|----------|---------|
| [taskfile-analysis.md](taskfile-analysis.md) | Pattern evaluation |
| [taskfile-real-world.md](taskfile-real-world.md) | 1442-line proof |

---

## Decisions

| Decision | Choice | Rejected |
|----------|--------|----------|
| Complexity | Low (flat) | Medium, High |
| Orchestrator | Taskfile pattern | install.sh, Make, Just, Taskfile.dev |
| Style guide | style.ysap.sh | Google Shell Style |
| Logging | Inline helpers | cyberark/bash-lib, fidian/ansi |
| macOS settings | defaults | Mackup |
| Symlinks | Stow | Dotbot, manual |
| Shell | Platform-specific | Universal .profile |
| Utilities | labbots/bash-utility | Inline functions |
| Prompt | Starship | Oh My Zsh, Powerlevel10k |

---

## Design Philosophy

**Zen of Python applied:**

| Principle | Application |
|-----------|-------------|
| Flat is better than nested | No scripts/ or lib/ dirs |
| Simple is better than complex | 2 scripts, not 6 |
| Explicit is better than implicit | Direct code, no magic |
| Readability counts | Clear structure |

---

## Key Rationale

### Taskfile Pattern

- Granular commands (install-brew, stow-common)
- Zero dependencies (pure bash)
- Development velocity (no full re-runs)
- Proven (1442-line real-world example)

### Stow vs Dotbot

- Stow: Directory structure = config
- Dotbot: YAML config overhead
- Trade-off: Requires binary (acceptable)

### labbots/bash-utility

- OS detection (macOS/Ubuntu)
- Command checking utilities
- 11 libraries evaluated
- Selected for 2+ platform support

---

## Related

- [../index.md](../index.md) - Requirements & architecture
- [../specs/index.md](../specs/index.md) - Implementation specs
