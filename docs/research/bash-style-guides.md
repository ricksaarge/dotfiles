# Bash Style Guide Research

**SELECTED: https://style.ysap.sh/**

**Why**: Tabs over spaces, bash-first (not POSIX), built-ins over external commands, safety-focused

---

## Decision

| Selected | Reason |
|----------|--------|
| style.ysap.sh | Tabs, bash-specific, practical, modern |

**Rejected**: Google Style Guide (spaces, overly verbose)

---

## Comparison

| Rule | style.ysap.sh | Google Style Guide |
|------|---------------|-------------------|
| **Indentation** | Tabs | 2 spaces |
| **Line length** | 80 chars | No strict limit |
| **Function syntax** | `foo()` | `foo()` (no `function`) |
| **Conditionals** | `[[ ... ]]` | `[[ ... ]]` |
| **Variables** | Lowercase | Lowercase (except constants) |
| **Local vars** | Always `local` | Always `local` |
| **set -e** | Avoid | Use with caution |
| **Philosophy** | Bash-first | Bash-first |

---

## style.ysap.sh Principles

### Formatting

| Rule | Spec |
|------|------|
| Indentation | Tabs (not spaces) |
| Line length | <80 chars |
| Blank lines | Max 1 consecutive |
| Semicolons | Only in control flow |

### Bash-Specific

**Prefer built-ins over external commands:**

| Task | Built-in | External |
|------|----------|----------|
| Conditionals | `[[ ... ]]` | `[ ... ]`, `test` |
| Arithmetic | `$((...))` | `expr`, `bc` |
| String ops | `${var#pattern}` | `sed`, `awk` |
| Command sub | `$(...)` | Backticks |
| Loops | `for *` | `ls \| while` |

### Variables

```bash
# Lowercase by default
local my_var="value"

# Quote unless controlled
echo "$my_var"      # YES
echo $?             # OK (controlled)

# Local in functions
my_function() {
  local result="foo"
}
```

### Error Handling

```bash
# Check commands
cd /path || { echo "Failed"; exit 1; }

# Avoid set -e (unpredictable)
# Use explicit checks instead
```

### Anti-Patterns

❌ **Avoid**:
- `eval` (injection risk)
- `cat file | grep` (useless cat)
- `for line in $(cat file)` (use `while read`)
- `${var}` when `"$var"` works
- Semicolons outside control flow

---

## Google Style Guide Principles

### Formatting

| Rule | Spec |
|------|------|
| Indentation | 2 spaces |
| Tabs | FORBIDDEN (except heredoc) |
| Line length | Recommended <80 |
| Brace placement | Same line as function |

### Function Naming

```bash
# Lower-case with underscores
my_function() {
  local result
  result=$(do_something)
}

# Package separator OK
mypackage::my_function() {
  ...
}
```

### Comments

**REQUIRED**:
- File header (brief overview)
- Function comments (unless obvious + short)

```bash
#!/bin/bash
#
# Perform hot backups of Oracle databases.

##
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
# Arguments:
#   None
##
cleanup() {
  ...
}
```

---

## Key Differences

### 1. **Indentation Philosophy**

**style.ysap.sh** (tabs):
```bash
if [[ -f file ]]; then
	echo "found"  # TAB
fi
```

**Google** (2 spaces):
```bash
if [[ -f file ]]; then
  echo "found"  # 2 SPACES
fi
```

### 2. **Comments**

**style.ysap.sh**: Minimal (code should be clear)

**Google**: Verbose (file headers + function docs)

### 3. **set -e Stance**

**style.ysap.sh**: Avoid (unpredictable behavior)

**Google**: Use carefully with understanding

---

## Why style.ysap.sh Wins

| Advantage | Impact |
|-----------|--------|
| **Tabs** | Less typing, adjustable width |
| **Practical** | No bureaucratic comment requirements |
| **Modern** | Updated recently (2023+) |
| **Focused** | Bash-specific, not POSIX |
| **Concise** | 1-page reference |

**Google is enterprise-focused** (comments, standards)
**style.ysap.sh is developer-focused** (efficiency, clarity)

---

## Application to Dotfiles

### Follow style.ysap.sh

```bash
#!/bin/bash
set -eo pipefail

# Load utilities
source vendor/bash-utility/bash-utility.sh

# Private functions
_info() {
	echo "[INFO] $1"
}

# Public functions
install-homebrew() {
	if ! command -v brew >/dev/null 2>&1; then
		_info "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

# Dispatcher
if declare -f "$1" >/dev/null 2>&1; then
	"$1" "${@:2}"
else
	echo "Unknown command: $1"
	exit 1
fi
```

**Key points**:
- Tabs for indentation
- `[[ ... ]]` for conditionals
- `local` for function variables
- Explicit error checking (no `set -e`)
- Built-ins over external commands

---

## Related

- https://style.ysap.sh/ - Selected guide
- https://google.github.io/styleguide/shellguide.html - Alternative
- [../index.md](../index.md) - Architecture decisions
