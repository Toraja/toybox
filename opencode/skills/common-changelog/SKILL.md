---
name: common-changelog
description: Use when writing, generating, updating, or reviewing a changelog or CHANGELOG.md, release notes, or entries for a new release, following the Common Changelog format.
---

# Common Changelog

## Overview

Write changelogs for humans following the [Common Changelog](https://common-changelog.org/) format, a stricter subset of Keep a Changelog. A changelog is a curated, ordered list of notable changes per versioned release. Optimize for consumers who need to quickly understand the impact of a release, not for machines or contributors.

## When to Use

Use when creating or updating `CHANGELOG.md`, drafting an entry for a new release, or rephrasing raw git history / pull requests into human-readable changelog content.

Do not use for a raw dump of `git log` or a list of pull requests. Do not use to document transient contributor-only details. If unsure whether a change matters, ask what a consumer of the released software needs to know.

## Guiding Principles

- Changelogs are for humans, not machines.
- Communicate the impact of changes, not the mechanics.
- Sort content by importance; breaking changes first.
- Skip content that isn't important to consumers.
- Link each change to further information (commit, PR, or ticket).

## Workflow

1. Determine the version (semver, no `v` prefix) and release date (`YYYY-MM-DD`, ISO 8601).
2. Generate a draft from git history / merged PRs between the previous tag and this release.
3. Remove noise: dotfiles, dev-only dependency bumps, minor style/formatting-only changes.
4. Rephrase each change into imperative mood, self-describing without its category heading.
5. Categorize into `Changed`, `Added`, `Removed`, `Fixed` (in that order); omit empty groups.
6. Merge related changes (fixups, repeated dependency bumps) into single entries.
7. Skip no-op changes that negate each other (e.g. a commit and its revert).
8. Add references (commit / PR / issue) and authors to each entry.
9. Prefix breaking changes with `**Breaking:**` and sort them first within a group.
10. Insert the new release at the top (latest-first by semver) and add reference-style links.

## Format Rules

- File is `CHANGELOG.md`, starting with `# Changelog`.
- Releases are sorted latest-first by semver, regardless of publish date.
- Each release heading: `## [VERSION] - DATE`, version linked to the GitHub release.
- After the heading: one or more change groups, optionally preceded by a single-sentence _notice_ (italic). Change groups are optional only when a notice explains their absence (e.g. first release).
- Categories, in order, each a `###` heading followed by only an unordered list:
  - `Changed` — changes in existing functionality (includes deprecations)
  - `Added` — new functionality
  - `Removed` — removed functionality (usually breaking)
  - `Fixed` — bug fixes
- No `Unreleased`, `Deprecated`, or `Security` sections. No `[YANKED]` tag (use a notice).
- Each entry: `- <change> (<references>) (<authors>)`, one line, imperative mood.
- References wrapped in parentheses, each a Markdown link; same type joined by commas: `(#1, #2)`. Use best single reference when more than two exist (prefer PR over ticket).
- Authors after references, in parentheses, comma-separated; omit for single-contributor projects. Optionally combine as `(#194, #195; Alice, Milly)`.
- Prefer reference-style links at the bottom to keep raw Markdown readable.
- Insert a `---` horizontal rule between the oldest (bottom) release and the reference-style link definitions. This is not a Common Changelog requirement; it stops [`parse-changelog`](https://github.com/taiki-e/parse-changelog) (used by cargo-dist) from absorbing the link footnote into that release's notes.

## Review Checklist

- Latest release is at the top; entries sorted by importance, breaking first
- Every change is imperative mood and self-describing without its heading
- Every change has at least a commit reference
- Breaking changes prefixed with `**Breaking:**`
- Noise (dotfiles, dev-deps, pure formatting) excluded
- Related changes merged; no-op changes omitted
- Categories limited to Changed / Added / Removed / Fixed, in order
- Date is `YYYY-MM-DD`; version has no `v` prefix
- Descriptions are one line; long explanations live in commits/references
- A `---` separates the oldest release from the reference-style link footnote

## Example

```markdown
# Changelog

## [2.0.0] - 2020-07-23

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md)._

### Changed

- **Breaking:** emit `close` event after `end` ([#210](https://github.com/owner/name/pull/210)) (Alice Meerkat)
- Bump `json-parser` from 2.x to 3.x (`53bd922`)

### Added

- Add `write()` method ([#194](https://github.com/owner/name/pull/194)) (Milly Moose)
- Document the `read()` method (`a11eb73`)

### Removed

- **Breaking:** drop support of Node.js 8 (`01e3a64`)

### Fixed

- Prevent buffer overflow ([#28](https://github.com/owner/name/issues/28)) (Alice Meerkat, Milly Moose)

## [1.0.0] - 2019-08-23

_First release._

---

[2.0.0]: https://github.com/owner/name/releases/tag/v2.0.0
[1.0.0]: https://github.com/owner/name/releases/tag/v1.0.0
```

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Copying `git log` or PR titles verbatim | Rephrase into imperative, consumer-focused changes. |
| Descriptive noun phrases (`Support of CentOS`) | Use imperative verbs (`Support CentOS`). |
| Relying on the heading for meaning | Make each entry self-describing. |
| Long multi-line entries | Keep to one line; put detail in the commit/reference. |
| Missing references | Reference at least the commit; prefer PR/ticket. |
| Breaking change buried mid-list | Prefix `**Breaking:**` and list it first. |
| Adding `Unreleased`/`Deprecated`/`Security` | Fold into the four allowed categories. |
| Full automation from commits | Curate by hand; the changelog is a feedback loop. |

## Sources

common-changelog.org: format, writing guidelines, antipatterns, FAQ.
