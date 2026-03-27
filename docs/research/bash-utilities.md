# Bash Utility Libraries

**SELECTED: labbots/bash-utility**

---

## Decision

| Selected | Reason |
|----------|--------|
| labbots/bash-utility | OS detection + command utilities in one package |

**Rejected**: Inline functions (complexity threshold exceeded with 2+ platforms)

---

## Summary

| Category | Recommendation | Stars | Reason |
|----------|----------------|-------|--------|
| **All-in-One** | labbots/bash-utility | 228 | Complete utilities, OS detection, command checking |
| **Logging** | cyberark/bash-lib | 665 | Production-grade, retry logic, clean API |
| **Strict Mode** | bpm-rocks/strict | 4 | Stack traces, comprehensive error handling |
| **Colors** | fidian/ansi | 769 | Full ANSI support, dual CLI/library mode |
| **Testing** | torokmark/assert.sh | 152 | JUnit-style assertions, comprehensive |

---

## Selected: labbots/bash-utility

**GitHub:** https://github.com/labbots/bash-utility
**License:** MIT

### Functions Used

| Category | Functions |
|----------|-----------|
| OS Detection | `os::detect_os` → returns: linux, mac, windows |
| Command Check | `check::command_exists` → returns: 0/1 |

### Installation

```bash
git clone https://github.com/labbots/bash-utility.git ./vendor/bash-utility
source "vendor/bash-utility/bash-utility.sh"
```

### Usage

```bash
os=$(os::detect_os)
if check::command_exists "git"; then
  echo "Git installed"
fi
```

---

## Comparison Matrix

| Library | OS Detect | Cmd Check | Logging | Retry | License |
|---------|-----------|-----------|---------|-------|---------|
| labbots/bash-utility | ✓✓ | ✓ | ✓ | ✗ | MIT |
| cyberark/bash-lib | ✗ | ✓ | ✓✓ | ✓✓ | Apache 2.0 |
| bash-oo-framework | ✗ | ✗ | ✓✓ | ✗ | MIT |
| martinburger/helpers | ✗ | ✓ | ✓ | ✗ | MIT |
| vlisivka/bash-modules | ✗ | ✗ | ✓✓ | ✗ | LGPL-2.1 |

**Legend:** ✓✓ Excellent | ✓ Good | ✗ Not provided

---

## Alternatives Considered

| Library | Verdict | Reason |
|---------|---------|--------|
| bash-oo-framework | NOT RECOMMENDED | Framework, not library; overkill |
| cyberark/bash-lib | GOOD | No OS detection; better for logging |
| martinburger/helpers | GOOD | Interactive prompts; no OS detection |
| Standalone functions | REJECTED | 2+ platforms increases complexity |

---

## Resources

| Resource | URL |
|----------|-----|
| labbots/bash-utility | https://github.com/labbots/bash-utility |
| cyberark/bash-lib | https://github.com/cyberark/bash-lib |
| ShellCheck | https://github.com/koalaman/shellcheck |
| Google Shell Style | https://google.github.io/styleguide/shellguide.html |

---

## Full Research

See [archive/bash-utilities-full.md](../archive/bash-utilities-full.md) for detailed library comparisons and code examples.

---

**Decision Date:** 2024-11-19
