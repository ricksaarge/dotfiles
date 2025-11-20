# TODO

**Dotfiles implementation tasks**

Follows [todo-md](https://github.com/ricksaarge/todo-md) specification.

---

## CURRENT: Testing & Documentation

### Testing +testing

- [ ] (A) Test on Ubuntu ~1h
  - [ ] Fresh VM/container
  - [ ] Run `./task install`
  - [ ] Verify all symlinks
  - [ ] Verify all packages
  - [ ] Test idempotency (re-run)

- [ ] (B) Additional error handling tests
  - [ ] Invalid .env values
  - [ ] Network failures

---

### Documentation +docs

- [ ] (C) Update README.md ~20m
  - [ ] Installation instructions
  - [ ] Usage examples
  - [ ] Requirements
  - [ ] Troubleshooting

- [ ] (C) Add CONTRIBUTING.md ~15m
  - [ ] Link to style guide (style.ysap.sh)
  - [ ] Testing instructions
  - [ ] Documentation standards (AISD)

---

## FUTURE +future

- [ ] Add backup task ~2h
  - [ ] Backup existing dotfiles before install
  - [ ] Store in timestamped directory

- [ ] Add restore task ~1h
  - [ ] Restore from backup

- [ ] Add uninstall task ~1h
  - [ ] Unstow all packages
  - [ ] Remove generated files

- [ ] Add verify task ~30m
  - [ ] Check all symlinks valid
  - [ ] Check all commands exist
  - [ ] Report status

---

## COMPLETED +done

### Research & Planning
- [x] Research bash utility libraries (selected: labbots/bash-utility)
- [x] Research bash style guides (selected: style.ysap.sh)
- [x] Research taskfile pattern (bash script, hyphen-separated functions)
- [x] Research logging approaches (inline helpers)
- [x] Create AISD documentation structure
- [x] Define technology stack
- [x] Define directory structure
- [x] Create specification files

### Implementation
- [x] Clone labbots/bash-utility to vendor/
- [x] Create task orchestrator file with all functions
- [x] Create .env.example with all required variables
- [x] Create Brewfile (19 packages)
- [x] Create apt.txt (16 packages)
- [x] Create stow-common/ structure (.gitconfig.template, .vimrc, starship.toml)
- [x] Create stow-macos/ structure (.zshrc, .zprofile)
- [x] Create stow-ubuntu/ structure (.bashrc, .bash_profile)
- [x] Create macos-defaults.sh script

### Bug Fixes
- [x] Fix configure-git() variable names (GIT_NAME → GIT_USER_NAME)
- [x] Fix configure-git() envsubst export issue (added set -a)
- [x] Fix help() to show only dotfiles commands (not bash-utility functions)

### Testing
- [x] Test all individual functions on macOS
- [x] Test full `./task install` workflow
- [x] Test idempotency (re-run install)
- [x] Test error handling (missing .env)
