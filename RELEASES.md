# Releases

Canonical log of every git tag pushed from component repositories. Entries use the form `## <repo> <tag>` so a single file covers all repos in the ecosystem. Every tag matching `vX.Y.Z` or `vX.Y.Z-PRERELEASE` must have an entry here; entries for failed-publish tags are retained as audit breadcrumbs. Entries are listed newest-first.

The tag/entry consistency rule is enforced by `ahimsa-validate-releases`.

---

## eyerate v0.0.4-rc.2

- **Date:** 2026-06-20
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/eyerate#45
- **Summary:** Second release candidate for eyerate v0.0.4. Bug A fix: replace the
  eyerate_admin.html stub ("Administration features coming soon.") with a
  working provider-selection form (radio buttons for yahoo/finnhub/
  alphavantage, API key field, Save/persist via POST). Task 4: add ProviderError
  exception class so all three data providers (Yahoo, Finnhub, AlphaVantage)
  raise on HTTP errors, rate limits, missing API keys, and dep-import failures
  instead of swallowing exceptions and returning empty results. Routes return
  HTTP 502 with "lookup failed: <reason>" so the UI distinguishes provider
  failure from genuine zero results. Lookup dialog JS checks resp.ok and shows
  an error message instead of silently showing empty rows. Dep-check at load
  time logs "Data provider deps OK (yfinance, curl_cffi)" for the ahimsa smoke
  gate. 13 new regression tests. Paired with manomatika/matika v0.0.4-rc.5 and
  manomatika/ahimsa#75 (applug deps install before freeze + data_deps_ok smoke
  gate). Notes-only GitHub prerelease for QA.

## matika v0.0.4-rc.5

- **Date:** 2026-06-20
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/matika#79
- **Summary:** Fifth release candidate for matika v0.0.4. Adds collect_all("yfinance") and
  collect_all("curl_cffi") to matika.spec so the eyerate data-provider libraries
  are bundled in the frozen artifact. Previously these were lazy imports
  invisible to PyInstaller's static analysis, causing Bug B: symbol
  lookup/search silently returned empty results in the frozen app. Also adds a
  sys.path guard to validate_recipe.py so it can be run as a direct file without
  pip installation (fixes test_invocation_direct_file). Paired with
  manomatika/eyerate v0.0.4-rc.2 and manomatika/ahimsa#75 (applug deps install
  before freeze + data_deps_ok smoke gate). Smoke-validated green on all three
  platforms (arm, intel, windows) with data_deps_ok gate passing. Notes-only
  GitHub prerelease for QA.

## matika v0.0.4-rc.4

- **Date:** 2026-06-19
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/matika#78
- **Summary:** Fourth release candidate for matika v0.0.4 — fixes the third boot failure: the
  frozen ManoMatika-0.0.1 bundle installed with the correct product identity
  (the rc.3 fix) but died on first launch with "No module named 'alembic'" and
  left NO log file. Two matika defects: (1) matika.spec listed only
  alembic.command/alembic.config as hiddenimports, which does not collect the
  rest of the alembic package and its dynamically-loaded migration runtime — now
  uses PyInstaller collect_all("alembic") + collect_all( "sqlalchemy") and pins
  the in-process migration script_location to the bundled sys._MEIPASS
  migrations dir; (2) an early/import-time failure left no log — launcher.py now
  brings logging up first, installs a last-resort excepthook, and wraps the
  whole startup so a full traceback always reaches ~/matika/logs. The deeper
  root cause (the build never pip-installing matika's runtime deps before
  PyInstaller, so nothing was bundled) is fixed in manomatika/ahimsa#73, which
  also adds a CI smoke-launch step that boots the frozen artifact on all three
  platforms — the durable guardrail that makes an unbootable build fail in CI.
  Paired with manomatika/manomatika#17 (recipe pinned to v0.0.4-rc.4). Notes-
  only GitHub prerelease for QA.

## matika v0.0.4-rc.3

- **Date:** 2026-06-19
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/matika#77
- **Summary:** Third release candidate for matika v0.0.4 — fixes the product-identity
  regression introduced by v0.0.4-rc.2: the spec changes that read
  MATIKA_PRODUCT_NAME/MATIKA_PRODUCT_VERSION from the build env were merged to
  matika main after the rc.2 tag was cut, so CI builds cloning at rc.2 produced
  Matika-0.0.4 instead of ManoMatika-0.0.1. Adds a CI fail-loud guard in
  matika.spec: if CI=true and MATIKA_PRODUCT_NAME is unset the spec exits
  immediately with a clear error instead of silently mis-naming the bundle.
  Paired with manomatika/manomatika#16 (recipe pinned to v0.0.4-rc.3) and
  manomatika/ahimsa#72 (PyInstaller assertion step + manomatika_ref cross-repo
  validation input). Notes-only GitHub prerelease for QA.

## matika v0.0.4-rc.2

- **Date:** 2026-06-18
- **Status:** published
- **Artifact:** none (notes-only GitHub prerelease)
- **PRs:** manomatika/matika#70
- **Summary:** Second release candidate for matika v0.0.4 — ships platform-native app icons
  (.icns for macOS, .ico for Windows) generated from the new 512×512 square PNG
  source (matika_icon_512.png). Fixes the PyInstaller 6.21 freeze caused by
  using a PNG as the app icon without Pillow. matika.spec now selects the native
  icon per platform at spec-parse time via sys.platform; Pillow is not added to
  any requirements file. This is a notes-only GitHub prerelease for QA
  validation — not a blessed product release.

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

