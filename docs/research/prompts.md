# Research: Terminal Prompt Tools

**SELECTED: Starship**

**Why**: Cross-platform (bash + zsh), single TOML config, fast (Rust), no framework dependency

---

## Decision

| Selected | Reason |
|----------|--------|
| Starship | Works on both macOS zsh and Ubuntu bash |

**Rejected**: Oh My Zsh (zsh only), Oh My Bash (bash only), Powerlevel10k (zsh only)

---

## Question

Which terminal prompt tool for unified macOS (zsh) and Ubuntu (bash) experience?

---

## Requirements

| Requirement | Priority | Notes |
|-------------|----------|-------|
| Cross-platform (bash + zsh) | REQUIRED | Same tool both systems |
| Stability | REQUIRED | Low maintenance, no headaches |
| Reputation | REQUIRED | Proven, reliable |
| Consistency | REQUIRED | Same config everywhere |
| Performance | HIGH | Fast startup times |
| Familiar features | MEDIUM | Similar to oh-my-zsh experience |

---

## Tools Comparison

| Tool | Stars | Shell Support | Performance | Maintenance |
|------|-------|---------------|-------------|-------------|
| oh-my-zsh | 183,000 | Zsh only | Slow (1-5s) | High |
| oh-my-bash | 7,000 | Bash only | Moderate | Moderate |
| bash-it | 14,800 | Bash only | Moderate | Moderate |
| starship | 52,300 | All shells | Fast (<100ms) | Low |

---

## oh-my-zsh

### Overview

**Type**: Zsh framework
**Repository**: https://github.com/ohmyzsh/ohmyzsh
**Community**: 183,000 stars, 2,400+ contributors

### Capabilities

| Feature | Support |
|---------|---------|
| Zsh | ✅ Yes |
| Bash | ❌ No |
| Plugins | ✅ Extensive |
| Themes | ✅ 150+ |
| Performance | ❌ Slow |

### Performance Issues

| Issue | Impact | Mitigation |
|-------|--------|------------|
| Startup time | 1-5s typical | Disable auto-update |
| NVM plugin | +1.5s | Lazy loading |
| Git status | +0.5s | Hide dirty state |
| Auto-update checks | 95% load time | Manual updates |

### Pros

| Advantage | Impact |
|-----------|--------|
| Industry standard | Massive ecosystem |
| Mature | Very stable |
| Feature-rich | Extensive plugins |
| Current use | Already familiar |

### Cons

| Disadvantage | Impact |
|--------------|--------|
| Zsh only | Cannot use on Ubuntu bash |
| Slow startup | 1-5s typical |
| Complex config | Plugin management burden |
| Platform-specific | Separate config needed |

---

## oh-my-bash

### Overview

**Type**: Bash framework (oh-my-zsh inspired)
**Repository**: https://github.com/ohmybash/oh-my-bash
**Community**: 7,000 stars

### Capabilities

| Feature | Support |
|---------|---------|
| Bash | ✅ Yes |
| Zsh | ❌ No |
| Plugins | ✅ Yes |
| Themes | ✅ 100+ |

### Pros

| Advantage |
|-----------|
| oh-my-zsh-like for bash |
| Active development |
| Theme variety |

### Cons

| Disadvantage |
|--------------|
| Bash only |
| Smaller community |
| Less mature |
| No performance data |

---

## bash-it

### Overview

**Type**: Bash framework
**Repository**: https://github.com/Bash-it/bash-it
**Community**: 14,800 stars, 406 contributors

### Capabilities

| Feature | Support |
|---------|---------|
| Bash | ✅ Yes (3.2+) |
| Zsh | ❌ No |
| Plugins | ✅ Yes |
| Themes | ✅ Yes |
| Diagnostics | ✅ Built-in ("bash-it doctor") |

### Pros

| Advantage |
|-----------|
| Most popular bash framework |
| Recent releases (v3.2.0, Oct 2025) |
| CI/CD tested |
| Diagnostic tools |

### Cons

| Disadvantage |
|--------------|
| Bash only |
| Cannot use on macOS zsh |
| Smaller than oh-my-zsh |

---

## Starship

### Overview

**Type**: Universal prompt (not framework)
**Repository**: https://github.com/starship/starship
**Community**: 52,300 stars, 637 contributors
**Language**: Rust
**Latest**: v1.24.1 (Nov 2025)

### Capabilities

| Feature | Support |
|---------|---------|
| Bash | ✅ Yes |
| Zsh | ✅ Yes |
| Fish | ✅ Yes |
| PowerShell | ✅ Yes |
| Cross-shell | ✅ Identical config |
| Performance | ✅ <100ms |
| Config file | Single TOML file |

### Performance Benchmarks

| Metric | Value |
|--------|-------|
| Startup time | <100ms |
| oh-my-zsh comparison | 10-50x faster |
| Resource usage | Minimal |
| External binary | No shell overhead |

### Configuration

**Location**: `~/.config/starship.toml`

**Complexity**: Low to Moderate

| Level | Effort | Config |
|-------|--------|--------|
| Beginner | 0 minutes | Use defaults |
| Intermediate | 5 minutes | Copy preset |
| Advanced | 30 minutes | Custom TOML |

**Installation**:
```bash
# macOS
brew install starship
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Ubuntu
apt install starship
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Optional: Customize
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

### Pros

| Advantage | Impact |
|-----------|--------|
| Cross-shell | Same tool everywhere |
| Single config | Write once, use everywhere |
| Performance | 10-50x faster than oh-my-zsh |
| Active development | Recent releases |
| Large community | 52k stars, proven |
| Low maintenance | No plugin management |
| Modern | Rust-based, fast |

### Cons

| Disadvantage | Impact |
|--------------|--------|
| Not a framework | Prompt only (no plugins) |
| Different paradigm | Learning curve |
| TOML syntax | Less familiar than shell |
| Occasional bugs | Minor, cosmetic issues |

### Known Issues (2024-2025)

| Issue | Severity | Status |
|-------|----------|--------|
| ZSH autocomplete interference | Low | Fixed in patches |
| Extra blank lines (zsh) | Cosmetic | Fixed in v1.23+ |
| PowerShell cache issues | Low | Fixed Oct 2024 |
| First prompt delay | Rare | Edge case |

**Assessment**: Issues are minor, cosmetic, quickly resolved

### Reputation

| Source | Sentiment |
|--------|-----------|
| Community | Highly positive |
| Production usage | Widely adopted |
| Hacker News (2024) | "So fast I don't notice execution time" |
| Migration trend | Users moving from Powerlevel10k |
| Stability | Generally stable |

### Risk Assessment

| Factor | Rating | Notes |
|--------|--------|-------|
| Stability | 8/10 | Mature, occasional minor bugs |
| Performance | 10/10 | Rust-based, <100ms |
| Maintenance | 9/10 | Active development |
| Community | 9/10 | Large, active |
| Breaking changes | 7/10 | Occasional minor issues |
| **Overall Risk** | **Low** | Safe choice |

---

## Decision Matrix

### Cross-Platform Requirement

| Tool | macOS (zsh) | Ubuntu (bash) | Winner |
|------|-------------|---------------|--------|
| oh-my-zsh | ✅ | ❌ | ❌ |
| oh-my-bash | ❌ | ✅ | ❌ |
| bash-it | ❌ | ✅ | ❌ |
| starship | ✅ | ✅ | ✅ |

**Conclusion**: Only Starship meets cross-platform requirement

### Performance Comparison

| Tool | Startup Time | Resource Usage | Winner |
|------|--------------|----------------|--------|
| oh-my-zsh | 1-5s | High | ❌ |
| oh-my-bash | Unknown | Moderate | ⚠️  |
| bash-it | Unknown | Moderate | ⚠️  |
| starship | <100ms | Low | ✅ |

### Maintenance Burden

| Tool | Config Complexity | Plugin Management | Updates | Winner |
|------|------------------|-------------------|---------|--------|
| oh-my-zsh | High | Yes | Manual | ❌ |
| oh-my-bash | Moderate | Yes | Manual | ⚠️  |
| bash-it | Moderate | Yes | Manual | ⚠️  |
| starship | Low | No | Auto | ✅ |

---

## Decision

**REQUIRED**: Starship

### Rationale

| Reason | Weight | Notes |
|--------|--------|-------|
| Cross-platform | CRITICAL | Only tool supporting bash + zsh |
| Single config | HIGH | Same config everywhere |
| Performance | HIGH | 10-50x faster than oh-my-zsh |
| Stability | HIGH | Mature, active (52k stars) |
| Low maintenance | HIGH | No plugins, auto-updates |
| Reputation | HIGH | Proven, widely adopted |

### Trade-offs Accepted

| Trade-off | Mitigation |
|-----------|------------|
| Not a framework | Sufficient for prompt needs |
| TOML syntax | Simple, well-documented |
| Different paradigm | Minimal learning curve |
| Occasional bugs | Minor, quickly resolved |

---

## Alternative Considered

**Keep oh-my-zsh (macOS) + bash-it (Ubuntu)**

### Pros

| Advantage |
|-----------|
| Framework features |
| Separate optimizations |
| oh-my-zsh familiarity |

### Cons

| Disadvantage |
|--------------|
| Two configs to maintain |
| No consistency |
| Slow performance (oh-my-zsh) |
| Higher maintenance |

**Verdict**: Not recommended (violates simplicity principle)

---

## Implementation

### Installation

**macOS**:
```bash
brew install starship
```

**Ubuntu**:
```bash
apt install starship
```

### Configuration

**~/.zshrc** (macOS):
```bash
# Starship prompt
eval "$(starship init zsh)"
```

**~/.bashrc** (Ubuntu):
```bash
# Starship prompt
eval "$(starship init bash)"
```

**~/.config/starship.toml** (both):
```toml
# Shared configuration
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true
```

### Stow Package Location

| File | Location | Notes |
|------|----------|-------|
| starship.toml | `stow-common/.config/starship.toml` | Shared config |
| zsh init | `stow-macos/.zshrc` | Platform-specific |
| bash init | `stow-ubuntu/.bashrc` | Platform-specific |

---

## Migration Path

### From oh-my-zsh to Starship

**Step 1**: Install Starship
```bash
brew install starship
```

**Step 2**: Add to .zshrc
```bash
# Replace oh-my-zsh theme line with:
eval "$(starship init zsh)"
```

**Step 3**: Optional customization
```bash
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

**Step 4**: Test
```bash
source ~/.zshrc
```

**Rollback** (if needed):
```bash
# Remove starship line from .zshrc
# Restore oh-my-zsh theme
```

---

## Related

- [index.md](index.md) - Research index
- [libraries.md](libraries.md) - Bash libraries analysis
- [shells.md](shells.md) - Shell configuration strategy

---

**Conclusion**: Starship REQUIRED for unified cross-platform prompt (low risk, high value)
