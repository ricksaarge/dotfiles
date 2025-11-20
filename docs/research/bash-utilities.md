# Bash Utility Libraries Research

**SELECTED: labbots/bash-utility**

**Why**: Complete OS detection (macOS/Ubuntu), command checking, MIT license, zero config

---

## Decision

| Selected | Reason |
|----------|--------|
| labbots/bash-utility | OS detection + command utilities in one package |

**Rejected**: Inline functions (complexity threshold exceeded with 2+ platforms)

---

## Summary

| Category | Top Recommendation | Stars | Reason |
|----------|-------------------|-------|--------|
| **All-in-One** | labbots/bash-utility | 228 | Complete utilities, OS detection, command checking |
| **Logging** | cyberark/bash-lib | 665 | Production-grade, retry logic, clean API |
| **Strict Mode** | bpm-rocks/strict | 4 | Stack traces, comprehensive error handling |
| **Colors** | fidian/ansi | 769 | Full ANSI support, dual CLI/library mode |
| **Testing** | torokmark/assert.sh | 152 | JUnit-style assertions, comprehensive |

---

## Recommended Libraries

### 1. labbots/bash-utility

**GitHub:** https://github.com/labbots/bash-utility
**Stars:** 228
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **OS Detection** | detect_os, detect_linux_distro, detect_linux_version, detect_mac_version |
| **Command Utilities** | command_exists, is_sudo |
| **Validation** | email, ipv4, ipv6, alpha, alpha_num, version_comparison |
| **Arrays** | contains, dedupe, join, sort, reverse |
| **Debug** | print_array, print_ansi |
| **Formatting** | strip_ansi, text_center |

#### Code Examples

```bash
# Installation
git clone https://github.com/labbots/bash-utility.git ./vendor/bash-utility
source "vendor/bash-utility/bash-utility.sh"

# OS Detection
os=$(os::detect_os)              # Returns: linux, mac, or windows
distro=$(os::detect_linux_distro) # Returns: ubuntu, debian, suse, etc.
version=$(os::detect_linux_version) # Returns: 20.04

# Command Checking
if check::command_exists "git"; then
  echo "Git is installed"
fi

# Sudo Detection
if check::is_sudo; then
  echo "Running with sudo privileges"
fi

# Array Operations
array::contains "item" "${my_array[@]}"
sorted=$(array::sort "${my_array[@]}")
```

#### Verdict

**EXCELLENT for dotfiles installation scripts**

- Comprehensive OS detection (Linux, Mac, Windows)
- Command existence checking
- Sudo privilege detection
- Well-documented with examples
- Modular design (import only what you need)

---

### 2. cyberark/bash-lib

**GitHub:** https://github.com/cyberark/bash-lib
**Stars:** 665
**License:** Apache 2.0
**Status:** Alpha (ready for use, needs expansion)

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Logging** | announce, log, debug, info, warning, error, fatal |
| **Error Handling** | die, fail |
| **Retry Logic** | retry (escalating), retry_constant |
| **Directory Ops** | spushd, spopd (safe pushd/popd) |
| **Command Checking** | git_available, hub_available, curl_available, jq_available |
| **Git Utilities** | repo_root, remote_latest_tag, all_files_in_repo |

#### Code Examples

```bash
# Installation (Git Subtree - recommended)
git subtree add --prefix vendor/bash-lib https://github.com/cyberark/bash-lib.git <SHA> --squash

# Usage
source vendor/bash-lib/init
source "${BASH_LIB_DIR}/logging/lib"
source "${BASH_LIB_DIR}/helpers/lib"

# Logging
bl_announce "Starting Installation"
bl_info "Installing dependencies..."
bl_warning "Configuration file not found"
bl_error "Installation failed"
bl_fatal "Critical error occurred"

# Respects environment variable
export BASH_LIB_LOG_LEVEL=debug
bl_debug "Detailed debug information"

# Retry with escalating delays
bl_retry "curl -f https://example.com/package"

# Retry with constant delay
bl_retry_constant "ping -c 1 server.com"

# Error handling
bl_die "Fatal error: cannot continue"  # Exits with code 1
command || bl_fail "Command failed"    # Returns 1

# Command checking
if bl_curl_available; then
  echo "curl is available"
fi
```

#### Verdict

**EXCELLENT for production dotfiles**

- Production-grade (used by CyberArk)
- Sophisticated retry logic
- Clean logging API
- Requires version pinning (stability)
- More complex setup than others

---

### 3. martinburger/bash-common-helpers

**GitHub:** https://github.com/martinburger/bash-common-helpers
**Stars:** 77
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Initialization** | init, assert_running_as_root |
| **Output** | echo_info (green), echo_important (yellow), echo_warn (red) |
| **Error Handling** | die |
| **Validation** | assert_command_is_available, assert_file_exists, assert_file_not_exist |
| **User Prompts** | ask_for_confirmation, ask_for_password |
| **File Ops** | replace_in_files (Perl-based) |
| **Parsing** | INI file parser |

#### Code Examples

```bash
# Installation
git clone https://github.com/martinburger/bash-common-helpers.git ~/local/lib/bash-common-helpers
export BASH_COMMON_HELPERS_LIB=~/local/lib/bash-common-helpers/bash-common-helpers.sh

# Usage
source "${BASH_COMMON_HELPERS_LIB}"
cmn_init || exit 3

# Colored output
cmn_echo_info "Installation started"
cmn_echo_important "Please review configuration"
cmn_echo_warn "Backup recommended"

# Validation
cmn_assert_command_is_available "git"
cmn_assert_file_exists "/etc/config"

# User interaction
if cmn_ask_for_confirmation "Proceed with installation?"; then
  echo "Proceeding..."
fi

password=$(cmn_ask_for_password "Enter password:")

# Root check
cmn_assert_running_as_root || exit 1
```

#### Verdict

**GOOD for interactive dotfiles installers**

- Simple API
- Color-coded messaging
- User interaction helpers
- Good for scripts requiring user input
- Smaller feature set than others

---

### 4. vlisivka/bash-modules

**GitHub:** https://github.com/vlisivka/bash-modules
**Stars:** 142
**License:** LGPL-2.1

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Logging** | debug, info, warn, error, todo, unimplemented |
| **Argument Parsing** | Type validation, default values, complex CLI parsing |
| **Testing** | Unit testing support |
| **Strict Mode** | Unofficial bash strict mode (set -ue) |

#### Code Examples

```bash
# Installation
./install.sh  # Installs to ~/.local by default

# Basic logging
#!/bin/bash
. import.sh log
info "Hello, world!"
debug "Verbose output"
warn "Warning message"
error "Error occurred"

# Argument parsing with validation
arguments::parse \
  "-n|--name)NAME;String,Required" \
  "-a|--age)AGE;Number,(( AGE >= 18 ))" \
  "-e|--email)EMAIL;Email" \
  -- "$@" || panic "Cannot parse arguments."

echo "Name: $NAME, Age: $AGE"
```

#### Verdict

**GOOD for complex CLI argument parsing**

- Sophisticated argument parsing
- Type validation
- LGPL license (must remain separate library)
- Overkill for simple installers
- Excellent for complex scripts

---

### 5. niieani/bash-oo-framework (Bash Infinity)

**GitHub:** https://github.com/niieani/bash-oo-framework
**Stars:** 5,600
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Error Handling** | Exceptions, try-catch blocks, visual stack traces |
| **Logging** | Colorful logging, Powerline characters, custom delegates |
| **Named Parameters** | Function parameters with meaningful names |
| **Type System** | String, array, integer, map operations |
| **OOP** | Classes, public/private properties, method chaining |

#### Code Examples

```bash
# Exception handling
import util/exception
e="Database connection failed" throw

# Named parameters
import util/namedParameters
install_package() {
  [string] package_name
  [string] version="latest"
  [array] options=()

  echo "Installing $package_name version $version"
}
install_package --package_name="nginx" --version="1.20"

# Logging
import util/log
Log "Application started"
Log+ "Additional info"
```

#### Verdict

**NOT RECOMMENDED for dotfiles**

- Framework, not library (heavy dependency)
- Overkill for installation scripts
- Components vary in stability
- Good for large Bash applications
- Cherry-pick individual features instead

---

### 6. Zordrak/bashlog

**GitHub:** https://github.com/Zordrak/bashlog
**Stars:** 92
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Logging** | info, warn, error, debug log levels |
| **Output Formats** | stdout, file, JSON, syslog |
| **Debug Features** | Interactive shell on error, prev_cmd variable |
| **Shell Options** | set -uo pipefail |

#### Code Examples

```bash
# Installation
. log.sh

# Basic logging
log info "Installation started"
log debug "Checking dependencies"
log warn "Configuration missing, using defaults"
log error "Package not found"

# Chain with commands
yum install package && \
  log info "Installation successful" || \
  log error "Installation failed"

# Output to file
export BASHLOG_FILE=1
export BASHLOG_FILE_PATH="/var/log/install.log"

# JSON output
export BASHLOG_JSON=1

# Syslog
export BASHLOG_SYSLOG=1

# Enable debugging (get interactive shell on error)
DEBUG=1 ./install.sh
```

#### Verdict

**GOOD for logging-focused needs**

- Simple API
- Multiple output formats
- Interactive debugging
- Sets safe shell options
- Limited to logging only

---

### 7. idelsink/b-log

**GitHub:** https://github.com/idelsink/b-log
**Stars:** 81
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Logging** | FATAL, ERROR, WARN, INFO, DEBUG, TRACE levels |
| **Outputs** | stdout, file, syslog (multiple simultaneous) |
| **Customization** | Custom templates, custom error levels |
| **Piping** | Error message piping |

#### Code Examples

```bash
# Installation
source "./b-log.sh"

# Basic usage
LOG_LEVEL_ALL
INFO "Informational message"
ERROR "Error message"
DEBUG "Debug output"

# File logging with prefixes/suffixes
B_LOG --file log.txt --file-prefix-enable --file-suffix-enable

# Syslog
B_LOG --syslog '--tag dotfiles-install'

# Custom log levels
B_LOG --log-levels-prefix "custom_"
custom_INFO "Custom info message"
```

#### Verdict

**GOOD alternative to bashlog**

- More customization options
- Multiple simultaneous outputs
- Custom templates
- Slightly more complex than bashlog

---

### 8. fidian/ansi

**GitHub:** https://github.com/fidian/ansi
**Stars:** 769
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Text Colors** | 16 colors, 256-color, RGB support |
| **Backgrounds** | Same as text colors |
| **Attributes** | bold, italic, underline, blink, inverse, strike-through |
| **Cursor Control** | Movement, positioning, visibility |
| **Display** | Screen clear, line operations, scrolling |

#### Code Examples

```bash
# Installation
curl -OL git.io/ansi
chmod 755 ansi
sudo mv ansi /usr/local/bin/

# Command-line usage
ansi --green --newline "Tests pass"
ansi --red --bold "ERROR: Installation failed"
ansi --blue --underline "https://example.com"

# Set terminal title
ansi --title="Installing dotfiles" --no-newline

# Library usage
source ansi

ansi::green
echo "This text is green"
ansi::resetForeground

ansi::bold
ansi::red
echo "Bold red text"
ansi::resetFont
ansi::resetColor

# Cursor manipulation
ansi --position=10,5 --hide-cursor
echo "Text at row 10, column 5"
ansi --show-cursor

# Query terminal
rows=$(ansi --report-window-chars | cut -d , -f 1)
```

#### Verdict

**EXCELLENT for colored output**

- Comprehensive ANSI support
- Both CLI and library modes
- Cursor and screen control
- Well-maintained
- Perfect for visual installation scripts

---

### 9. xwmx/bash-boilerplate

**GitHub:** https://github.com/xwmx/bash-boilerplate
**Stars:** 780
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Templates** | Simple, simple-plus, subcommands architectures |
| **Strict Mode** | nounset, errexit, pipefail, proper IFS |
| **Error Handling** | _exit_1, _warn functions |
| **Helpers** | _command_exists, various utility functions |
| **Option Parsing** | Built-in argument parsing |

#### Code Examples

```bash
# Not a library - provides templates
# Download and modify templates

# Key patterns from bash-simple-plus:

# Strict mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# Command checking
_command_exists() {
  command -v "$1" &>/dev/null
}

# Error handling
_exit_1() {
  printf "Error: %s\n" "$1"
  exit 1
}

# Safe parameter expansion
name="${name:-default_value}"
required="${required:?Error: required variable not set}"

# Usage
if ! _command_exists "git"; then
  _exit_1 "git is required but not installed"
fi
```

#### Verdict

**EXCELLENT for script templates**

- Not a library (templates to copy/modify)
- Best practices baked in
- ShellCheck compliant
- Multiple architecture options
- Great starting point

---

### 10. torokmark/assert.sh

**GitHub:** https://github.com/torokmark/assert.sh
**Stars:** 152
**License:** MIT (assumed)

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Comparisons** | assert_eq, assert_not_eq |
| **Boolean** | assert_true, assert_false |
| **Arrays** | assert_array_eq, assert_array_not_eq |
| **Empty Checks** | assert_empty, assert_not_empty |
| **Substring** | assert_contain, assert_not_contain |
| **Numeric** | assert_gt, assert_ge, assert_lt, assert_le |

#### Code Examples

```bash
# Installation
git clone https://github.com/torokmark/assert.sh.git
source './assert.sh'

# String comparison
expected="Hello"
actual="Hello"
assert_eq "$expected" "$actual"

# Numeric comparison
assert_gt 10 5
assert_le "$age" 100

# Arrays
expected_array=("a" "b" "c")
actual_array=("a" "b" "c")
assert_array_eq "${expected_array[@]}" "${actual_array[@]}"

# Empty checks
assert_not_empty "$required_var"
assert_empty "$should_be_empty"

# Substring
assert_contain "foo" "foobar"
assert_not_contain "baz" "foobar"

# Boolean
assert_true "[[ -f /etc/hosts ]]"
assert_false "[[ -f /nonexistent ]]"
```

#### Verdict

**GOOD for testing installation scripts**

- JUnit-style assertions
- 14 comprehensive functions
- Simple API
- Returns proper exit codes
- Best paired with test framework

---

### 11. bpm-rocks/strict

**GitHub:** https://github.com/bpm-rocks/strict
**Stars:** 4
**License:** MIT

#### Utilities Provided

| Category | Functions |
|----------|-----------|
| **Strict Mode** | Automatic exit on errors, unset variables, pipeline failures |
| **Stack Traces** | File locations, line numbers, function parameters |
| **Error Handling** | ERR trap with detailed output |
| **Control** | Enable/disable strict mode, safe command execution |

#### Code Examples

```bash
# Installation via BPM
. bpm
bpm::include strict

# Enable strict mode
strict::mode

# Now your script has:
# - set -eEu -o pipefail
# - shopt -s extdebug
# - IFS=$'\n\t'
# - ERR trap with stack traces

# Example error output:
# Error detected - status code 1
# Command: false
# Location: ./install.sh, line 13
# Stack Trace:
#   [1] install_deps(): ./install.sh, line 13
#   [2] main(): ./install.sh, line 45

# Temporarily disable for specific commands
strict::disable
risky_command_that_may_fail
strict::mode

# Run command and capture return code safely
strict::run return_code risky_command
if [[ "$return_code" -ne 0 ]]; then
  echo "Command failed with code $return_code"
fi
```

#### Verdict

**EXCELLENT for robust error handling**

- Automatic stack traces
- Catches errors early
- Easy to enable/disable
- Small and focused
- Perfect complement to other libraries

---

## Comparison Matrix

### Feature Coverage

| Library | Logging | OS Detection | Sudo | Command Exists | Retry | Error Handling | Colors | Testing |
|---------|---------|--------------|------|----------------|-------|----------------|--------|---------|
| **labbots/bash-utility** | ✓ | ✓✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ |
| **cyberark/bash-lib** | ✓✓ | ✗ | ✗ | ✓ | ✓✓ | ✓✓ | ✗ | ✗ |
| **martinburger/helpers** | ✓ | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ |
| **vlisivka/bash-modules** | ✓✓ | ✗ | ✗ | ✗ | ✗ | ✓✓ | ✗ | ✓ |
| **bash-oo-framework** | ✓✓ | ✗ | ✗ | ✗ | ✗ | ✓✓ | ✓ | ✗ |
| **bashlog** | ✓✓ | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| **b-log** | ✓✓ | ✗ | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| **fidian/ansi** | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✓✓ | ✗ |
| **bash-boilerplate** | ✓ | ✗ | ✗ | ✓ | ✗ | ✓✓ | ✗ | ✗ |
| **assert.sh** | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✓✓ |
| **bpm-rocks/strict** | ✗ | ✗ | ✗ | ✗ | ✗ | ✓✓ | ✗ | ✗ |

**Legend:** ✓✓ = Excellent, ✓ = Good, ✗ = Not provided

---

## Recommended Combinations

### Minimal Setup (Single Library)

```bash
# Use: labbots/bash-utility
# Provides: OS detection, command checking, sudo detection, validation

git clone https://github.com/labbots/bash-utility.git ./vendor/bash-utility
source "vendor/bash-utility/bash-utility.sh"

os=$(os::detect_os)
if check::command_exists "git"; then
  echo "Git found"
fi
```

**Use when:** Simple dotfiles, minimal dependencies, quick setup

---

### Production Setup (Multi-Library)

```bash
# 1. cyberark/bash-lib (logging, retry)
source vendor/bash-lib/init
source "${BASH_LIB_DIR}/logging/lib"
source "${BASH_LIB_DIR}/helpers/lib"

# 2. labbots/bash-utility (OS detection, validation)
source "vendor/bash-utility/bash-utility.sh"

# 3. bpm-rocks/strict (error handling)
source vendor/strict/strict
strict::mode

# 4. fidian/ansi (colors) - optional
source vendor/ansi

# Now you have everything:
bl_announce "Installing Dotfiles"

os=$(os::detect_os)
bl_info "Detected OS: $os"

if ! check::command_exists "git"; then
  bl_error "git is required"
  exit 1
fi

bl_retry "curl -f https://example.com/package"
```

**Use when:** Complex dotfiles, multiple platforms, production quality

---

### Interactive Setup

```bash
# 1. martinburger/bash-common-helpers (user prompts, colored output)
source "${BASH_COMMON_HELPERS_LIB}"
cmn_init

# 2. fidian/ansi (enhanced colors)
source vendor/ansi

# User interaction
cmn_echo_important "Dotfiles Installation"
if cmn_ask_for_confirmation "Install developer tools?"; then
  install_dev_tools
fi

password=$(cmn_ask_for_password "Enter sudo password:")
```

**Use when:** User-facing installers, interactive configuration

---

### Template-Based Setup

```bash
# Start with: xwmx/bash-boilerplate
# Download bash-simple-plus template
# Modify for your needs

# Built-in strict mode, error handling, helpers
# No external dependencies
# Copy/paste and modify
```

**Use when:** Learning, self-contained scripts, no dependency management

---

## Installation Patterns

### Git Submodule (Version Controlled)

```bash
git submodule add https://github.com/labbots/bash-utility.git vendor/bash-utility
git submodule add https://github.com/cyberark/bash-lib.git vendor/bash-lib
git submodule init
git submodule update
```

**Pros:** Version pinned, tracked in git
**Cons:** Team needs to run submodule commands

---

### Git Subtree (Embedded)

```bash
git subtree add --prefix vendor/bash-lib \
  https://github.com/cyberark/bash-lib.git <SHA> --squash
```

**Pros:** No workflow changes, code embedded
**Cons:** Harder to update

---

### Direct Clone (Simple)

```bash
# In install.sh
if [[ ! -d "vendor/bash-utility" ]]; then
  git clone https://github.com/labbots/bash-utility.git vendor/bash-utility
fi
source vendor/bash-utility/bash-utility.sh
```

**Pros:** Simple, automatic
**Cons:** No version pinning, tracks master

---

### Single File Copy

```bash
# Download single-file libraries
curl -o lib/log.sh https://raw.githubusercontent.com/Zordrak/bashlog/master/log.sh
source lib/log.sh
```

**Pros:** No git dependencies, fast
**Cons:** Manual updates

---

## Best Practices

### Version Pinning

| Method | Command |
|--------|---------|
| Submodule | `git submodule add -b v1.0.0` |
| Subtree | Include SHA in command |
| Clone | `git clone -b v1.0.0` or `git checkout <SHA>` |
| Curl | Include SHA in raw URL |

**REQUIRED:** Pin versions in production scripts

---

### Dependency Checking

```bash
# Check library exists before sourcing
if [[ ! -f "vendor/bash-utility/bash-utility.sh" ]]; then
  echo "Error: bash-utility not found"
  echo "Run: git submodule update --init"
  exit 1
fi

source "vendor/bash-utility/bash-utility.sh"
```

---

### Graceful Degradation

```bash
# Function without library dependency
command_exists() {
  command -v "$1" &>/dev/null
}

# Use library if available, fallback otherwise
if [[ -f "vendor/bash-utility/bash-utility.sh" ]]; then
  source "vendor/bash-utility/bash-utility.sh"
  alias command_exists=check::command_exists
fi
```

---

### Minimal Sourcing

```bash
# Source only what you need

# bash-utility: individual modules
source "vendor/bash-utility/src/os.sh"
source "vendor/bash-utility/src/check.sh"

# cyberark/bash-lib: selective loading
source vendor/bash-lib/init
source "${BASH_LIB_DIR}/logging/lib"  # Only logging
# Don't source git/lib if not needed
```

---

## Code Snippets

### Complete Installation Script Template

```bash
#!/usr/bin/env bash
#
# Dotfiles installation script
#

set -euo pipefail
IFS=$'\n\t'

# ===== SETUP LIBRARIES =====

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_DIR="${SCRIPT_DIR}/vendor"

# Load bash-lib (logging, retry)
if [[ ! -f "${VENDOR_DIR}/bash-lib/init" ]]; then
  echo "Error: bash-lib not found. Run: git submodule update --init"
  exit 1
fi
source "${VENDOR_DIR}/bash-lib/init"
source "${BASH_LIB_DIR}/logging/lib"
source "${BASH_LIB_DIR}/helpers/lib"

# Load bash-utility (OS detection, command checking)
if [[ ! -f "${VENDOR_DIR}/bash-utility/bash-utility.sh" ]]; then
  echo "Error: bash-utility not found. Run: git submodule update --init"
  exit 1
fi
source "${VENDOR_DIR}/bash-utility/bash-utility.sh"

# Load strict mode (error handling)
if [[ -f "${VENDOR_DIR}/strict/strict" ]]; then
  source "${VENDOR_DIR}/strict/strict"
  strict::mode
fi

# ===== MAIN FUNCTIONS =====

detect_system() {
  bl_announce "Detecting System"

  local os distro version
  os=$(os::detect_os)
  bl_info "OS: ${os}"

  if [[ "$os" == "linux" ]]; then
    distro=$(os::detect_linux_distro)
    version=$(os::detect_linux_version)
    bl_info "Distribution: ${distro} ${version}"
  elif [[ "$os" == "mac" ]]; then
    version=$(os::detect_mac_version)
    bl_info "macOS version: ${version}"
  fi

  echo "$os"
}

check_dependencies() {
  bl_announce "Checking Dependencies"

  local deps=("git" "curl" "make")
  local missing=()

  for dep in "${deps[@]}"; do
    if check::command_exists "$dep"; then
      bl_info "✓ ${dep}"
    else
      bl_warning "✗ ${dep} - not found"
      missing+=("$dep")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    bl_error "Missing dependencies: ${missing[*]}"
    return 1
  fi

  return 0
}

install_packages() {
  local os="$1"
  bl_announce "Installing Packages"

  case "$os" in
    linux)
      install_linux_packages
      ;;
    mac)
      install_mac_packages
      ;;
    *)
      bl_error "Unsupported OS: $os"
      return 1
      ;;
  esac
}

install_linux_packages() {
  local distro
  distro=$(os::detect_linux_distro)

  case "$distro" in
    ubuntu|debian)
      bl_info "Installing via apt..."
      bl_retry "sudo apt-get update"
      bl_retry "sudo apt-get install -y build-essential"
      ;;
    fedora|centos|rhel)
      bl_info "Installing via yum/dnf..."
      bl_retry "sudo yum install -y gcc make"
      ;;
    *)
      bl_warning "Unknown distro: $distro"
      ;;
  esac
}

install_mac_packages() {
  if ! check::command_exists "brew"; then
    bl_info "Installing Homebrew..."
    bl_retry '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  fi

  bl_info "Installing packages via brew..."
  bl_retry "brew install coreutils"
}

link_dotfiles() {
  bl_announce "Linking Dotfiles"

  local dotfiles=(
    "bashrc:.bashrc"
    "vimrc:.vimrc"
    "gitconfig:.gitconfig"
  )

  for entry in "${dotfiles[@]}"; do
    local src="${entry%%:*}"
    local dst="${entry##*:}"
    local src_path="${SCRIPT_DIR}/${src}"
    local dst_path="${HOME}/${dst}"

    if [[ -L "$dst_path" ]]; then
      bl_info "✓ ${dst} (already linked)"
      continue
    fi

    if [[ -f "$dst_path" ]]; then
      bl_warning "Backing up existing ${dst}"
      mv "$dst_path" "${dst_path}.backup"
    fi

    ln -s "$src_path" "$dst_path"
    bl_info "✓ Linked ${dst}"
  done
}

main() {
  bl_announce "Dotfiles Installation Starting"

  # Detect system
  local os
  os=$(detect_system) || bl_die "Failed to detect OS"

  # Check dependencies
  check_dependencies || bl_die "Dependency check failed"

  # Check sudo if needed
  if check::is_sudo; then
    bl_warning "Running with sudo - this may not be necessary"
  fi

  # Install packages
  install_packages "$os" || bl_die "Package installation failed"

  # Link dotfiles
  link_dotfiles || bl_die "Dotfile linking failed"

  bl_announce "Installation Complete!"
}

# ===== ENTRY POINT =====

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
```

---

### Standalone Functions (No Dependencies)

```bash
#!/usr/bin/env bash
#
# Standalone utility functions (no library dependencies)
#

# OS Detection
detect_os() {
  case "$OSTYPE" in
    linux*)   echo "linux" ;;
    darwin*)  echo "mac" ;;
    msys*|cygwin*) echo "windows" ;;
    *)        echo "unknown" ;;
  esac
}

# Linux Distribution Detection
detect_linux_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  elif command -v lsb_release &>/dev/null; then
    lsb_release -si | tr '[:upper:]' '[:lower:]'
  else
    echo "unknown"
  fi
}

# Command Exists Check
command_exists() {
  command -v "$1" &>/dev/null
}

# Sudo Check
is_sudo() {
  [[ "$EUID" -eq 0 ]]
}

# Retry Function
retry() {
  local max_attempts="${2:-5}"
  local delay="${3:-5}"
  local attempt=1

  while [[ $attempt -le $max_attempts ]]; do
    if "$@"; then
      return 0
    fi

    echo "Attempt $attempt failed. Retrying in ${delay}s..."
    sleep "$delay"
    ((attempt++))
    ((delay *= 2))  # Exponential backoff
  done

  return 1
}

# Colored Output
color_echo() {
  local color="$1"
  shift
  local message="$*"

  case "$color" in
    red)     echo -e "\033[0;31m${message}\033[0m" ;;
    green)   echo -e "\033[0;32m${message}\033[0m" ;;
    yellow)  echo -e "\033[0;33m${message}\033[0m" ;;
    blue)    echo -e "\033[0;34m${message}\033[0m" ;;
    *)       echo "$message" ;;
  esac
}

info()  { color_echo green "[INFO] $*"; }
warn()  { color_echo yellow "[WARN] $*"; }
error() { color_echo red "[ERROR] $*"; }

# Usage Examples
os=$(detect_os)
info "Detected OS: $os"

if command_exists "git"; then
  info "Git is installed"
else
  error "Git is not installed"
fi

if is_sudo; then
  warn "Running with root privileges"
fi

retry "curl -f https://example.com/file" 3 2
```

---

## OS Detection Reference

### Platform Detection

```bash
# Using $OSTYPE
case "$OSTYPE" in
  linux-gnu*)  echo "Linux" ;;
  darwin*)     echo "macOS" ;;
  freebsd*)    echo "FreeBSD" ;;
  netbsd*)     echo "NetBSD" ;;
  openbsd*)    echo "OpenBSD" ;;
  solaris*)    echo "Solaris" ;;
  msys*)       echo "Windows (MSYS)" ;;
  cygwin*)     echo "Windows (Cygwin)" ;;
  *)           echo "Unknown: $OSTYPE" ;;
esac

# Using uname
kernel=$(uname -s)
case "$kernel" in
  Linux)   echo "Linux" ;;
  Darwin)  echo "macOS" ;;
  FreeBSD) echo "FreeBSD" ;;
  *)       echo "Other: $kernel" ;;
esac
```

### Linux Distribution Detection

```bash
# Method 1: /etc/os-release (modern systems)
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  echo "Distro: $ID"
  echo "Version: $VERSION_ID"
  echo "Name: $PRETTY_NAME"
fi

# Method 2: lsb_release (if available)
if command -v lsb_release &>/dev/null; then
  distro=$(lsb_release -si)
  version=$(lsb_release -sr)
  echo "$distro $version"
fi

# Method 3: Legacy files
if [[ -f /etc/redhat-release ]]; then
  cat /etc/redhat-release
elif [[ -f /etc/debian_version ]]; then
  echo "Debian $(cat /etc/debian_version)"
fi
```

### macOS Version Detection

```bash
# Using sw_vers
macos_version=$(sw_vers -productVersion)
echo "macOS $macos_version"

# Using system_profiler (more detailed)
system_profiler SPSoftwareDataType
```

---

## Sudo Detection Reference

### Check Root Privileges

```bash
# Method 1: $EUID
if [[ "$EUID" -eq 0 ]]; then
  echo "Running as root"
fi

# Method 2: $UID
if [[ "$UID" -eq 0 ]]; then
  echo "Running as root"
fi

# Method 3: id command
if [[ "$(id -u)" -eq 0 ]]; then
  echo "Running as root"
fi

# Method 4: whoami
if [[ "$(whoami)" == "root" ]]; then
  echo "Running as root"
fi
```

### Request Sudo

```bash
# Keep sudo alive during script
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Run specific commands with sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "Requesting sudo privileges..."
  sudo -v || exit 1
fi
sudo apt-get install package
```

---

## Additional Resources

| Resource | Description |
|----------|-------------|
| **awesome-bash** | Curated list: https://github.com/awesome-lists/awesome-bash |
| **awesome-shell** | Shell frameworks: https://github.com/alebay/awesome-shell |
| **ShellCheck** | Static analysis: https://github.com/koalaman/shellcheck |
| **shfmt** | Shell formatter: https://github.com/mvdan/sh |
| **Bash Strict Mode** | Article: http://redsymbol.net/articles/unofficial-bash-strict-mode/ |
| **Google Shell Style** | Guide: https://google.github.io/styleguide/shellguide.html |

---

## Conclusion

### For Dotfiles Installation Scripts

**Recommended Stack:**

| Component | Library | Reason |
|-----------|---------|--------|
| **Core Utilities** | labbots/bash-utility | OS detection, command checking |
| **Logging** | cyberark/bash-lib | Production-grade, retry logic |
| **Error Handling** | bpm-rocks/strict | Stack traces, strict mode |
| **Colors** | fidian/ansi | Visual feedback |

**Alternative (Minimal):**

- Start with **xwmx/bash-boilerplate** templates
- Add **labbots/bash-utility** for OS detection
- Use standalone functions for everything else

**Alternative (Simple):**

- Use **labbots/bash-utility** only
- Write custom logging/retry functions
- Avoid framework dependencies

### Key Takeaways

| Principle | Recommendation |
|-----------|----------------|
| **Modularity** | Source only needed functions |
| **Version Control** | Pin library versions (git submodule/SHA) |
| **Fallbacks** | Provide standalone alternatives |
| **Strict Mode** | ALWAYS use (set -euo pipefail) |
| **Testing** | Use assert.sh or bats-assert |
| **Validation** | Check dependencies before sourcing |
| **Documentation** | Document which libraries are required |

---

**Research Date:** 2025-01-18
**Researcher:** Claude (Sonnet 4.5)
