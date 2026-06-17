# Releases

Canonical log of every git tag pushed from component repositories. Entries use the form `## <repo> <tag>` so a single file covers all repos in the ecosystem. Every tag matching `vX.Y.Z` or `vX.Y.Z-PRERELEASE` must have an entry here; entries for failed-publish tags are retained as audit breadcrumbs. Entries are listed newest-first.

The tag/entry consistency rule is enforced by `ahimsa-validate-releases`.

---

## matika v0.0.4-rc.1

- **Date:** 2026-06-17
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/matika#67, manomatika/matika#68
- **Summary:** First release candidate for matika v0.0.4 — the ManoMatika v0.0.1 product cut
  (matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1) — published as a notes-only
  GitHub prerelease for QA, not a blessed product release. Adds the release
  pipeline (VERSION as the single source of truth; sync_version.py propagation
  with a read-only --check drift mode) and the canonical strict SemVer authority
  in src/matika/core/paths.py, establishing the core/suffix contract and the
  X.Y.Z-dev < X.Y.Z-rc.N < X.Y.Z ladder. Also adds the @manomatika/matika-
  frontend npm package (publish gated to final bare-SemVer tags) consumed via a
  runtime import map, a notes-only tag-triggered release job, frozen-app
  PyInstaller packaging, and a compiled-asset guardrail. Consolidated the
  *_menus.json menu schema, lowercased the ~/matika data dir and log filenames,
  removed matika's own RELEASES.md (the ecosystem audit log now lives here in
  manomatika/manomatika), and fixed CSRF attachment in frontend POSTs.

## matika v0.0.4-dev.2

- **Date:** 2026-05-07
- **Status:** published (tag subsequently deleted)
- **Artifact:** @manomatika/matika-frontend@0.0.4-dev.2 (GitHub Packages)
- **PRs:** manomatika/matika#37
- **Summary:** Adds the import map entry for @manomatika/matika-frontend in matika's
  base.html. Applugs (eyerate first) can now import the package via bare
  specifier; matika owns the URL mapping centrally so applugs do not hardcode
  /static/js/index.js. Package contents are unchanged from v0.0.4-dev.1 — the
  bump exists for ecosystem version coherence under the convention that
  committed-tree changes get their own prerelease-bumped tag.

## matika v0.0.4-dev.1

- **Date:** 2026-05-06
- **Status:** published (tag subsequently deleted)
- **Artifact:** @manomatika/matika-frontend@0.0.4-dev.1 (GitHub Packages)
- **PRs:** manomatika/matika@23de78d (direct-to-main lockfile fix; no PR opened)
- **Summary:** First successful publish of @manomatika/matika-frontend. Establishes the
  public TypeScript surface for applugs to consume: MaintenanceActivityManager,
  ActivityMetadata, getCsrfToken, injectCsrfToken. Tagged from a direct-to-main
  commit that committed the previously-missing package-lock.json. Future
  lockfile changes must follow standard branch + PR discipline.

## matika v0.0.4-dev.0

- **Date:** 2026-05-06
- **Status:** superseded (by matika v0.0.4-dev.1)
- **Artifact:** none (publish failed; breadcrumb only)
- **PRs:** manomatika/matika#35
- **Summary:** First attempted publish of @manomatika/matika-frontend. The publish workflow
  failed in npm ci because package-lock.json was not committed to the
  repository. Tag retained as audit breadcrumb; superseded by v0.0.4-dev.1 which
  committed the lockfile and republished successfully.

## matika v0.0.3

- **Date:** 2026-04-28
- **Status:** published
- **Artifact:** none (pre-RELEASES.md historical release)
- **PRs:** (pre-RELEASES.md historical release)
- **Summary:** Pre-RELEASES.md historical release. See git log for commit details.

## matika v0.0.2

- **Date:** 2026-04-27
- **Status:** published
- **Artifact:** none (pre-RELEASES.md historical release)
- **PRs:** (pre-RELEASES.md historical release)
- **Summary:** Pre-RELEASES.md historical release. See git log for commit details.

## matika v0.0.1

- **Date:** 2026-04-18
- **Status:** published
- **Artifact:** none (pre-RELEASES.md historical release)
- **PRs:** (pre-RELEASES.md historical release)
- **Summary:** Pre-RELEASES.md historical release. See git log for commit details.

## eyerate v0.0.4-rc.1

- **Date:** 2026-06-17
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/eyerate#42, manomatika/eyerate#43
- **Summary:** First release candidate for eyerate v0.0.4 — the ManoMatika v0.0.1 product cut
  (matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1) — published as a notes-only
  GitHub prerelease for QA, not a blessed product release. eyerate is a Matika
  applug; its applug.json carries bare core 0.0.4 for both version and
  matika_version. Adds the release pipeline mirroring matika (sync_version.py
  propagation of version + matika_version with a --check drift mode; a canonical
  strict-SemVer authority that hard-errors when matika's VERSION is
  unavailable), npm consumption of matika's frontend via the @manomatika/matika-
  frontend bare specifier, a ts/ TypeScript layout with kebab-case filenames, a
  notes-only tag-triggered release job, and a compiled-asset guardrail. Split
  the test suite into a stack-independent tier and a self-sufficient integration
  tier, and fixed a static-asset 404 by mounting eyerate static at
  /eyerate/static to avoid a Starlette route-ordering conflict with matika's
  broad /static mount (regression test added).

## eyerate v0.0.3

- **Date:** 2026-04-28
- **Status:** published
- **Artifact:** none (notes-only GitHub release)
- **PRs:** (historical; pre-migration to manomatika org — merged via legacy pjtallman/EyeRate#13 and pjtallman/EyeRate#14)
- **Summary:** Consolidated-menu and applug-compatibility work: introduced the consolidated
  eyerate_menus.json menu matrix, flattened Admin role items into the aggregated
  Admin dropdown, removed the legacy eyerate_menu.json, and tightened
  .gitignore. KNOWN ISSUE: this tag shipped stale applug.json content — version
  and matika_version both declare 0.0.2 despite the v0.0.3 tag, because the
  release process did not propagate VERSION into applug.json at tag time. Left
  in place as historical record; do not consume. v0.0.4 establishes VERSION as
  the single source of truth with drift-detecting propagation into every
  version-bearing file. Tagged from the legacy pjtallman/EyeRate repository
  before the migration to the manomatika org.

## eyerate v0.0.2

- **Date:** 2026-04-27
- **Status:** published
- **Artifact:** none (notes-only GitHub release)
- **PRs:** (historical; pre-migration to manomatika org — merged via legacy pjtallman/EyeRate#4)
- **Summary:** Milestone 2 menu refactor. Reworked the menu structure with accompanying
  security fixes and persistence-layer improvements, refreshed applug metadata
  and documentation, and repaired the release script (symlink loop) and
  corrupted markdown headers. Tagged from the legacy pjtallman/EyeRate
  repository before the migration to the manomatika org.

## eyerate v0.0.1

- **Date:** 2026-04-18
- **Status:** published
- **Artifact:** none (notes-only GitHub release)
- **PRs:** (historical; pre-migration to manomatika org — merged via legacy pjtallman/EyeRate#2)
- **Summary:** Initial eyerate reference-implementation applug baseline. Phases 1–5 of the
  initial refactor: extracted eyerate's logic out of matika, renamed the
  financial-security artifacts for clarity, added the user guide and folder-
  structure documentation, and reached a deployable server with working password
  update. Tagged from the legacy pjtallman/EyeRate repository before the
  migration to the manomatika org.

## ahimsa v0.0.1

- **Date:** (pending)
- **Status:** (pending — tag not yet pushed)
- **Artifact:** none (pending)
- **PRs:** (pending)
- **Summary:** Placeholder entry for ahimsa v0.0.1. To be filled at release time.

