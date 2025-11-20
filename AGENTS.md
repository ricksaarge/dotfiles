# AI Agents

**AI-generated documentation for AI-driven development**

---

## Purpose

REQUIRED: All documentation MUST follow [AISD](https://github.com/ricksaarge/aisd)

**Primary Author**: AI agents (Claude Code, GitHub Copilot, etc.)
**Primary Reader**: AI agents (code generation, task execution)
**Secondary Reader**: Humans (diff review, approval)

---

## Agent Types

| Agent | Purpose | Access |
|-------|---------|--------|
| Claude Code | Primary development agent | Full filesystem, git, tools |
| GitHub Copilot | Inline code suggestions | Current file context |
| Custom agents | Specialized tasks | Per-task scope |

---

## Documentation Requirements

### Format

**MUST** follow AISD (AI-Structured Documentation):

| Principle | Rule |
|-----------|------|
| Conciseness | REQUIRED - no prose paragraphs |
| Language | MUST use MUST/REQUIRED/FORBIDDEN |
| Precision | REQUIRED - exact types, ranges, formats |
| Structure | REQUIRED - tables > lists > code blocks |
| Rationale | FORBIDDEN - document WHAT, not WHY |

### File Organization

| Type | Max Lines | Purpose |
|------|-----------|---------|
| Index | 100 | Navigation |
| Spec | 500 | Single responsibility |

**Split files** when exceeding 500 lines.

---

## Agent Workflow

### 1. Read Documentation

```bash
# Agent MUST read AISD spec first
# https://github.com/ricksaarge/aisd

# Then read relevant specs
cat doc/*/index.md
```

### 2. Generate Code

**MUST** match specifications exactly.

**FORBIDDEN**: Deviation from specs without human approval.

### 3. Update Documentation

**REQUIRED** when adding features:

| Change | Action |
|--------|--------|
| New feature | Update spec BEFORE coding |
| Behavior change | Update spec BEFORE coding |
| Bug fix | Update spec if behavior changes |

---

## Commit Messages

All commit messages MUST be **English**, **single line**, and follow:

`<type>[<area>]: <short-message>`

### Commit Format

| Element | Constraint |
|---------|------------|
| type | `spec`, `docs`, `chore`, `refactor`, `test`, `feat`, `fix` |
| area | `stow`, `zsh`, `git`, `vim`, `brew`, `ssh`, `meta` |
| short-message | Max 20 words, imperative, lowercase, space-separated, no period |

### Type Values

| Type | Purpose |
|------|---------|
| `spec` | Changes to AISD spec / formats |
| `docs` | Guides, examples, explanations |
| `chore` | Repo hygiene, tooling, config |
| `refactor` | Structural changes without behavior change |
| `test` | Test cases, validation docs, fixtures |
| `feat` | New feature or capability |
| `fix` | Bug fix or correction |

### Area Values

| Area | Purpose |
|------|---------|
| `stow` | GNU Stow configuration and management |
| `zsh` | Zsh shell configuration |
| `git` | Git configuration and aliases |
| `vim` | Vim/Neovim configuration |
| `brew` | Homebrew packages and setup |
| `ssh` | SSH configuration |
| `meta` | README, AGENTS.md, project meta |

### Examples

- `feat[zsh]: add git status aliases`
- `docs[meta]: add install instructions`
- `chore[stow]: reorganize package structure`
- `fix[git]: correct merge tool config`
- `refactor[vim]: normalize plugin format`

---

## Style Guide Compliance

### Language Rules

❌ **FORBIDDEN**:
- should, might, could
- typically, usually, often
- reasonable, appropriate, sensible

✅ **REQUIRED**:
- MUST, REQUIRED, SHALL
- MUST NOT, FORBIDDEN, SHALL NOT
- MAY, OPTIONAL

### Structure Rules

❌ **BAD**:
```markdown
The system validates email addresses to ensure users enter valid data.
Email addresses should be formatted properly with an @ symbol and domain.
```

✅ **GOOD**:
```markdown
| Field | Constraint |
|-------|------------|
| Email | MUST match `^[^@]+@[^@]+\.[^@]+$` |
```

---

## Validation

### Pre-commit Checks

**REQUIRED** before committing AI-generated docs:

```bash
# Check forbidden words
grep -rn "should\|might\|could\|typically\|usually" doc/ --include="*.md"

# Check file length
wc -l doc/**/*.md | awk '$1 > 500 {print $2 ": " $1 " lines"}'

# Check line length (avg max 40 chars)
for file in doc/**/*.md; do
  non_empty=$(grep -c '[^[:space:]]' "$file")
  chars=$(wc -c < "$file")
  avg=$(( chars / non_empty ))
  [ $avg -gt 40 ] && echo "$file: $avg chars/line"
done
```

### Manual Review

Human MUST verify:

- [ ] No forbidden words
- [ ] Only MUST/REQUIRED/FORBIDDEN
- [ ] Explicit types and constraints
- [ ] Tables/lists (not prose)
- [ ] Under 500 lines per file
- [ ] Valid cross-references

---

## Agent Behavior

### Code Generation

**MUST**:
- Read all relevant specs
- Follow exact constraints
- Use specified types
- Implement all REQUIRED features

**MUST NOT**:
- Guess at unspecified behavior
- Add features not in specs
- Deviate from constraints
- Ignore FORBIDDEN rules

### Documentation Generation

**MUST**:
- Use tables for structured data
- Specify exact types (UUID, String, Integer)
- Specify exact ranges (1-200, not "short")
- Use authoritative language

**MUST NOT**:
- Write prose paragraphs
- Use vague terms
- Include rationale or "why"
- Use ambiguous language

---

## File Structure

### Documentation Layout

```
doc/
├── research/
│   └── index.md           # Research findings
├── architecture/
│   └── index.md           # System design
└── */
    ├── index.md           # Domain overview (<100 lines)
    └── *.md               # Domain specs (<500 lines)
```

### Size Guidelines

| Location | Max Lines |
|----------|-----------|
| doc/*/index.md | 100 |
| doc/*/*.md | 500 |
| Split when exceeding | Always |

---

## Examples

### ✅ Good Agent Documentation

```markdown
## Installation

| Step | Command |
|------|---------|
| 1 | `./install.sh` |
| 2 | Verify with `./verify.sh` |

**Exit codes**:

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Missing dependencies |
| 2 | Permission denied |
```

### ❌ Bad Agent Documentation

```markdown
## Installation

To install the system, you should run the install script.
This will typically install all dependencies and set up your environment.
If something goes wrong, the script might return an error code.
```

---

## Related

- [AISD Spec](https://github.com/ricksaarge/aisd) - AI-Structured Documentation format
- [doc/research/index.md](doc/research/index.md) - Research findings

---

**Note**: Symlink `CLAUDE.md` → `AGENTS.md` for Claude Code compatibility.
