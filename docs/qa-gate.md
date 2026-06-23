> Part of [CLAUDE.md](../CLAUDE.md) — see the main file for orientation.

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
