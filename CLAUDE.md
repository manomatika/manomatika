# CLAUDE.md — manomatika (product authority)

Guidance for AI agents (cc) and assistants working in this repository.

## What this repo is

`manomatika/manomatika` is the **product authority** for the ManoMatika
ecosystem. **ManoMatika is the product**: a QA-validated, pinned triple of
component versions (matika + eyerate + ahimsa). This repo is NOT a component;
it composes and releases components.

This repo owns:

- the **recipes** that compose a product from its components;
- the **audit log** — `release-log.yaml` (human-edited source) and the generated
  `RELEASES.md`;
- the **product release** and the single hosted **installer binary**;
- the per-product-version **manifest / BOM** (each component pinned by **tag AND
  resolved commit SHA**);
- the cross-component umbrella **docs** (`ARCHITECTURE.md` and below);
- the **QA gate** a product version must pass before release.

**TARGET-vs-CURRENT (manifest/BOM):** the per-version manifest is still a TARGET.
Today `manifests/` holds only `TEMPLATE.yaml` (the schema: `components[]` of
`{repo, tag, sha}` + `installer{filename, platform, sha256}` + `qa{suite, result,
reference}`). No concrete `<version>.yaml` (e.g. `0.0.1.yaml`) exists yet — the
first real BOM is authored when the first product version is cut. (Note the
TEMPLATE's example installer filename predates the lowercase-slug convention in
*Naming conventions* — the convention, not the stale example, is authoritative.)

ahimsa is pure *mechanism* (the recipe engine): it builds and validates
artifacts on demand but owns no recipe content and hosts no product releases.
matika and eyerate are components that ship as notes-only prereleases.

## Test discipline (non-negotiable)

- **Full-suite, every change, everywhere — 100% clean (standing rule 21).** ANY
  code change, in ANY repo, requires the COMPLETE unit-test suite of every
  affected repo (and any repo whose behavior could be impacted) to RUN IN FULL —
  nothing excluded, deselected, skipped, or marked integration-only — and pass
  100%: **0 failed / 0 skipped / 0 xfail / 0 deselected / 0 warnings**. No test
  may be excluded or filtered and no warning suppressed without the product
  owner's explicit, per-case approval recorded as a documented rule variation.
- **Eliminate warnings at the root.** A warning is a defect, not noise: fix the
  emitting code or bump the offending dependency (e.g. timezone-aware
  `datetime.now(timezone.utc)` instead of deprecated `datetime.utcnow()`; a
  patch-bump of a dependency that emits a self-deprecation). Never silence a
  warning with a `filterwarnings` entry, a `-W ignore`, or a `-m 'not …'`
  deselection — those are suppression, and suppression requires the same
  explicit per-case owner approval as excluding a test.
- **The full suite runs in each repo's correct environment** (the uv-managed
  `.venv`) so a green run is never an env artifact. A change is not done until
  every affected suite is 100% clean.
- **Escaped-bug regression mandate (standing rule 22).** Any bug that reaches
  CI, an rc, or install/runtime testing without being caught by the suite MUST,
  as part of its fix, gain a regression test that would have caught it — added
  at the layer where it escaped (unit/integration for logic gaps; a feature/E2E
  check against the **frozen, pinned artifact** for product-behavior gaps). The
  fix is not done until that test exists, fails without the fix, and passes with
  it. Product-behavior regressions must be exercised against the frozen artifact
  on BOTH install paths (fresh install AND upgrade over a prior install), since
  the upgrade path is where the stale-plugin regression escaped.

## Documentation integrity (non-negotiable)

CLAUDE.md and all docs in this repo must NEVER knowingly hold stale information.

- Every factual claim is verified against actual repo state on each edit or
  regeneration.
- When a claim cannot be verified, omit it rather than guess.
- TARGET-vs-CURRENT divergence (where the intended model differs from what the
  code/repo physically contains today) must be stated honestly, not papered over.

## Naming conventions (non-negotiable)

- All four repo slugs are ALWAYS lowercase, everywhere (URLs, paths, code
  identifiers, config refs): `manomatika`, `matika`, `eyerate`, `ahimsa`.
- `ManoMatika` (camel case) ONLY when naming the project/product as a proper
  noun in prose. `manomatika` (lowercase) when referencing the repo.
- `applug` is always rendered lowercase.
- The product's installed identity is the PRODUCT name `ManoMatika`, driven by
  the recipe's `application.product_name` field (see `ARCHITECTURE.md` §3). It is
  capitalized as a proper noun for the installed bundle/exe and shortcuts
  (`ManoMatika-<product-core>.app`, `ManoMatika-<product-core>.exe`), where
  `<product-core>` is the bare-core PRODUCT version (`application.version`, e.g.
  `0.0.1`) — NOT matika's framework version. The DMG/EXE **filename** uses the
  lowercase product slug (`manomatika-<product-core>-<os>-<arch>.dmg/.exe`),
  consistent with the lowercase artifact-filename convention. Lowercase still
  applies to repo slugs, URLs, internal/runtime data dirs (e.g. `~/matika/`),
  env vars (`MATIKA_*`), config refs, and the macOS `bundle_identifier`
  (`com.manomatika.matika`). User-facing surfaces in the matika framework now
  carry the product proper noun: the runtime FastAPI `title="ManoMatika"`
  (`src/matika/main.py`) and the en/es locale brand strings (e.g.
  `"ManoMatika - Yield Tracker"`) were flipped from `Matika` to `ManoMatika`.
  The internal package/repo identity stays lowercase `matika`.

## Cross-repo references

Always fully qualified: `manomatika/<repo>#N`, never a bare `#N` (issue numbers
collide across repos). Cross-repo `Closes` references only cross-link — they do
NOT auto-close; close manually after merge.

## Versioning

`VERSION` (this repo root) is the single source of truth for this repo's version
metadata. It reads a SemVer string of the form `X.Y.Z` or `X.Y.Z-<suffix>` with
no leading `v` (today: `0.0.1-dev`). The product manifest pins each component by
tag AND resolved commit SHA — no ranges, no wildcards.

Core / suffix contract (see `ARCHITECTURE.md` §7):

- **Version core (`X.Y.Z`)** is canonical for ALL comparison, artifact/bundle
  naming, and OS/installer/Info.plist fields.
- **Pre-release suffix** (`-dev`, `-rc.N`) lives ONLY on human/audit surfaces:
  the `VERSION` string, git tags, GitHub release titles/bodies, and the audit
  log. It never appears inside a recipe PIN field or BOM SHA mapping.
- **Recipe fields.** PIN fields (`recipe.json` `version` / `matika_version` /
  `applugs[].version`) stay bare core. The `tag` fields are git refs and MAY
  carry a suffix. `matika_version` is the matika FRAMEWORK compatibility pin —
  not a product version.
- **Ladder:** `X.Y.Z-dev` < `X.Y.Z-rc.N` < `X.Y.Z` (final). The suffix is
  delimited with a hyphen (`-dev`, valid SemVer); the underscore form (`_dev`)
  is invalid and is used nowhere in the ecosystem.

## QA gate (mechanized in ahimsa; component contracts it enforces)

The product authority owns the QA *gate*; the verification *mechanism* lives in
the components and is cross-referenced here (not duplicated). A candidate product
version passes the gate when ahimsa's `build.yml` produces a green frozen build:

- **ahimsa runs the gate in CI.** Each build job smoke-launches the frozen
  artifact and runs **tier-a** authenticated-HTTP checks (`scripts/frozen_verify.py`)
  and **tier-b** headless-Playwright checks (`scripts/browser_verify.py`) on BOTH
  install paths — **fresh install AND upgrade-over-stale** — across
  `macos-14` (arm64), `macos-15-intel`, and `windows-latest`. See
  `manomatika/ahimsa`.
- **matika's launcher contract it relies on.** The frozen app refreshes a bundled
  plugin on **every launch** when the bundled version/fingerprint differs (per-plugin
  `.matika_plugin_install.json` marker), preserving user/runtime data — the fix for
  the stale-plugin regression that the upgrade path exists to catch. See
  `manomatika/matika`.
- **eyerate's provider contract it asserts.** A provider failure surfaces LOUDLY as
  **HTTP 502** with a `detail` body — never a silent empty result; the gate forces a
  keyless provider and asserts the visible error. See `manomatika/eyerate`.
