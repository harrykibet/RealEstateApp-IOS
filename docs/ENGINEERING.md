
---

# ⚙️ 3. `docs/ENGINEERING.md`

```markdown
# Engineering Guidelines

This document defines coding standards, testing strategy, and operational practices.

---

## Code Standards

### General

- Prefer immutability
- Avoid side effects
- Keep functions pure where possible
- Explicit over implicit

---

### Naming

- Clear, intention-revealing names
- Avoid abbreviations
- Consistent suffixes:
  - `UseCase`
  - `Repository`
  - `ViewModel`

---

### File Structure

- One responsibility per file
- Group by feature, not by type

---

## Dependency Injection

- Constructor injection only
- No service locators
- No global state

Example:

```swift
init(repository: PropertyRepository)