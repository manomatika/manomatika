# ManoMatika v0.0.1 — Execution Plan
**Generated:** 2026-06-02 | **Revised:** 2026-06-09 (architecture redesign — product authority moved to `manomatika/manomatika`); 2026-06-14 (preconditions resolved, phase model added, #1–#3 marked complete); 2026-06-25 (testing-gate arc reconciled; applug security/test posture decided — WASM dropped, install-trust posture (a)); **2026-07-01 (this revision — full reconciliation to current state: frozen-app arc + automated installed-artifact gate DONE; matika `v0.0.4-rc.15` cut + gate-GREEN; milestone naming flipped to no-version-suffix + due dates shifted +14d → 2026-07-14; the ecosystem error-code / logging / localization framework added as the current active body of work; `Planning` milestone stood up in mm; release arc restated as pending behind framework + hardware test)**  
**Composition (the blessed triple):** matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1 — *the final bare-core tags are cut at the #12 release step; the current gate-proven candidate triple is matika `v0.0.4-rc.15` + eyerate `v0.0.4-rc.5` + ahimsa `main`.*  
**Planner:** Claude Code

> **2026-06-09 redesign.** The release architecture was redesigned. A new repo `manomatika/manomatika` (**mm** below) is now the **product authority**. `ahimsa` narrows to a **recipe engine**. The authoritative model is **§0**. The old Wave 1–6 orchestration and the "RELEASES.md / recipes / hosted release live in ahimsa" model are **superseded** — see §3, §5, §6, and the Appendix for what was retired and why.

### Execution-intent key
- **[AGENT PR]** — cc opens a PR (git worktree); the human reviews and merges every PR.
- **[HUMAN]** — Requires the human; cc cannot substitute (QA on clean machines, all PR merges, tagging, cutting the product release).
- **[cc MUTATION]** — GitHub state change executed autonomously by cc under standing permission.
- **[COMPLETE]** — Done; recorded for traceability.

---

## 0. CURRENT ARCHITECTURE (authoritative — overrides any contrary statement below)

- The **product** "ManoMatika" = a pinned **triple** of component versions (matika + eyerate + ahimsa). A **release** is the act of blessing one validated triple.
- **`manomatika/manomatika` (mm) = PRODUCT AUTHORITY.** It owns: the **recipes**; the **audit log** (`release-log.yaml` source + generated `RELEASES.md`); the **product release AND the single hosted installer binary**; cross-component **umbrella docs** (`ARCHITECTURE.md` linking down to component docs); the **per-product-version manifest/BOM** (pins each component by **tag AND resolved SHA**); and the **QA gate**.
- **`ahimsa` = RECIPE ENGINE ONLY:** build, validation, release **mechanism**, and the recipe **schema**. It owns **no** recipes, owns **no** audit-log content, and hosts **no** GitHub releases. It builds installers as **transient CI artifacts** via `workflow_dispatch`; it **never** runs `gh release create`.
- **`matika`, `eyerate` = components.** Self-scoped architecture docs. **Notes-only** releases (no binaries).
- **Release/QA flow:** code complete → component docs finalized → tag matika v0.0.4 + eyerate v0.0.4 (**prereleases, notes-only**) → ahimsa `build.yml` dispatched (`workflow_dispatch`, off main, recipe fetched **from mm**) producing installer **artifacts** (no release) → the **automated installed-artifact QA gate** (§1.1) runs L1+L2+L3 against the frozen artifact across all three platforms and both install arms → on green: tag ahimsa v0.0.1, author the mm product manifest/BOM, cut the **mm v0.0.1 product release** with the validated installers attached **there**. The GitHub **prerelease flag is the trust boundary**; the mm product release is the only blessed product.

---

## 1. CURRENT STATUS (2026-07-01 — authoritative for what is done vs. remaining)

The 2026-06-02…06-14 release-prep work (mm standup, recipe + audit-log relocation, engine retarget, docs refactor) is **COMPLETE** and is retained below as the underlying release mechanics (§3). Since then the release-prep gave way to two distinct bodies of work: (A) the **frozen-app + automated testing-gate arc**, now **DONE and gate-GREEN**, and (B) the **ecosystem error-code / logging / localization framework**, the **current active work** (§2). The product cut then sits behind the framework and a hardware test (§1.3).

### 1.1 DONE — frozen-app + automated installed-artifact gate arc

- **Frozen-app v0.0.1 launch/lifecycle/packaging defects (D1–D5)** — umbrella **manomatika/manomatika#39 CLOSED**. The frozen app boots deps-before-freeze, bundles whole-matika, does create_all + stamp on first run, and passes the CI smoke-launch gate.
- **Launcher health-gated reclaim feature** — the launcher's lifecycle path (healthz poll, graceful shutdown, `freeze_support`) plus the version/hash-gated, data-preserving reclaim-ours path landed and stayed intact through the rc series.
- **macOS gate false-positive root-caused + fixed** — the foreign-holder assertion false-positive that failed rc.13/rc.14 was root-caused (rc.14's `connect()`-based `_port_held()` probe never fixed it) and fixed in **matika `v0.0.4-rc.15`** via a new `_gui_dialogs_available()` gate (CI / `MATIKA_HEADLESS` → headless), reverting to rc.13's bind-based `_port_available()`. Paired ahimsa gate change (manomatika/ahimsa#126) drives the real assertion against a real spawned foreign listener.
- **matika `v0.0.4-rc.15` cut and gate-GREEN** — proven on **ahimsa gate run 28529124053** (green; all three platforms). Full matika suite 100% clean (619 passed, 0 failed/skipped/xfail/deselected/warnings); full ahimsa suite 100% clean (421 passed). Recipe repinned to matika `v0.0.4-rc.15` + eyerate `v0.0.4-rc.5`.
- **Automated installed-artifact screen + functional-testing gate (the "#11" arc)** — **built and proven GREEN end-to-end** against a live frozen artifact across all three platforms (`macos-14` arm64, `macos-15-intel`, `windows-latest`) and both install arms (build-dir + installed-artifact), in both scenarios (fresh + upgrade). One CI dispatch installs + feature-tests the installers, drives every declared product screen generically (L2 tier-a/tier-b), invokes applug-authored functional tests generically (L3), and cross-checks the live route table. Keystones merged: manifest-driven tier-a/tier-b harness (ahimsa#82); screens manifest schema v1.0 + verb allow-list (matika#84); Layer-3 contract + M4 parity test (matika#87 closed, matika#99 / ahimsa#102 / eyerate#63 merged). arm64 + Windows install-and-verify have run GREEN under the gate.

### 1.2 CURRENT ACTIVE WORK

- **Error-code / logging / localization framework** — the ecosystem-wide framework detailed in **§2**. 11 implementation runs (R0–R8) filed as tracking issues on **Project #1 (ManoMatika Roadmap)**, milestone **`Documentation & Release Readiness`**; all **OPEN**.
- **Remaining testing-gate follow-ons (open)** — hardening/consolidation on top of the proven gate: **manomatika/ahimsa#83** (A2 upgrade-detection assertion), **manomatika/ahimsa#84** (A3 route-vs-manifest hard gate), **manomatika/ahimsa#85** (A5 single dispatch + rc/final tag trigger + matrix consolidation), **manomatika/ahimsa#86** (A6 auto-issue-on-failure, deduped), **manomatika/manomatika#27** (MM1 QA-gate definition update). None blocks the current gate-GREEN status; each sharpens or consolidates it.

### 1.3 RELEASE ARC — pending, behind the framework + a hardware test

Restated from the old §3 steps 8–13. The cut is gated by the framework merges and a physical-hardware test off the framework-complete triple.

- **Hardware test (~2026-07-15)** — [HUMAN] real-hardware validation off the framework-complete triple, on top of the automated gate.
- **#12 Cut ManoMatika v0.0.1** — final **bare-core** tags (matika v0.0.4, eyerate v0.0.4, ahimsa v0.0.1) cut at a SHA **≥** the framework merges; author the **first real per-version BOM** (`manifests/<version>.yaml`, pinning each component by tag + resolved SHA) **including the `error_registry` block** (§2, §6.5); reconcile **`VERSION`** (`0.0.1-dev` → `0.0.1`); **remove the ahimsa `build.yml` `requirements.txt` fallback**; cut the **mm v0.0.1 product release** with the validated installer(s) attached. Re-verify a final build first.
- **#13 Regenerate `RELEASES.md`** — via the engine so the audit log records ManoMatika v0.0.1.
- **#14 Close out** — record the platforms covered by the automated gate + the hardware test; close the pass's remaining tracking issues.

> **Live release caveat — unsigned installers.** v0.0.1 installers are unsigned: macOS Gatekeeper blocks the DMG ("can't be opened because Apple cannot check it") and Windows SmartScreen warns; QA/users must right-click → Open (macOS). The limitation is carried in the notes content on the mm product release. Signing/notarization is backlog (ahimsa#25, milestone `Signing & Distribution`).

---

## 2. ERROR-CODE / LOGGING / LOCALIZATION FRAMEWORK (current active work)

A uniform, gate-enforced **error-code framework** across all four repos. Every error (and, provisionally, every warning) gets an opaque code `<COMPONENT>-<FAC>-<NNN>` that is simultaneously (a) the machine carrier stamped on the log record / HTTP detail, and (b) the i18n catalog key (**Model A**). Each origin declares its codes in a per-origin `error-codes.yaml`; **ahimsa (the mechanism)** aggregates and validates them at the gate and snapshots the merged registry into the product BOM. Codegen'd typed constants recover compile-time "can't emit an unregistered code" safety. In parallel, matika's two accidental logging subsystems are unified into one config/format/path authority with two deliberate sinks (startup + runtime-aggregate), structured records, a code→severity/facility/destination stamping filter, and a two-phase startup→runtime buffer/flush carrying a shared `run_id`.

> **Source of record.** Each run below is a filed tracking issue; the issue body carries Pat's **final decided deltas**, which **override** the earlier consolidated planning recommendations wherever they differ. The deltas recorded in §2.3 are authoritative.

### 2.1 Code census — 94 concrete codes

| Origin | Prefix | Codes | Notes |
|---|---|---|---|
| matika | `MATIKA` | **54** | 15 facilities incl. LNCH/CFG/AUTH/RBAC/CSRF/…; `MATIKA-LNCH-001/002/003` preserved exactly (foreign holder / no holder / reclaim-failed) |
| eyerate | `EYERATE` | **9** | PROV / API / PLUGIN |
| ahimsa | `AHIMSA` | **31** | non-emitter (CI `::error::` + exit codes); `supported_locales: [en]` |
| manomatika | `MANOMATIKA` | **0** | **reserved, forward-looking namespace** (well-formed empty file) |
| **Total** | | **94** | |

Severity closed enum `fatal | error | warning`; `log_route` closed set `startup | aggregate | n/a`. Global uniqueness holds by prefix-disjointness → per-`(origin, facility)` contiguous `NNN`.

### 2.2 Runs, phases, and dependency order

All 11 runs are **OPEN**, milestone **`Documentation & Release Readiness`**, **Project #1 (ManoMatika Roadmap)**.

| Phase | Run | Issue | Repo | Scope | Model |
|---|---|---|---|---|---|
| **0 — Foundation** | R0 | ahimsa#127 | ahimsa | schema + `gen_error_codes.py` + lints + **report-only** aggregator + `ManoMatikaError` base | opus |
| | R1 | matika#118 | matika | logging unification — `logging_setup.py`, structured records, 2-phase flush, **settings clean-break** | opus |
| | R2 | matika#119 | matika | `supported_locales` parsing + `SUPPORTED_LOCALES` constant | sonnet |
| **1 — Retrofit** | R3a | matika#120 | matika | `error-codes.yaml` + generated constants + `errors.py` resolver + en/es catalogs | sonnet |
| | R3b | matika#121 | matika | launcher LNCH/CFG emit sites — emit `[MATIKA-LNCH-001]` **alongside** existing prose (edge-d) | opus |
| | R3c | matika#122 | matika | `src/` runtime emit sites (auth/RBAC/CSRF/routers/loaders) + test rework | opus |
| | R4 | eyerate#77 | eyerate | `error-codes.yaml` + `ProviderError.code` + routes + en/es catalogs + `applug.json` `supported_locales` (**now REQUIRED**) | sonnet |
| | R5 | ahimsa#128 | ahimsa | ahimsa's own 31 codes + `validate_recipe.Error.code` + `supported_locales: [en]` | sonnet |
| **2 — Flip + Authority** | R6 | ahimsa#129 | ahimsa | gate **flip-to-blocking** (V/X checks) + registry-parity coverage; **ahimsa is sole owner of `errors.*` parity** (matika R2 scoped OFF `errors.*`); asserts on **CODE**, never prose | opus |
| | R7 | ahimsa#130 | ahimsa | foreign-holder assert → `MATIKA-LNCH-001` + rule-22 regression | sonnet |
| | R8 | manomatika#48 | mm | BOM `error_registry` block (snapshot by **pointer + sha256**) + umbrella docs + `CLAUDE_COMMON` + reference the planning issues | sonnet |

**Dependency order:** `R0 ∥ R1 → R2 → (R3a → R3b ∥ R3c) ∥ R4 ∥ R5 → R6 ∥ R7 → R8`. Critical path: R1 (logging) → R3 (matika retrofit) → R6 (gate flip-to-blocking) → R7 (foreign-holder flip). **Edge (d):** R3b emits the code **alongside** the existing prose keywords so ahimsa's not-yet-flipped prose assert stays green; R7 flips to the code only after R3's matika tag is **re-pinned in ahimsa**.

### 2.3 Decided deltas (issues WIN over the earlier planning recommendations)

- **Q9 (R3a / matika#120):** registry + constants + base live in `src/matika/error/` **subdir**, **NOT** repo root.
- **Q10 (R3b / matika#121):** `SECRET_KEY` → **single config helper / single code path** (not two raises sharing a code).
- **Q12 (R3a / matika#120):** **NESTED catalog (option A)** + **EXTEND** the strict i18n checker to recurse `errors.<CODE>` for en/es parity. *(Overrides the earlier flat-key recommendation.)*
- **Q16 (R3a / matika#120):** **generate en catalog entries from the registry** (English never drifts; only es is hand/MT-authored).
- **Q18 (R1 / matika#118):** **full settings clean-break** — rename `app_*` → `aggregate_*`; **REMOVE the dead Test-log section**; per-log retention; single **`MATIKA_HOME`**; **run the settings migration NOW**; `deque(maxlen=1000)`; **UUID4** `run_id`; dated-file + retention rotation.
- **Q21 (R8 / manomatika#48):** reconcile `ARCHITECTURE.md` §6 `components:` **dict-vs-list** divergence while editing §6.

### 2.4 Deferred planning issues (Project #2 — v0.0.1 Post Release Activities; milestone `Planning`)

Spec/planning only; deferred beyond v0.0.1. R8 references them; they are filed by the issue-creation run, not by R8.

- **manomatika#45** — Error codes: public docs-URL scheme (`base_url + CODE`, e.g. `…/errors/MATIKA-LNCH-001`) + localized en/es pages; `docs_url` stays **derived** (no per-code field).
- **manomatika#46** — Audit log: append-only, retention, access controls (regulated-industry grade) — the real audit/security sink deferred from the v1 two-log model.
- **manomatika#47** — Error codes: thread the merged error-registry into the release audit log (whether `RELEASES.md` cites `entry_count`/`sha256` per release; the `MANOMATIKA-RELEASELOG-*` codes; the ahimsa-vs-mm ownership boundary).

---

## 3. RELEASE-MECHANICS SEQUENCE (retained; ordering superseded by §1.3)

Steps 1–7 (release-prep) are **COMPLETE**. Steps 8–13 are the release mechanics that now run as the §1.3 release arc, behind the framework + hardware test.

1. **CLAUDE.md staleness guardrail.** **[COMPLETE]** Rule: CLAUDE.md never knowingly contains stale info; every factual claim verified against actual repo state on each edit/regeneration; when unverifiable, omit. Re-applied via the `/cuf` CLAUDE.md regeneration.
2. **Delete local `matika v0.0.4-dev.*` tags** (hygiene). **[COMPLETE]** — remote dev tags removed.
3. **Stand up `manomatika/manomatika` (mm).** **[COMPLETE]** — README, CLAUDE.md, `manifests/`, `shell_scripts/` committed; mm now also carries its own milestones and its issues on Project #1.
4. **Relocate the reference-app recipe into mm.** **[COMPLETE]** — mm authored the recipe with canonical lowercase `manomatika/*` slugs; ahimsa `build.yml` retargeted to fetch it from mm; ahimsa#35/#30 closed as superseded; `fix/30-org-migration` deleted.
5. **Move the audit log to mm.** **[COMPLETE]** — `release-log.yaml` + `RELEASES.md` relocated to mm; `GitHubResolver` wired for live tag queries; `refresh-releases-md` retargeted to open PRs against mm.
6. **Retire ahimsa's release responsibility.** **[COMPLETE]** — release job and `push: tags: v*` trigger removed from `build.yml`; ahimsa builds artifacts on `workflow_dispatch` only, never creates GitHub releases.
7. **Docs refactor.** **[COMPLETE]** — umbrella `ARCHITECTURE.md` in mm; ahimsa docs/CLAUDE.md narrowed to engine scope; stale divergence text removed across repos. (`ARCHITECTURE.md` §6 `components:` dict-vs-list reconcile is folded into framework R8 / Q21.)
8. **Tag matika v0.0.4 + eyerate v0.0.4** (prereleases, notes-only). *Exercised iteratively as the rc series; the current gate-proven candidates are matika `v0.0.4-rc.15` + eyerate `v0.0.4-rc.5`. The final bare-core `v0.0.4` tags are cut at #12.*
9. **Dispatch ahimsa `build.yml`** (`workflow_dispatch`, off `main`) → installer **artifacts, no release**. The full build infra (PyInstaller, dmgbuild, Inno Setup) already lives on ahimsa `main`; step 9 exercises it.
10. **QA the frozen artifact** — now the **automated installed-artifact gate (§1.1)**, GREEN across all three platforms and both install arms; the original smoke-grade manual TC-B check is superseded.
11. **Cut ManoMatika v0.0.1** — see §1.3 **#12**.
12. **Regenerate `RELEASES.md`** — see §1.3 **#13**.
13. **Close out** — see §1.3 **#14**.

### Backlog (not in this release — keep noted)
- **POST-v0.0.1: mm release-assembly workflow** — mm will own a workflow that pulls ahimsa's built CI artifacts and publishes them to the mm product release (**ahimsa BUILDS, mm ASSEMBLES + PUBLISHES**), automating the manual artifact carry. Issue to be filed in mm.
- **Linux install support** — ahimsa#47 (spike).
- **Signing / notarization** — ahimsa#25.
- **Playwright tests** — matika#23 (milestone `Playwright`).
- **Registry epic** — ahimsa (milestone `Registry`).
- **Tech-debt** — matika#56 (conftest→fixture migration), eyerate#35 (integration conftest sibling-path hardening), eyerate#36 (PR-triggered Python test gate).

---

## 4. SCOPE & MILESTONES

### 4.1 Milestone naming & dates (current — verified 2026-07-01)

- **Milestone titles carry NO version numbers or dates** (per CLAUDE.md; the old `Name (vX.Y.Z)` suffix convention is **superseded** — see §5.1 for the historical record). Titles are byte-for-byte identical across repos where shared, so the org Project rolls them up.
- **Canonical current-cycle titles:** `Deployment & Install`, `Cleanup & Tooling`, `Documentation & Release Readiness` (all four repos); plus `QA & System Test` (ahimsa), `Playwright` (matika), `Registry` + `Signing & Distribution` (ahimsa); `Planning` (all).
- **Due dates** (shifted **+14d** from the original June dates):
  - Current-cycle milestones — **2026-07-14** (Deployment & Install, Cleanup & Tooling, Documentation & Release Readiness, ahimsa QA & System Test) in every repo, including mm.
  - Forward milestones — **2026-08-03** for the component repos' `Planning` / matika `Playwright` / ahimsa `Registry` + `Signing & Distribution`; **2026-08-02** for **mm `Planning`** (`#3`, newly stood up).
- **Roadmap markers:** Project #1 (ManoMatika Roadmap) renders current-cycle work at 2026-07-14; Project #2 (v0.0.1 Post Release Activities) renders forward/planning work at 2026-08-03. Milestone due dates are the single source of truth for scheduling (Pattern A — milestone-driven; no per-item date fields).

### 4.2 mm milestones (new)

mm now carries its own milestones: **`Documentation & Release Readiness`** (#1, due 2026-07-14 — holds framework R8 manomatika#48 [open] + manomatika#1 [closed]); **`Deployment & Install`** (#2, due 2026-07-14 — holds manomatika#27 QA-gate-definition [open] + manomatika#39 frozen-app [closed]); **`Planning`** (#3, due 2026-08-02 — holds the three deferred planning issues #45/#46/#47).

### 4.3 Deferred from v0.0.1

- **matika#23** (Playwright test) — milestone `Playwright`.
- **Windows 11 hardware QA** — no Windows test hardware; the Windows EXE is CI-built/gate-verified but not hardware-QA'd. Tracked next cycle (ahimsa#46, milestone `Planning`).
- **macOS arm64 / Windows** are now **exercised by the automated gate** (§1.1); the earlier "x86_64-only, arm64+Windows deferred" narrowing no longer applies.

---

## 5. RESOLVED DECISIONS

Decisions recorded for traceability. Historical entries retain their decision dates.

1. **Milestone naming convention flipped (current).** Milestone titles now carry **no version number or date**; the org Project rolls up shared titles by exact match. The earlier `Name (vX.Y.Z)` rename map is **superseded**; the historical record is preserved in §5.1. **(Current.)**

2. **Applug security & test posture — DECIDED 2026-06-25.**
   - **Trust posture (a): install-trust.** We trust everything at this stage; installing an applug (via recipe, or future runtime load) **is** the trust decision. Org-authored applugs are trusted by provenance (non-public org applug repo). Full statement: `docs/ManoMatikaUseCases.md`.
   - **applug test execution is pure build automation — NOT a security boundary.** The framework discovers every applug's unit tests through a known interface and runs them all at build time, identically for every applug. The earlier "securely execute untrusted applug tests" framing was a category error and is dropped.
   - **WASM/WASI isolation is OUT** — rejected on complexity, a security-critical runtime dependency, and the inability to run the real product test stack (compiled C/Rust extensions, sockets).
   - **Three-layer testing model** (unchanged, isolation-free): **L1** component own suites; **L2** generic structural harness (tier-a route/render + tier-b Playwright); **L3** applug-authored functional tests, generically invoked, reboot-per-applug.

3. **Automated installed-artifact gate is the QA gate (current).** The macOS x86_64-smoke-only manual check is superseded by the automated gate that runs L1+L2+L3 against the frozen artifact across all three platforms and both install arms, fresh + upgrade. Proven GREEN (ahimsa run 28529124053, matika `v0.0.4-rc.15`). **(Current.)**

4. **Error-code framework deltas (current).** Q9 `src/matika/error/` subdir; Q10 single `SECRET_KEY` code path; Q12 nested catalog + i18n-checker recursion; Q16 en-from-registry; Q18 full settings clean-break; Q21 ARCHITECTURE §6 dict-vs-list reconcile. Authoritative source is the run issues (§2.3). **(Current.)**

5. **Repo-slug canonicalization — SUPERSEDED by the redesign.** The GitHub Settings renames + non-recipe lowercasing (#38-early: matika#59, eyerate#33, ahimsa#51) are DONE and were always tag-independent. The recipe is **authored fresh in mm** with canonical `manomatika/*` slugs, so ahimsa#35/#30/#38 are superseded, not sequenced. **(Historical.)**

6. **Cross-repo work tracking.** ahimsa engine PRs that satisfy matika tracking issues use `References` (not `Closes`); the human manually closes the matika issues after merge. **(Valid.)**

7. **Release-notes engine — IMPLEMENTED (2026-06-03), content relocated to mm.** Repo-aware `(repo, tag)` validator + renderer + live cross-repo query + `workflow_dispatch` refresh. The audit-log **content** (`release-log.yaml` + `RELEASES.md`) lives in **mm**; ahimsa retains only the **engine**, retargeted to render mm's log. ahimsa's release job is retired. **(Valid — see §6.)**

8. **Lowercase install/deployment directory policy (EXECUTED 2026-06-04).** Runtime app-data dir `~/matika/`; log filenames lowercased. App-bundle/installer names (`ManoMatika.app`, `ManoMatika-<ver>.exe/.app`) stay capitalized as the installed PRODUCT identity, driven by the recipe's `application.product_name`. **(Valid.)**

9. **eyerate test-suite green (2026-06-04).** Full suite passes with the correct environment (`PYTHONPATH=src:../matika/src`, eyerate beside the matika clone). The reported failures were a sibling-clone setup artifact (eyerate#35, hardening). Not a QA blocker. **(Valid.)**

10. **POST-v0.0.1: mm release-assembly workflow (2026-06-14).** ahimsa BUILDS, mm ASSEMBLES + PUBLISHES as code; automates the manual artifact carry. Not in v0.0.1 scope. **(Valid — Backlog.)**

11. **Windows QA deferral + Linux spike (2026-06-03).** No Windows 11 test hardware; the EXE ships CI-built/gate-verified, not hardware-QA'd (ahimsa#46, `Planning`). Linux install spike ahimsa#47. **(Valid.)**

### 5.1 Milestone rename map — HISTORICAL RECORD (superseded)

The 2026-06 pre-execution renames applied a `Name (vX.Y.Z)` suffix (matika→v0.0.4, eyerate→v0.0.4, ahimsa→v0.0.1; planning→next version). **That convention has since been reversed:** milestone titles now carry no version number (§4.1, §5 item 1). The suffix table is retained only as a record of the intermediate state; the version-suffixed titles it listed **no longer exist** in GitHub. Closed/historical milestones are left exactly as-is (no rename, no delete) — this explicitly includes eyerate closed #9 `v0.0.5 — Cleanup`.

---

## 6. AUDIT LOG + RELEASE-NOTES ENGINE — log owned by **mm**, mechanism in **ahimsa**

> **Status.** The release-notes / audit system was built in ahimsa (2026-06-03) then relocated: the audit log's **content** (`release-log.yaml` source + generated `RELEASES.md`) lives in **mm**; ahimsa retains only the **rendering engine** (validator + renderer + cross-repo query + refresh job), retargeted to render mm's log. The umbrella is **mm itself** (full product authority), not a separate `manomatika/release` notes repo.

### 6.1 Ownership split (authoritative)
- **mm owns the content:** `release-log.yaml` (human source of truth), the generated `RELEASES.md` (audit log), the **product release notes**, the **product manifest/BOM** (each component by **tag + resolved SHA**), and the umbrella **`ARCHITECTURE.md`**. mm hosts the **product release** and the **single installer binary**.
- **ahimsa owns the mechanism:** the repo-aware validator, the renderer, the **live cross-repo tag query**, and the **`workflow_dispatch` refresh** job. These **read mm's `release-log.yaml` and write/validate mm's `RELEASES.md`**. ahimsa owns no log content and hosts no release.
- **matika / eyerate:** **notes-only** releases (per-repo `docs/release-notes/<tag>.md`) that link to the **mm product release** for installers. They never attach binaries.

### 6.2 Validator / renderer design (retained, reading mm's data)
- **Repo-aware headings** `## <repo> vX.Y.Z` — `(repo, tag)` keying resolves the matika/eyerate `v0.0.1–v0.0.3` collision. `parse_entries` returns `(repo, tag)` pairs; `validate_releases` does per-repo bidirectional consistency + duplicate detection keyed on `(repo, tag)`.
- **Repo set** = `{matika.repo} ∪ {applugs[].repo}` (from the recipe, now in mm) ∪ the ahimsa repo. Slug = lowercased last path segment; the same derivation is shared by renderer and validator.
- **Un-derivable fields** (Summary prose, `superseded_by`, PR refs, breadcrumb reasons) live in `release-log.yaml`; the renderer merges them with live tag existence/dates and emits `RELEASES.md` **newest-first**.
- **Commit timing:** **PR-time render** (author edits `release-log.yaml`, renderer regenerates `RELEASES.md`, both committed in the same PR), **validate-only at tag/build time** (no bot push to main). The refresh job **opens a PR** (never pushes to main).

### 6.3 Notes-file convention (unchanged)
Per-version `docs/release-notes/<tag>.md` in each repo; `gh release create "<tag>" --notes-file …`. matika/eyerate notes are notes-only and **link to the mm product release**. Prerelease tags use a templated fallback when the file is absent.

### 6.4 Product manifest / BOM (mm-owned)
Per product version, mm carries a manifest pinning matika / eyerate / ahimsa by **tag AND resolved SHA**. For v0.0.1: matika v0.0.4 / eyerate v0.0.4 / ahimsa v0.0.1, ahimsa's SHA being the exact `main` commit the validated installer was built from. Today `manifests/` holds only `TEMPLATE.yaml`; the first concrete `<version>.yaml` is authored at the #12 cut (§1.3).

### 6.5 BOM `error_registry` block (framework R8 — new)
The #12 BOM gains an **`error_registry`** block carrying the merged error-code registry snapshot **by pointer + sha256** (not inline), with `origins[]` provenance where `origins[].sha == components[].sha`. ahimsa's aggregator writes the authoritative merged artifact next to the renderer at release; the BOM references it. Schema addition + `TEMPLATE.yaml` `error_registry` + the `ARCHITECTURE.md` §6 `components:` dict-vs-list reconcile (Q21) all land in **R8 (manomatika#48)**.

### 6.6 Project add automation (retained)
Add issues to Projects via the **`addProjectV2ItemById` GraphQL mutation** (`gh project item-add` silently no-ops; `gh project item-list` serves stale/paginated data). mm issues join Project #1 via this mutation; the framework runs (R0–R8) are on Project #1, the deferred planning issues (#45/#46/#47) on Project #2.

---

## APPENDIX — SUPERSEDED: old Wave 1–6 orchestration & agent roster

> The original plan sequenced the work as Pre-Execution milestone mutations → **Wave 1** (agents A–D) → **Wave 2** (E/F) → **Wave 3** (G, build.yml) → human QA/tag gates → **Wave 5** (slug canonicalization) → **Wave 6** (docs), with a full agent roster (A–L). That orchestration assumed ahimsa **owned** the recipe, **hosted** the release, and **owned** the audit log; the umbrella was a separate `manomatika/release` repo; slug/recipe canonicalization flowed through ahimsa#35/#38 with tag-gated sequencing; and QA covered the full macOS arm64 + x86_64 + Windows matrix manually.
>
> **All of that is superseded by §0 (architecture) and the current status (§1).** The recipe + audit log + product release + installer move to **mm**; ahimsa narrows to the **engine**; the `manomatika/release` umbrella becomes **mm**; ahimsa#35/#30 are superseded; the build.yml Wave serialization no longer applies; and QA is the **automated installed-artifact gate** across all three platforms + both install arms.
>
> The merged engineering work those waves produced (Node-20 bumps, matika.spec/launcher, the ahimsa build pipeline, dmgbuild/Inno-Setup packaging, #38-early lowercasing, the release-notes engine) is **real and retained**. Only the **ordering/orchestration and the ownership assumptions** are retired.
