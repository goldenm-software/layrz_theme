---
name: conventional-commits
description: Create semantic commit messages following Conventional Commits specification with proper formatting and changelog impact
---

## Overview

Conventional Commits provides a specification for adding human and machine readable meaning to commit messages. This skill helps create commits with proper formatting, types, scopes, and breaking change declarations.

| Element | Purpose | Impact |
|---|---|---|
| Type | Classifies the change (feat, fix, docs, etc.) | Determines changelog category |
| Scope | Optional context (component, module name) | Narrows change scope in changelog |
| Description | Concise change summary in imperative mood | Primary changelog entry |
| Body | Detailed explanation (optional) | PR review and code history |
| Breaking Change | Signals incompatible API/behavior changes | Major version bump required |
| Co-authors | Attribution for human/AI collaborators | Credit in commit history |

**When to use:** Every commit. The specification ensures semantic versioning, automatic changelog generation, and clear git history.

---

## Format Specification

### Basic Format

```
<type>: <description>

[optional body]
[extra <type>: <description>]

[BREAKING CHANGE: <description>]

[optional co-author(s)]
```

### Subject Line Rules

- **Type MUST be lowercase**: `feat`, `fix`, `docs`, `perf`, `test`, `refactor`, `sec`, `lab`, `exp`, `deps`, `revert`, `chore`, `style`
- **Colon and space MUST follow type**: `: ` (required separator)
- **Description MUST be present**: Concise, actionable, and in imperative mood
- **Description MUST NOT end with period**: "Add OAuth support" NOT "Add OAuth support."
- **Scope is optional**: `feat(auth): Add OAuth2 support` — narrows context in changelog
- **Keep under 72 characters**: Optimal for git log display

---

## Required Types

| Type | Changelog | Purpose | Example |
|---|---|---|---|
| `feat` | ✅ Features | New feature addition | `feat: Add passkey authentication` |
| `fix` | ✅ Bug Fixes | Bug fix | `fix: Resolve MFA validation timing issue` |
| `docs` | ✅ Documentation | Documentation changes | `docs: Update OAuth2 setup instructions` |
| `perf` | ✅ Performance | Performance improvement | `perf: Optimize GraphQL query caching` |
| `test` | ❌ Hidden | Adding/updating tests | `test: Add login flow integration tests` |
| `refactor` | ❌ Hidden | Code refactoring (no functional change) | `refactor: Simplify auth middleware` |
| `sec` | ✅ Security | Security patch/CVE fix | `sec: Patch CVE-2026-12345 in jwt` |
| `lab` | ✅ Labs | Labs/exploratory work | `lab: Prototype Redis caching layer` |
| `exp` | ✅ Experimental | Experimental features | `exp: Test WebAuthn alternative flow` |
| `deps` | ✅ Dependencies | Dependency updates | `deps: Bump axios from 1.6.0 to 1.7.2` |
| `revert` | ✅ Reverts | Revert previous commit | `revert: Revert OAuth2 flow changes` |
| `chore` | ❌ Hidden | Maintenance tasks | `chore: Update build config` |
| `style` | ❌ Hidden | Code style changes | `style: Format TypeScript files` |

---

## Single-Type Commits

### Simple Feature

```
feat: Add OAuth2 authentication support
```

### Bug Fix with Scope

```
fix(tabs): Resolve arrow button state not updating during navigation
```

### Security Fix

```
sec: Upgrade jwt library to patch CVE-2026-12345
```

### Documentation

```
docs: Add OAuth2 setup guide for web platform
```

### Performance Improvement

```
perf: Optimize GraphQL query caching layer
```

---

## Multi-Type Commits

A single commit can declare **multiple changes** in the body. The subject line is the primary type, and additional `<type>: <description>` lines in the body are each categorized independently in the changelog.

### Example: Feature with Security, Docs, and Fixes

```
feat: Add OAuth2 authentication

sec: Upgrade jwt library to fix CVE-2026-12345
docs: Add OAuth2 setup instructions
fix: Resolve token refresh race condition

Co-authored-by: Kenny Mochizuki <PHKenny@users.noreply.github.com>
Co-authored-by: AI Assistant <no-reply@ai.com>
```

**Result:** 4 separate changelog entries:
1. ✅ Features: "Add OAuth2 authentication"
2. ✅ Security: "Upgrade jwt library to fix CVE-2026-12345"
3. ✅ Documentation: "Add OAuth2 setup instructions"
4. ✅ Bug Fixes: "Resolve token refresh race condition"

### Example: Widget Enhancement with Tests and Docs

```
feat: Enhance ThemedTabView with wrap navigation

test: Add 4 comprehensive widget tests for arrow navigation
docs: Update ThemedTabView skill documentation

BREAKING CHANGE: initialPosition now clamped instead of rejected for invalid indices
```

**Result:** 3 visible entries + 1 breaking change notice:
1. ✅ Features: "Enhance ThemedTabView with wrap navigation"
2. ✅ Tests (hidden): "Add 4 comprehensive widget tests for arrow navigation"
3. ✅ Documentation: "Update ThemedTabView skill documentation"
4. ⚠️ BREAKING CHANGE announced

---

## Breaking Changes

### Declaration Methods

#### Method 1: As Subject Line

```
BREAKING CHANGE: Replace session-based auth with JWT
```

#### Method 2: As Footer

```
feat: Replace session-based auth with JWT

All endpoints now require Bearer token authentication instead of session cookies.

BREAKING CHANGE: Session-based authentication removed
```

#### Method 3: With Scope (Recommended)

```
feat(auth)!: Replace session-based auth with JWT

Migration path:
- Clients must obtain Bearer token via /auth/token endpoint
- Old session cookies no longer accepted
- Legacy endpoints deprecated (see docs)

BREAKING CHANGE: All endpoints now require Bearer token authentication

Co-authored-by: Security Team <security@example.com>
```

The `!` before the colon signals a breaking change at a glance.

---

## Scope Guidelines

Optional scope clarifies **which component/module/system** the change affects.

```
feat(auth): Add passkey support           ← Scope: auth module
feat(tabs): Add wrap navigation           ← Scope: tabs widget
fix(api): Resolve timeout on bulk upload  ← Scope: api layer
perf(cache): Optimize query results       ← Scope: cache system
docs(setup): Update installation steps    ← Scope: setup instructions
```

**Common scopes:**
- Component names: `(tabs)`, `(table)`, `(input)`, `(avatar)`
- Feature areas: `(auth)`, `(api)`, `(ui)`, `(db)`
- Layers: `(frontend)`, `(backend)`, `(schema)`
- Systems: `(cache)`, `(logging)`, `(monitoring)`

---

## Co-Authors

Attribute multiple contributors (humans or AIs) to a single commit.

```
feat: Add OAuth2 authentication

sec: Upgrade jwt library to fix CVE-2026-12345
docs: Add OAuth2 setup instructions
fix: Resolve token refresh race condition

Co-authored-by: Kenny Mochizuki <PHKenny@users.noreply.github.com>
Co-authored-by: AI Assistant <no-reply@ai.com>
```

**Format rules:**
- One `Co-authored-by:` per line
- Include name and email in angle brackets
- Placed at end of commit message
- Email must be valid format (can be noreply)

**AI Attribution Examples:**
```
Co-authored-by: Claude AI <no-reply@anthropic.com>
Co-authored-by: GitHub Copilot <copilot@github.com>
Co-authored-by: Claude Haiku <no-reply@anthropic.com>
```

---

## Real-World Examples

### Example 1: ThemedTabView Enhancement (Multi-type)

```
feat(tabs): Add wrapArrowNavigation for circular tab navigation

test: Add 4 comprehensive widget tests for arrow navigation
  - Arrow button state updates reactively during navigation (regression)
  - wrapArrowNavigation wraps from last tab to first tab
  - wrapArrowNavigation wraps from first tab to last tab
  - wrapArrowNavigation keeps arrows enabled at boundaries

fix(tabs): Resolve arrow button state not updating on tab change

docs: Update ThemedTabView skill documentation

All 358 tests passing, flutter analyze clean.

Co-authored-by: Claude AI <no-reply@anthropic.com>
```

**Changelog result:**
- ✅ Features: "Add wrapArrowNavigation for circular tab navigation"
- ✅ Bug Fixes: "Resolve arrow button state not updating on tab change"
- ✅ Documentation: "Update ThemedTabView skill documentation"
- ❌ Hidden: Test coverage details

### Example 2: Security Patch

```
sec: Patch CVE-2026-12345 in jwt dependency

Upgraded jwt library from 8.2.0 to 8.2.1.

Vulnerability: Timing attack on signature verification
Impact: Low - affects only applications validating tokens with high frequency
Mitigation: Update immediately for defense-in-depth

Co-authored-by: Security Team <security@example.com>
```

### Example 3: Simple Bug Fix

```
fix(auth): Resolve session timeout not refreshing token
```

### Example 4: Breaking Change

```
feat(auth)!: Replace session-based auth with JWT

Session cookies are no longer accepted. All clients must:
1. Call POST /auth/token to obtain Bearer token
2. Include token in Authorization header: "Bearer <token>"
3. Handle 401 responses with token refresh logic

Deprecation timeline:
- v8.0: Bearer token required (breaking)
- v7.5: Both session and Bearer supported (this release)
- v7.4 and earlier: Session-only (legacy)

BREAKING CHANGE: Session-based authentication removed in favor of JWT

Co-authored-by: API Team <api@example.com>
```

---

## Commit Message Structure

### Minimal Commit

```
type: description
```

### Full Commit with Details

```
type(scope): description

Detailed explanation of what was changed and why. This is where you explain
the motivation for the change and any relevant context.

BREAKING CHANGE: description of the breaking change
Co-authored-by: Name <email@example.com>
```

### Multi-Type Commit

```
type(scope): primary description

secondary_type: secondary description
tertiary_type: tertiary description

Additional context or motivation here.

BREAKING CHANGE: optional breaking change notice
Co-authored-by: Name <email@example.com>
```

---

## Validation Checklist

Before creating a commit, verify:

- ✅ Type is lowercase (`feat`, `fix`, `docs`, etc.)
- ✅ Type followed by colon and space (`: `)
- ✅ Description is in imperative mood ("Add", "Fix", "Update" NOT "Added", "Fixed")
- ✅ Description does NOT end with period
- ✅ Subject line under 72 characters
- ✅ Scope in parentheses if used: `feat(component): description`
- ✅ Body explains "why" not just "what"
- ✅ Breaking changes declared with `BREAKING CHANGE:` footer
- ✅ Co-authors formatted as `Co-authored-by: Name <email@example.com>`
- ✅ No extra blank lines between header and body
- ✅ One blank line before BREAKING CHANGE or Co-authored-by

---

## Common Mistakes to Avoid

❌ **Wrong:** `feat: Adds OAuth support` (past tense, ends with period)
✅ **Correct:** `feat: Add OAuth support`

❌ **Wrong:** `FIX: resolve token issue` (type not lowercase)
✅ **Correct:** `fix: Resolve token issue`

❌ **Wrong:** `feat(tabs) Add navigation` (missing colon)
✅ **Correct:** `feat(tabs): Add navigation`

❌ **Wrong:** Mixing descriptions without types in body
✅ **Correct:** Each line in body starts with `type: description`

❌ **Wrong:** `Co-authored by: Name` (incorrect keyword)
✅ **Correct:** `Co-authored-by: Name <email@example.com>`

---

## Benefits

1. **Semantic Versioning:** Commit types drive major/minor/patch version bumps
2. **Automated Changelog:** Tools parse commits and generate organized changelogs by type
3. **Searchable History:** `git log --grep="^feat"` finds all features
4. **Code Review:** Clear intent in subject line speeds review
5. **Release Notes:** Types automatically categorize changes for users
6. **Team Alignment:** Consistent format across all contributors

---

## Reference

- Full Specification: https://www.conventionalcommits.org
- Changelog Generation: commitizen/cz-cli automates commits and changelog
- Type Definitions: See "Required Types" table above
- Scope Best Practices: Keep scopes consistent with your codebase structure
