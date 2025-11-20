# Logging Approach Decision

**SELECTED: Inline helpers (_info, _error)**

**Why**: 2-3 functions don't justify another dependency, keeps it simple

---

## Decision

| Selected | Reason |
|----------|--------|
| Inline `_info()` and `_error()` | Only need 2-3 functions |

**Rejected**: cyberark/bash-lib (665 stars, excellent but overkill for our needs)

---

## Options Evaluated

### Option 1: Inline Helpers

```bash
_info() { echo "[INFO] $1"; }
_error() { echo "[ERROR] $1" >&2; exit 1; }
```

**Pros:**
- Zero dependencies beyond labbots/bash-utility
- 2 lines of code
- Sufficient for dotfiles installer

**Cons:**
- No log levels
- No colored output
- No file logging

### Option 2: cyberark/bash-lib

```bash
source vendor/bash-lib/init
source "${BASH_LIB_DIR}/logging/lib"

bl_info "Installing packages..."
bl_error "Installation failed"
bl_debug "Detailed output"
```

**Pros:**
- Production-grade (used by CyberArk)
- Multiple log levels (debug, info, warning, error, fatal)
- Retry logic included
- Environment-based log level control

**Cons:**
- Requires git subtree setup
- Requires SHA pinning
- 665-star library for 3-4 log statements
- Overkill for dotfiles installer

### Option 3: fidian/ansi (Colors)

```bash
source ansi
ansi::green; echo "✓ Installed"; ansi::reset
ansi::red; echo "✗ Failed"; ansi::reset
```

**Pros:**
- Colorful output
- Single file
- 769 stars

**Cons:**
- Not logging-focused
- Still need error handling
- Adds complexity for visual polish only

---

## Analysis

### Logging Needs for Dotfiles Installer

| Use Case | Frequency | Complexity |
|----------|-----------|------------|
| Success messages | 5-10 times | Low |
| Error messages | 3-5 times | Low |
| Debug output | Rarely | Low |
| File logging | Never | N/A |
| Retry logic | Never | N/A |

**Total log statements**: ~10-15 across entire script

### Complexity Threshold

| Scenario | Justifies Library |
|----------|-------------------|
| 50+ log statements | Yes |
| Multiple log levels needed | Yes |
| File/syslog output | Yes |
| Retry with logging | Yes |
| **10-15 simple logs** | **No** |

---

## Implementation

### Inline Helpers (Selected)

```bash
#!/bin/bash
set -eo pipefail

# Load bash-utility for OS/command detection
source vendor/bash-utility/bash-utility.sh

# Private logging helpers
_info() {
	echo "[INFO] $1"
}

_error() {
	echo "[ERROR] $1" >&2
	exit 1
}

# Usage
install-homebrew() {
	if check::command_exists brew; then
		_info "Homebrew already installed"
		return
	fi

	_info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
		|| _error "Homebrew installation failed"
}
```

---

## Rationale

**Zen of Python applied:**

| Principle | Application |
|-----------|-------------|
| Simple is better than complex | 2 functions vs library |
| Flat is better than nested | No vendor/bash-lib tree |
| Readability counts | Clear `_info()` calls |

**Trade-offs accepted:**
- No colored output (acceptable)
- No log levels (don't need debug/warn/trace)
- No file logging (not required)

**Benefits:**
- One dependency (labbots/bash-utility)
- 2 lines of code
- Sufficient for use case
- Easy to understand
- Easy to maintain

---

## Future Considerations

**IF logging needs grow** (>30 statements, multiple log levels):

1. Add cyberark/bash-lib via git subtree
2. Pin to specific SHA
3. Migrate inline helpers to `bl_info()`, `bl_error()`

**Current threshold**: Not reached (10-15 statements)

---

## Related

- [bash-utilities.md](bash-utilities.md) - cyberark/bash-lib details
- [taskfile-pattern.md](taskfile-pattern.md) - Uses inline helpers
- [../specs/task-file.md](../specs/task-file.md) - Implementation spec
