> Part of [CLAUDE.md](../CLAUDE.md) — see the main file for orientation.

## QA gate (composition; mechanized in ahimsa, L2 contract owned by matika)

The product authority owns the QA *gate* as a **composition**: it is where the
three-layer testing model (`ARCHITECTURE.md` §10) is composed into a single product
gate. The verification *mechanism* lives in the components and is cross-referenced
here (not duplicated): the gate is run by ahimsa, the L2 structural contract is
owned by matika, and each applug authors its own L3 functional tests.

**Status:** the gate is **PROVEN green end-to-end** against a live frozen artifact.
A real dispatch ran green across all three platforms and both install arms, in both
scenarios (fresh + upgrade) — tier-a 20 screens, tier-b 17 markers, and L3 eyerate
3/3, all non-skipped.

A candidate product version passes the gate when ahimsa's `build.yml` runs
**L1 + L2 + L3 green** against the FROZEN artifact on BOTH install arms, in BOTH
scenarios, across all three platforms:

- **Two install arms.** The build-job **build-dir** arm (`scripts/frozen_verify.py`
  + `scripts/browser_verify.py`) runs against the freshly frozen build in CI; the
  **installed-artifact** arm (`install-verify`) runs against the actually-installed
  product. The build-dir arm catches **logic** regressions first; the
  installed-artifact arm's independent value is the **upgrade / stale-plugin path
  and packaging integrity**, not logic.
- **Two scenarios.** Each arm runs both a **fresh install** and an **upgrade over a
  prior install** — the upgrade path is where the stale-plugin regression escaped.
- **Three platforms.** `macos-14` (arm64), `macos-15-intel`, and `windows-latest`.

The three layers it composes:

- **L1 — component own suites.** Each component unit/integration-tests its own
  functions in its own suite (matika included: auth / RBAC / CSRF / loaders). See
  `manomatika/matika`, `manomatika/eyerate`, `manomatika/ahimsa`.
- **L2 — generic structural harness** (matika owns the contract; the ahimsa gate
  runs it). Domain-blind and manifest-driven: **tier-a** (`scripts/frozen_verify.py`)
  asserts every declared screen's route is alive, authorized, and renders HTML over
  authenticated HTTP; **tier-b** (`scripts/browser_verify.py`) drives each declared
  screen's steps through a headless browser (Playwright) via a generic verb executor
  and asserts its markers in the live DOM. Applug-agnostic. See `manomatika/matika`,
  `manomatika/ahimsa`.
- **L3 — applug-authored functional tests, generically invoked, reboot-per-applug.**
  The gate discovers each applug's `*_functional_tests.json` (schema version 1.0,
  optional `setup`/`teardown`) from a **SHA-pinned source clone** — Option-3
  discovery: the build jobs emit the resolved `matika_sha` / `applug_shas` and the
  install-verify arm checks out exactly those SHAs, so **test code never ships in the
  product artifact**. It groups tests by applug and, for each applug, boots a fresh
  app in a clean `HOME`, runs only that applug's tests in **randomized (seeded)
  order**, then tears down. Each test self-arranges its preconditions (declared
  `setup`) and self-resets what it mutated (declared `teardown`, guaranteed-run
  try/finally); randomized order is the verifier that reset discipline holds. Reboot
  is coarse containment **between applugs only** — no within-applug reboot — and a
  test that cannot reset its mutation is a **defect**, never rebooted-around. The
  base seed is logged as `L3 random seed: <seed>` and is replayable via `--l3-seed`.
  See `manomatika/ahimsa`, `manomatika/matika`.

Component contracts the gate enforces:

- **matika's launcher contract.** The frozen app refreshes a bundled plugin on
  **every launch** when the bundled version/fingerprint differs (per-plugin
  `.matika_plugin_install.json` marker), preserving user/runtime data — the fix for
  the stale-plugin regression that the upgrade path exists to catch. See
  `manomatika/matika`.
- **eyerate's provider contract.** A provider failure surfaces LOUDLY as **HTTP
  502** with a `detail` body — never a silent empty result; the gate forces a
  keyless provider and asserts the visible error. See `manomatika/eyerate`.
