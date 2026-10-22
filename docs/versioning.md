# 🔢 Versioning of the ATC Coding Rules

> 📣 **Status: proposal for discussion** — see issue [#56](https://github.com/atc-net/atc-coding-rules/issues/56).
> Nothing in this document is active yet. It describes *what* we would version, *how* we would map changes to
> [SemVer](https://semver.org), and *in which order* it can be rolled out without breaking the
> [atc-coding-rules-updater](https://github.com/atc-net/atc-coding-rules-updater).

## 📚 Table of Contents

- [🎯 Why version the rules?](#-why-version-the-rules)
- [📍 Where we are today](#-where-we-are-today)
- [📦 The unit of release](#-the-unit-of-release)
- [🔀 Impact levels mapped to SemVer](#-impact-levels-mapped-to-semver)
- [🏷️ Release process](#️-release-process)
- [🔄 Rollout plan — and what it means for the updater](#-rollout-plan--and-what-it-means-for-the-updater)
- [✅ Maintainer checklist](#-maintainer-checklist)
- [❓ Open questions](#-open-questions)

## 🎯 Why version the rules?

A consumer that syncs the rules today has no way to answer the only question that matters before pressing the button:
**how much work am I signing up for?** 😅

A version number — plus release notes — should convey exactly that:

- 🟢 *Patch*: nothing will break, sync whenever.
- 🟡 *Minor*: your build stays green; you may want to clean up now-redundant entries in your **Custom** section.
- 🔴 *Major*: expect new errors, new custom overrides, or a migration step — plan it.

## 📍 Where we are today

| Fact | Consequence |
|------|-------------|
| The updater downloads raw files from a hard-coded `main` ref: `https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/…` | Every run always gets the newest state of `main`. There is no way to pin, and no way to tell what you got. |
| This repository has **no tags, no releases and no CHANGELOG** | Consumers can only `git log` the repo to figure out what changed. |
| Each distribution `.editorconfig` carries a `# Version: x.y.z` / `# Updated: dd-MM-yyyy` header | Maintained by hand, per file, and has drifted (`1.0.0`, `1.0.2`, `1.0.9`, `1.5.0` … all at the same time). The updater **does not parse it** — it is copied verbatim as part of the central section. |
| `Directory.Build.props` is **create-only** for the updater (existing files are never overwritten — differences are reported as drift), and `global.json` is never downloaded | Analyzer package bumps reach consumers only through the drift report or `--useLatestMinorNugetVersion`, which softens their real-world impact. |
| The updater itself is released with [release-please](https://github.com/googleapis/release-please) + conventional commits and published as a NuGet global tool | We already have a release toolchain in the family — reusing it keeps the mental model identical across the two repos. |

## 📦 The unit of release

**One version for the whole repository** — a single `vMAJOR.MINOR.PATCH` git tag covering the entire `distribution/` folder.

Why not one version per distribution target (`dotnet10`, `dotnet11`, `project-frameworks/aspire`, …)?

- 🧷 A git tag pins a *tree*, not a folder. The updater fetches `.editorconfig` and `Directory.Build.props` from the root
  target folder, from `src`/`test`/`sample`, **and** from one or more `project-frameworks/*` folders in a single run.
  Only a repository-wide tag can guarantee that those files are a consistent set.
- 🧮 Per-folder versions mean N changelogs, N tag namespaces and ambiguous "which one do I pin?" conversations.

The trade-off: a `dotnet5`-only change bumps the number that `dotnet11` consumers also see. We compensate by
**scoping every changelog entry to the affected distribution(s)**, so a consumer can see at a glance that a 🔴 major
release does not touch them. The bump itself always reflects the **highest impact across all targets** in the release.

The first tag is `v1.0.0`, cut from the current state of `main`. The per-file `# Version:` headers are legacy and
unrelated to it — see [Phase 2](#phase-2--make-the-version-visible-in-the-files-rules-repo).

## 🔀 Impact levels mapped to SemVer

The six impact levels from issue [#56](https://github.com/atc-net/atc-coding-rules/issues/56), plus the ones that
surfaced while writing this down:

| # | Change | Bump | Rationale |
|---|--------|------|-----------|
| 1 | Comments, documentation, formatting, re-ordering — **no** change to any rule or severity | 🟢 **PATCH** | A sync is a no-op for the build. |
| 2 | Rules made **more lenient** (severity lowered, rule disabled) | 🟡 **MINOR** | A green build stays green. The only follow-up is optional: remove now-redundant entries from your Custom section. |
| 3 | Rules made **stricter** (severity raised, previously disabled rule re-enabled) | 🔴 **MAJOR** | Everything is `treated as an error` in `Release`, so this can break a consumer's build — the textbook definition of a breaking change. |
| 4 | **Analyzer dependency updates** in `Directory.Build.props` | 🔴 **MAJOR** for an analyzer major/minor bump (new diagnostics are to be expected), 🟢 **PATCH** for an analyzer patch bump that only fixes existing diagnostics. If the release notes of the analyzer prove no new diagnostics ship, 🟡 **MINOR** is enough. | We cannot always know what a vendor added, so we default to the conservative option. Note that the updater never overwrites an existing `Directory.Build.props`, so this only bites on a new project or when the drift report is acted upon. |
| 5a | **New analyzer package** added to an existing distribution | 🔴 **MAJOR** | A whole new family of diagnostics — the heaviest kind of change for a consumer. |
| 5b | **New distribution target or project-framework folder** added (e.g. `dotnet12`, a new `project-frameworks/*`) | 🟡 **MINOR** | Purely additive — existing consumers are not affected until they opt in via `--projectTarget` / a matching `.csproj`. |
| 6 | **Breaking structural changes** — folder layout, file names/casing, removal of a distribution target | 🔴 **MAJOR** | Requires a migration note; it may also break the updater's URL conventions (see [Phase 1](#phase-1--tag-release-and-write-it-down-rules-repo)). |
| 7 | Changes to the **`# Custom - …` banner markers** that the updater uses to split central/custom sections | 🔴 **MAJOR** | The updater merges on those markers; getting this wrong silently eats a team's overrides. |

Rules of thumb 📏

- 🤔 **In doubt, bump higher.** Over-signalling costs a reader five minutes; under-signalling costs a team a red build.
- 🧮 One release may contain several changes — the release takes the **highest** bump among them.
- 🧯 A 🔴 major release **must** ship release notes with a *what you need to do* section. For level 6 and 7 changes that
  means a real migration guide, not a one-liner.

### 🤖 Conventional commits → bump

Since the updater repo already runs [release-please](https://github.com/googleapis/release-please), the same convention
can drive the version automatically here:

| Commit prefix | Bump | Use for |
|---------------|------|---------|
| `fix:`, `docs:`, `chore:` | 🟢 PATCH | Level 1, analyzer patch bumps (level 4) |
| `feat:` | 🟡 MINOR | Levels 2 and 5b |
| `feat!:` / `fix!:` / `BREAKING CHANGE:` footer | 🔴 MAJOR | Levels 3, 4 (major/minor analyzer bumps), 5a, 6, 7 |

Scope the commit with the affected distribution so the generated changelog is readable, e.g.
`feat(dotnet11)!: raise SA1413 to error`.

## 🏷️ Release process

1. 📝 A PR changes the rules, following the existing [process around changes](../README.md#-process-around-changes)
   (argumentation → ATC core-team decision → documented in the PR).
2. 🔖 The commit message declares the impact via the conventional-commit prefix from the table above.
3. 🤖 release-please maintains a release PR with the next version and the accumulated `CHANGELOG.md`.
4. ✅ Merging the release PR bumps the version (manifest + file headers), tags `vX.Y.Z` and publishes a GitHub Release.
5. 📣 The release notes carry, per entry: the affected distribution(s), the impact level and — for 🔴 major — the
   migration steps.

## 🔄 Rollout plan — and what it means for the updater

The phases are ordered so that **every phase is useful on its own** and **no phase breaks an updater version that is
already out in the wild**. `main` always keeps pointing at the newest released state, which is exactly what the
updater reads today.

### Phase 1 — tag, release and write it down (rules repo)

- Add `CHANGELOG.md` and the release-please configuration (`release-please-config.json`,
  `.release-please-manifest.json`) plus a `release-please.yml` workflow — this repo currently has **no** workflows at all.
- Cut `v1.0.0` from the current `main`.
- Document the scheme (this file) and link it from the README.

👉 **Updater impact: none.** It keeps reading `main`. Consumers immediately gain release notes and the ability to diff
two releases (`compare/v1.0.0...v1.1.0`) to see what a sync will do.

### Phase 2 — make the version visible in the files (rules repo)

- Replace the hand-maintained, drifted per-file `# Version:` / `# Updated:` headers with a single value stamped by the
  release workflow, so every distribution file in a release carries the same number:

  ```ini
  # ATC coding rules - https://github.com/atc-net/atc-coding-rules
  # Version: 1.1.0
  # Updated: 2026-10-04
  # Location: src
  # Distribution: DotNet11
  ```

- Publish a machine-readable manifest at `distribution/version.json`, reachable through the exact same raw-URL
  convention the updater already uses:

  ```json
  {
    "version": "1.1.0",
    "released": "2026-10-04",
    "impact": "minor",
    "releaseNotes": "https://github.com/atc-net/atc-coding-rules/releases/tag/v1.1.0"
  }
  ```

👉 **Updater impact: none required.** The header lives inside the central section, which the updater copies verbatim,
so consumers start seeing *which version their local files are on* without a tool update. ⚠️ Because the header is part
of that section, the stamping must happen on `main` at release time (release-please style) — otherwise every run would
rewrite the header and report a change.

### Phase 3 — let consumers pin a version (updater)

Today the ref is baked into a single constant:

```csharp
// src/Atc.CodingRules.Updater.CLI/ProjectHelper.cs
private static readonly string RawCodingRulesDistributionBaseUrl =
    Constants.GitRawContentUrl + "/atc-net/atc-coding-rules/main/distribution";
```

The change is small and local: make the `main` segment configurable, defaulting to `main` so current behaviour is
unchanged.

- New optional `rulesVersion` property in `atc-coding-rules-updater.json` and a matching `--rulesVersion` argument;
  `1.1.0` resolves to `refs/tags/v1.1.0`, the default `main` keeps the rolling behaviour.
- ⚠️ A typo'd or non-existent ref currently 404s, which the download helper turns into empty content → the file is
  *silently skipped*. Pinning must therefore **validate the ref up front and fail fast**, otherwise a mistake looks
  like a successful no-op run.
- Reproducible CI runs: combined with `--dry-run --failOnChanges`, a pinned version turns the updater into a stable
  drift gate that does not go red just because the rules moved.

### Phase 4 — tell the consumer what an update costs (updater, optional)

- Read the local `# Version:` header, compare it against `distribution/version.json` on `main`, and end a run with
  something like: *"Rules 1.1.0 → 2.0.0 (🔴 major) — see release notes before syncing."*
- Mirrors what the tool already does for its own NuGet version, so the UX pattern exists.

### 🚫 What this does **not** change

- Copying the `distribution` folder by hand keeps working exactly as before.
- Unpinned updater runs keep tracking `main` — nobody is forced to adopt versions.
- Nothing about the central/custom split, the severity policy, or the governance process changes.

## ✅ Maintainer checklist

For every PR that touches `distribution/`:

- [ ] 🔍 Which impact level (1–7) does this change have?
- [ ] ✍️ Does the commit message use the matching conventional-commit prefix and scope?
- [ ] 📦 Which distribution target(s) are affected — is the changelog entry scoped to them?
- [ ] 🔴 If this is a major: are the *what you need to do* steps written down in the PR description, ready to be lifted
      into the release notes?
- [ ] 🧭 Does it change folder layout, file names or the `# Custom - …` banners — i.e. does the updater's URL/merge
      convention need a follow-up in `atc-coding-rules-updater`?

## ❓ Open questions

1. 🧮 **One version for everything, or per distribution target?** This document argues for one; the cost is that a
   target-specific major is visible to everyone. Is the scoped changelog enough compensation?
2. 🔴 **Is "a rule got stricter" really a major?** Strictly it is breaking. If it turns out to produce a new major every
   other month, the alternative is a *minor + explicit `⚠️ tightening` marker* in the release notes — a documented
   deviation from SemVer, which several analyzer/lint config projects choose.
3. 🧷 **Should a 🔴 major be the moment we introduce a new distribution folder** (e.g. keep `dotnet11` frozen and add
   `dotnet11-v2`) so consumers can migrate on their own schedule? That trades repository size for consumer control.
4. 📅 **Release cadence** — on every merge (release-please default) or batched, so consumers are not chasing a moving
   target?
5. 🧱 **Do we version `global.json`?** It ships in `distribution/` but the updater never downloads it.
