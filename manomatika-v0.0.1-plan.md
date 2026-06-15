# ManoMatika v0.0.1 — Execution Plan
**Generated:** 2026-06-02 | **Revised:** 2026-06-09 (architecture redesign — product authority moved to `manomatika/manomatika`); 2026-06-14 (preconditions resolved, phase model added, #1–#3 marked complete); 2026-06-14 (task #4 cc-owned closures moved to Phase-1/Lane-A — see §4 item 19); 2026-06-14 (Lane-A tasks #4–#7 ahimsa-piece marked complete; mm#4, ahimsa#55/#56/#57/#58 merged; Phase 1 + Phase 2 complete)  
**Composition (the blessed triple):** matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1  
**Planner:** Claude Code, read-only investigation

> **2026-06-09 redesign.** The release architecture was redesigned. A new repo `manomatika/manomatika` (**mm** below) is now the **product authority**. `ahimsa` narrows to a **recipe engine**. The authoritative model is **§0**; the authoritative ordered sequence is **§1**. The old Wave 1–6 orchestration and the "RELEASES.md / recipes / hosted release live in ahimsa" model are **superseded** — see §3, §5, §8, and the Appendix for what was retired and why.

### Execution-intent key
- **[AGENT PR]** — cc opens a PR (git worktree); the human reviews and merges every PR.
- **[HUMAN]** — Requires the human; cc cannot substitute (QA on clean machines, all PR merges, repo renames in GitHub Settings, manual cross-repo issue closes, tagging, cutting the product release).
- **[cc MUTATION]** — GitHub state change executed autonomously by cc under standing permission.
- **[COMPLETE]** — Done; recorded for traceability.

---

## 0. CURRENT ARCHITECTURE (authoritative — overrides any contrary statement below)

- The **product** "ManoMatika" = a pinned **triple** of component versions (matika + eyerate + ahimsa). A **release** is the act of blessing one validated triple.
- **`manomatika/manomatika` (mm) = PRODUCT AUTHORITY.** It owns: the **recipes**; the **audit log** (`release-log.yaml` source + generated `RELEASES.md`); the **product release AND the single hosted installer binary**; cross-component **umbrella docs** (`ARCHITECTURE.md` linking down to component docs); the **per-product-version manifest/BOM** (pins each component by **tag AND resolved SHA**); and the **QA gate**.
- **`ahimsa` = RECIPE ENGINE ONLY:** build, validation, release **mechanism**, and the recipe **schema**. It owns **no** recipes, owns **no** audit-log content, and hosts **no** GitHub releases. It builds installers as **transient CI artifacts** via `workflow_dispatch`; it **never** runs `gh release create`. Its docs narrow to the engine's purpose.
- **`matika`, `eyerate` = components.** Self-scoped architecture docs. **Notes-only** releases (no binaries).
- **Release/QA flow:** code complete → component docs finalized → tag matika v0.0.4 + eyerate v0.0.4 (**prereleases, notes-only**) → ahimsa `build.yml` dispatched (`workflow_dispatch`, off main, recipe fetched **from mm**) producing installer **artifacts** (no release) → QA the **macOS x86_64 DMG** artifact → on pass: tag ahimsa v0.0.1, author the mm product manifest, cut the **mm v0.0.1 product release** with the validated DMG attached **there**. The GitHub **prerelease flag is the trust boundary**; the mm product release is the only blessed product.

---

## 1. AUTHORITATIVE EXECUTION SEQUENCE

This 13-item ordered list is the canonical sequence for v0.0.1. It supersedes the old Wave 1–6 orchestration (archived in the Appendix).

1. **Settle the CLAUDE.md staleness guardrail.** Rule: CLAUDE.md never knowingly contains stale info; every factual claim is verified against actual repo state on each edit/regeneration; when unverifiable, omit. **[COMPLETE — executed in parallel.]**
2. **Delete the local `matika v0.0.4-dev.*` tags** (hygiene). **[COMPLETE]** — Remote dev tags removed; matika carries v0.0.1/v0.0.2/v0.0.3 only (verified 2026-06-14 against live GitHub).
3. **Stand up `manomatika/manomatika` (mm).** **[COMPLETE]** — README, CLAUDE.md, `manifests/` directory, and `shell_scripts/` committed to mm (verified 2026-06-14). Add mm issues to **Project #1** via `addProjectV2ItemById` as they are filed.
4. **Relocate the reference-app recipe into mm.** **[COMPLETE]** — mm#4 authored the recipe in mm with canonical lowercase `manomatika/*` slugs; ahimsa#55 retargeted `build.yml` to fetch the recipe from mm and removed the local recipe copy. cc-owned closures executed: manomatika/ahimsa#35 and manomatika/ahimsa#30 closed as superseded; branch `fix/30-org-migration` deleted (local + origin); manomatika/ahimsa#38 closed (both halves resolved — see §4 items 15, 17, 19).
5. **Move the audit log to mm.** **[COMPLETE]** — ahimsa#57 relocated `release-log.yaml` + `RELEASES.md` to mm; wired `GitHubResolver` for live tag queries; retargeted the `refresh-releases-md` job to open PRs against mm. manomatika/ahimsa#49 closed. (Mechanism stays in ahimsa; content lives in mm.)
6. **Retire ahimsa's release responsibility.** **[COMPLETE]** — ahimsa#56 removed the release job and `push: tags: v*` trigger from `build.yml`. ahimsa builds artifacts on demand only (`workflow_dispatch`) and never creates GitHub releases. (manomatika/matika#31 tracked this; CLOSED 2026-06-03; approach superseded — see §4 item 16.)
7. **Docs refactor.** Umbrella `ARCHITECTURE.md` in mm: **[COMPLETE]** (mm#6). Narrowing ahimsa docs/CLAUDE.md to engine scope: **[COMPLETE]** — manomatika/ahimsa#32 closed by ahimsa#58. Stale divergence text removed from ahimsa README + CLAUDE.md and matika/eyerate CLAUDE.md (Lane-A docs pass, 2026-06-14 — see open PRs in each repo). Full docs verification before tagging remains open: **matika#47**, **eyerate#26**. [Phase 1 docs sub-lane — runs in parallel with machinery sub-lane #4→#6→#5; see Execution phases.]
8. **Tag matika v0.0.4 + eyerate v0.0.4** (prereleases, notes-only). The recipe pins from step 4 now resolve.
9. **Dispatch ahimsa `build.yml`** via `workflow_dispatch` off finalized `main` → installer **artifacts, no release**. **Presupposes** ahimsa `main` already contains the full build infra (PyInstaller, dmgbuild, Inno Setup — verified 2026-06-14 against live ahimsa main); step 9 exercises it, does not create it.
10. **QA the macOS x86_64 DMG artifact on Intel hardware** — TC-B suite, smoke-test grade. **arm64 and Windows are out of scope this pass.**
11. **On pass, cut ManoMatika v0.0.1:** tag **ahimsa v0.0.1** at the exact `main` SHA the validated DMG was built from (notes-only); author the **mm product manifest** pinning matika v0.0.4 / eyerate v0.0.4 / ahimsa v0.0.1 by **tag + resolved SHA**; write the mm product release notes; create the **mm v0.0.1 release with the validated x86_64 DMG attached there**. (For v0.0.1 the artifact carry ahimsa-artifact → mm-release-asset is **MANUAL**; automated post-v0.0.1 — see Backlog.)
12. **Regenerate `RELEASES.md`** via the retargeted engine so the audit log records ManoMatika v0.0.1.
13. **Close issues this pass satisfied** (matika#33, ahimsa#16, eyerate#17, ahimsa#33). **Record as DEFERRED — not passed:** arm64 (matika#32, ahimsa#15) and Windows (matika#34, ahimsa#19, eyerate#18 → ahimsa#46).

### Backlog (not in this release — keep noted)
- **POST-v0.0.1 DECISION (2026-06-14): mm release-assembly workflow** — mm will own a workflow that pulls ahimsa's built CI artifacts and publishes them to the mm product release, automating the manual artifact carry in §1 step 11. Division of labor: **ahimsa BUILDS, mm ASSEMBLES + PUBLISHES** as code. New issue to be filed in mm; see §4 item 18.
- **Linux install support** — ahimsa#47 (spike; method unspecified; expected to be the most common post-v0.0.1 target).
- **Signing / notarization** — ahimsa#25.
- **Playwright tests** — matika#23 (deferred to `Playwright (v0.0.5)`; setup — install, config, ~100 MB browser binaries, four hub-session scenarios — is materially larger than the rest of Cleanup & Tooling).
- **Registry epic** — ahimsa#20–24.
- **Tech-debt** — matika#56 (conftest→fixture migration), eyerate#35 (integration conftest sibling-path hardening), eyerate#36 (PR-triggered Python test gate).

### Execution phases

| Phase | Owner | Tasks | Mode |
|---|---|---|---|
| **1 — Lane A** | cc + subagents | Machinery sub-lane (SERIAL): #4 → #6 → #5. Docs sub-lane (parallel with machinery): #7, with the ahimsa-CLAUDE.md piece joining after #4–#6 complete. cc also executes the #4 cc-owned closures: close manomatika/ahimsa#35 + manomatika/ahimsa#30 as superseded, delete `fix/30-org-migration` (local + origin), and close manomatika/ahimsa#38 once both its halves resolve (see §4 item 19). cc opens PRs, never merges. **COMPLETE 2026-06-14** — mm#4, ahimsa#55/#56/#57/#58 merged; cc-owned closures executed; task #7 docs pass completed. | [COMPLETE] |
| **2 — Merge & close** | Pat | Review/merge Lane A PRs in dependency order. Manually close only the cross-repo `Closes manomatika/<repo>#N` refs that don't auto-fire on merge. Local cleanup (sync, prune, confirm clean). manomatika/ahimsa#35/#30/#38 and `fix/30-org-migration` are NOT here — done by cc in Phase 1 (see §4 item 19). **Gate before Phase 3.** **COMPLETE 2026-06-14.** | [COMPLETE] |
| **3 — Pre-staging** | cc | Draft mm v0.0.1 release notes + author mm product manifest skeleton. Readies §1 step 11 inputs; does not shorten Lane B. | [AGENT PR] |
| **4 — Lane B** | Pat + cc | Hard serial chain: #8 → #9 → #10 → #11 → #12 → #13. Step #10 manual on hardware; gated by Pat throughout. | [HUMAN]-gated |

---

## 2. SCOPE SUMMARY

### In-Scope Milestones (informational due dates; not scheduling constraints)

| Repo | Milestone | Due (informational) | Open / Total | Rollup Status |
|---|---|---|---|---|
| matika | Cleanup & Tooling (v0.0.4) | 2026-06-02 | 1 / 7 | In Progress |
| matika | Deployment & Install (v0.0.4) | 2026-06-15 | 2 / 10 | In Progress (2 open = HUMAN QA macOS #32/#33; Windows #34 Deferred → ahimsa#46) |
| matika | Documentation & Release Readiness (v0.0.4) | 2026-06-30 | 1 / 1 | Todo |
| eyerate | Cleanup & Tooling (v0.0.4) | 2026-06-02 | 0 / 4 | Done |
| eyerate | Deployment & Install (v0.0.4) | 2026-06-15 | 1 / 4 | In Progress (1 open = HUMAN QA macOS #17; Windows #18 Deferred → ahimsa#46) |
| eyerate | Documentation & Release Readiness (v0.0.4) | 2026-06-30 | 1 / 1 | Todo |
| ahimsa | Cleanup & Tooling (v0.0.1) | 2026-06-02 | 0 / 4 | Done (ahimsa#30 closed as superseded — recipe relocated to mm; see §1 step 4) |
| ahimsa | Deployment & Install (v0.0.1) | 2026-06-15 | 2 / 12 | In Progress (2 open = HUMAN QA macOS #15/#16; ahimsa#49 closed by PR #57; Windows #19 Deferred → ahimsa#46) |
| ahimsa | QA & System Test (v0.0.1) | 2026-06-28 | 0 / 1 | Done — test plan merged via PR #45 (#33 closed); the macOS x86_64 QA matrix is now executed against the mm QA gate (§0) |
| ahimsa | Documentation & Release Readiness (v0.0.1) | 2026-06-30 | 0 / 2 | Done (ahimsa#38 closed as superseded; ahimsa#32 closed by PR #58) |

### Out-of-Scope Milestones (confirmed null due_on — not in v0.0.1 cycle)
- eyerate: `Planning (v0.0.5)` — eyerate#20 (sync_version investigation, "not blocking v0.0.4"); eyerate#35 (integration-test conftest sibling-path hardening) + eyerate#36 (PR-triggered Python test gate) — both filed 2026-06-04, manomatika v0.0.2 cycle, **NOT in v0.0.1 scope**.
- ahimsa: `Registry (v0.0.2)`, `Signing & Distribution (v0.0.2)`, `Planning (v0.0.2)` — v0.0.2 scope; not in v0.0.1 cycle.

### Deferred from v0.0.1
- manomatika/matika#23 (tech-debt: Playwright test) — deferred to `Playwright (v0.0.5)`.
- **Windows 11 hardware QA** (matika#34, ahimsa#19, eyerate#18) — closed as **Deferred**, not passed: no Windows test hardware. Tracked next cycle in ahimsa#46 (`Planning (v0.0.2)`).
- **macOS arm64 hardware QA** (matika#32, ahimsa#15) — **Deferred** this pass; only x86_64 DMG is QA'd for v0.0.1 (§1 step 10).

---

### Full Issue Inventory by Repo

> **Architecture-redesign note (2026-06-09):** the status text below was captured against the old model in which the recipe, the audit log (`RELEASES.md`/`release-log.yaml`), and the hosted release all lived in **ahimsa**. Under the current model (§0) the recipe, the audit-log **content**, the product release, and the installer binary live in **mm**; ahimsa keeps only the rendering **engine** and builds installer **artifacts**. Where a row references ahimsa owning the recipe / log / release, treat it as superseded per §1 steps 4–6. Issue *status* (Done/Todo/Deferred) is unchanged.

**Status snapshot: 2026-06-04 (post-release-notes-build + #38-early + CLAUDE.md refresh + lowercasing-pass-merged + board-backfill), derived from live GitHub; issue states re-verified 2026-06-14 (see §4 items 15–18).** Re-query with `gh issue list --repo manomatika/<repo> --milestone "<name>" --state all` for current state. This snapshot reflects: release-notes engine BUILT + merged (PR-1 ahimsa#50, PR-2 matika#58, PR-3 eyerate#32; ahimsa#48 CLOSED; ahimsa#49 OPEN — **now retargeted to render mm's log per §1 step 5**); #38-early DONE (matika#59, eyerate#33, ahimsa#51); all three CLAUDE.md refreshed (ahimsa#52, matika#60, eyerate#34, docs-only). Milestone rollups unchanged this run. eyerate test suite verified green on main (56/56) — no QA blocker (see §5 R-EYERATE-TESTS). Windows hardware QA deferred (matika#34/ahimsa#19/eyerate#18 → ahimsa#46); remaining open v0.0.1 QA is the macOS x86_64 gate (matika#33, ahimsa#16, eyerate#17 — arm64 #32/#15 now deferred per §1 step 13); Linux spike = ahimsa#47. **2026-06-04 session:** filesystem lowercasing pass MERGED (matika#61, eyerate#37, ahimsa#53) — manual-task PRs closing no tracked milestone issue, so rollups unchanged; Project #1 brought current at **58 items** (GraphQL `totalCount`) via `addProjectV2ItemById`; new eyerate#35/#36 filed on `Planning (v0.0.5)`; Project auto-add toggle **retired** as not feasible on GitHub Free (see §8.6).

All Project statuses confirmed via GraphQL against Project #1 (ManoMatika Roadmap) — **58 items** (verified via ProjectV2 GraphQL `totalCount`, 2026-06-04; `gh project item-list` serves stale/paginated data and is not used for counts). The new **mm** repo's own issues join Project #1 via `addProjectV2ItemById` as mm is stood up (§1 step 3).

#### matika — Cleanup & Tooling (v0.0.4)

| Issue | Title | Status |
|---|---|---|
| manomatika/matika#53 | Bump Node-based Actions ahead of Node-20 runtime deprecation | Done |
| manomatika/matika#43 | Add minimal in-repo test fixture applug for framework tests | Done |
| manomatika/matika#40 | Log-cleanup crashes parsing filenames without a YYYYMMDD date | Done |
| manomatika/matika#56 | tech-debt: migrate tests from conftest.py session-scoped mock_plugin to minimal_applug fixture | Todo — **non-release-blocking; backlog (§1)** |
| ~~manomatika/matika#23~~ | ~~tech-debt: Playwright test~~ | Deferred → Playwright (v0.0.5) |

#### matika — Deployment & Install (v0.0.4)

| Issue | Title | Status | Code Lives In |
|---|---|---|---|
| manomatika/matika#25 | feat: implement recipe validator in ahimsa | Done — closed after ahimsa PR #43 merged | **ahimsa (engine)** |
| manomatika/matika#26 | feat: ahimsa build pipeline — clone matika and applugs at pinned versions | Done — closed after ahimsa PR #43 merged | **ahimsa (engine)** |
| manomatika/matika#27 | feat: update matika.spec — remove RateEye deps, add plugin assets, wire version and icon | Done | matika |
| manomatika/matika#28 | feat: update launcher.py — first-run init, SECRET_KEY, migrations, plugin extraction | Done | matika |
| manomatika/matika#29 | feat: implement dmgbuild for macOS arm64 and x86_64 | Done — human-closed after ahimsa PR #44 merged | **ahimsa (engine)** |
| manomatika/matika#30 | feat: implement Inno Setup Windows installer | Done — human-closed after ahimsa PR #44 merged | **ahimsa (engine)** |
| manomatika/matika#31 | feat: ahimsa release job — create GitHub release with DMG and EXE artifacts | Done historically — **SUPERSEDED:** under §0 ahimsa hosts no release; the release job is retired (§1 step 6) and the product release moves to **mm** | **was ahimsa → now mm** |
| manomatika/matika#32 | qa: test DMG install on clean macOS arm64 | **Deferred** this pass (§1 step 13) — **HUMAN** | **HUMAN** |
| manomatika/matika#33 | qa: test DMG install on clean macOS x86_64 | Todo — **HUMAN** (the v0.0.1 QA gate, §1 step 10) | **HUMAN** |
| manomatika/matika#34 | qa: test EXE install on clean Windows 11 | Deferred — no Windows hardware; closed-as-deferred → manomatika/ahimsa#46 | **HUMAN** |

> **Cross-repo tracking note:** matika#25, #26, #29, #30 describe engine work implemented in **ahimsa**. ahimsa PRs include `References manomatika/matika#N` — a cross-reference that does NOT auto-close the matika issue; the human manually closes these tracking issues after the corresponding ahimsa PRs merge. matika#31 is superseded (see row above), not satisfied by an ahimsa release.

#### matika — Documentation & Release Readiness (v0.0.4)

| Issue | Title | Status |
|---|---|---|
| manomatika/matika#47 | docs: verify and update all documentation for release | Todo — finalize **before** matika is tagged (§1 step 7) |

---

#### eyerate — Cleanup & Tooling (v0.0.4)

| Issue | Title | Status |
|---|---|---|
| manomatika/eyerate#29 | Bump Node-based Actions ahead of Node-20 runtime deprecation | Done |
| manomatika/eyerate#25 | docs: fix USER_GUIDE.md menu name — application menu renders as 'EyeRate', not 'Activities' | Done |
| manomatika/eyerate#19 | docs: update DEVELOPER_GUIDE.md with *_menus.json schema | Done |

#### eyerate — Deployment & Install (v0.0.4)

| Issue | Title | Status |
|---|---|---|
| manomatika/eyerate#15 | feat: verify eyerate compatibility with Matika 0.0.4 | Done |
| manomatika/eyerate#16 | feat: verify eyerate assets bundle correctly in PyInstaller | Done |
| manomatika/eyerate#17 | qa: test eyerate Securities page in DMG install on macOS | Todo — **HUMAN** (x86_64 gate, §1 step 10) |
| manomatika/eyerate#18 | qa: test eyerate Securities page in EXE install on Windows | Deferred — no Windows hardware; closed-as-deferred → manomatika/ahimsa#46 |

#### eyerate — Documentation & Release Readiness (v0.0.4)

| Issue | Title | Status |
|---|---|---|
| manomatika/eyerate#26 | docs: verify and update all documentation for release | Todo — finalize **before** eyerate is tagged (§1 step 7) |

---

#### ahimsa — Cleanup & Tooling (v0.0.1)

| Issue | Title | Status |
|---|---|---|
| manomatika/ahimsa#41 | Bump Node-based Actions ahead of Node-20 runtime deprecation | Done |
| manomatika/ahimsa#30 | update reference-app recipe + CLAUDE.md from pjtallman/* to manomatika/* org URLs | **SUPERSEDED** — the recipe **leaves ahimsa for mm** (§1 step 4); close as superseded; delete PR #35 / branch `fix/30-org-migration` |

> **ahimsa#30 / PR #35 (`fix/30-org-migration`):** under the old model this PR org-migrated + lowercased the recipe **inside ahimsa** and was merge-gated on the v0.0.4 tags. Under §0 the recipe is **relocated into mm** with canonical `manomatika/*` slugs (§1 step 4), so #30 and #35 are **superseded, not merged**. The canonical-recipe work happens in mm's recipe relocation.

#### ahimsa — Deployment & Install (v0.0.1)

| Issue | Title | Status |
|---|---|---|
| manomatika/ahimsa#9 | build.yml: clone matika at pinned version tag | Done |
| manomatika/ahimsa#10 | build.yml: clone applugs into plugins/ at pinned version tags | Done |
| manomatika/ahimsa#13 | Implement dmgbuild for macOS arm64 | Done — auto-closed by PR #44 |
| manomatika/ahimsa#14 | Implement dmgbuild for macOS x86_64 | Done — auto-closed by PR #44 |
| manomatika/ahimsa#15 | Test DMG install on clean macOS arm64 | **Deferred** this pass (§1 step 13) — **HUMAN** |
| manomatika/ahimsa#16 | Test DMG install on clean macOS x86_64 | Todo — **HUMAN** (the v0.0.1 QA gate, §1 step 10) |
| manomatika/ahimsa#17 | Update Inno Setup script for directory bundle output from PyInstaller | Done — auto-closed by PR #44 |
| manomatika/ahimsa#18 | build.yml: Windows build job end to end | Done — auto-closed by PR #44 |
| manomatika/ahimsa#19 | Test EXE install on clean Windows 11 | Deferred — no Windows hardware; closed-as-deferred → manomatika/ahimsa#46 |
| manomatika/ahimsa#26 | release notes: document unsigned-installer limitation | Done — auto-closed by PR #44 (the unsigned-installer prose now lives in notes content; the product release that carries it is mm's, §0) |
| manomatika/ahimsa#48 | Release-notes generation system: file-based per-repo notes + umbrella | Done — closed by PR #50. **Note:** the audit-log *content* this built in ahimsa **relocates to mm** (§1 step 5); ahimsa keeps the rendering engine only |
| manomatika/ahimsa#49 | Wire live cross-repo release query against canonicalized refs (completes stubbed regenerator) | **Done** — closed by ahimsa PR #57 (audit log moved to mm; `GitHubResolver` wired for live tag queries; `refresh-releases-md` job retargeted to mm) |

> **Overlap with matika D&I tracking issues:** matika#26 ⊇ ahimsa#9+#10; matika#29 = ahimsa#13+#14; matika#30 = ahimsa#17+#18. Same physical engine work tracked in both repos; ahimsa PRs reference but do not auto-close the matika issues (manual close required).

#### ahimsa — QA & System Test (v0.0.1)

| Issue | Title | Status |
|---|---|---|
| manomatika/ahimsa#33 | qa: end-to-end system test of ManoMatika v0.0.1 | Done — test plan merged via PR #45; the human executes the **macOS x86_64** matrix against the **mm QA gate** (§0, §1 step 10) and signs off |

#### ahimsa — Documentation & Release Readiness (v0.0.1)

| Issue | Title | Status |
|---|---|---|
| manomatika/ahimsa#38 | Canonicalize GitHub repo slugs to lowercase (Matika → matika, EyeRate → eyerate) | **#38-early DONE** (matika#59, eyerate#33, ahimsa#51 — non-recipe slug refs lowercased). The recipe portion is **superseded in ahimsa**: the recipe is authored fresh in **mm** with canonical lowercase slugs (§1 step 4), so there is no remaining ahimsa recipe.json edit |
| manomatika/ahimsa#32 | docs: verify and update all documentation for release | **Done** — closed by ahimsa PR #58 (CLAUDE.md narrowed to engine-only scope; migration status resolved block added) |

---

## 3. MILESTONE RENAME MAP

> **Status:** this section is preserved as the authoritative record of the milestone naming convention and the closed-milestone history. The open-milestone renames were the pre-execution mutations; the convention (`Name (vX.Y.Z)`) and the closed-milestone records remain valid under the redesign.

### Versioning rule applied
- **Current-cycle milestones** → repo's current release version: matika→v0.0.4, eyerate→v0.0.4, ahimsa→v0.0.1
- **Planning milestones** (forward-looking, terminal in cycle) → repo's next version: matika→v0.0.5, eyerate→v0.0.5, ahimsa→v0.0.2
- GitHub milestone renames preserve all attached issues (non-destructive)
- Closed milestones: historical record only — **NO ACTION**. The naming convention applies to current and future milestones only.

### Open milestones (actionable renames)

| Repo | MS# | Current Name | Proposed Name | Action | Rationale |
|---|---|---|---|---|---|
| matika | #8 | Cleanup & Tooling | Cleanup & Tooling (v0.0.4) | **RENAME** | Current-cycle; matika → v0.0.4 |
| matika | #7 | Deployment & Install | Deployment & Install (v0.0.4) | **RENAME** | Current-cycle; matika → v0.0.4 |
| matika | #9 | Documentation & Release Readiness | Documentation & Release Readiness (v0.0.4) | **RENAME** | Current-cycle; matika → v0.0.4 |
| matika | — | (none) | Playwright (v0.0.5) | **CREATE** | matika has no planning milestone; next version → v0.0.5 (holds matika#23) |
| eyerate | #11 | Cleanup & Tooling | Cleanup & Tooling (v0.0.4) | **RENAME** | Current-cycle; eyerate → v0.0.4 |
| eyerate | #10 | Deployment & Install | Deployment & Install (v0.0.4) | **RENAME** | Current-cycle; eyerate → v0.0.4 |
| eyerate | #13 | Documentation & Release Readiness | Documentation & Release Readiness (v0.0.4) | **RENAME** | Current-cycle; eyerate → v0.0.4 |
| eyerate | #12 | v0.0.5 Planning | Planning (v0.0.5) | **RENAME** | Planning milestone; eyerate → next → v0.0.5 |
| ahimsa | #8 | Cleanup & Tooling | Cleanup & Tooling (v0.0.1) | **RENAME** | Current-cycle; ahimsa → v0.0.1 |
| ahimsa | #7 | Deployment & Install | Deployment & Install (v0.0.1) | **RENAME** | Current-cycle; ahimsa → v0.0.1 |
| ahimsa | #13 | QA & System Test | QA & System Test (v0.0.1) | **RENAME** | Current-cycle; ahimsa → v0.0.1 |
| ahimsa | #12 | Documentation & Release Readiness | Documentation & Release Readiness (v0.0.1) | **RENAME** | Current-cycle; ahimsa → v0.0.1 |
| ahimsa | #11 | v0.0.5 Planning | Planning (v0.0.2) | **RENAME** | Planning for next cycle; ahimsa → next → v0.0.2 |
| ahimsa | #9 | Registry | Registry (v0.0.2) | **RENAME** | Out of v0.0.1 scope; classified as v0.0.2 |
| ahimsa | #10 | Signing & Distribution | Signing & Distribution (v0.0.2) | **RENAME** | Out of v0.0.1 scope; classified as v0.0.2 |

### Closed milestones (historical record — NO ACTION)

The naming convention applies to current and future milestones only. Closed milestones are left exactly as they are; the table below is an informational record. No renames will be performed. This explicitly includes eyerate closed #9 `v0.0.5 — Cleanup` — left as-is, not renamed, not deleted.

| Repo | MS# | Current Name | Notes |
|---|---|---|---|
| matika | #2 | Milestone 1 - Initial refactor of matika out of rateeye | Historical record — no action. |
| matika | #3 | Milestone 2 - Refactor menu architecture | Historical record — no action. |
| matika | #4 | 0.0.2 — Compatibility Contract | Historical record — no action. |
| matika | #5 | 0.0.3 — Next Release | Historical record — no action. |
| matika | #6 | 0.0.4 — Deployment and Install | Historical record — no action. |
| eyerate | #2 | Milestone 1 - Initial refactor of eyerate out of rateeye | Historical record — no action. |
| eyerate | #3 | Milestone 2 - Refactor menu architecture | Historical record — no action. |
| eyerate | #6 | 0.0.2 — Compatibility Contract | Historical record — no action. |
| eyerate | #7 | 0.0.3 — Next Release | Historical record — no action. |
| eyerate | #8 | 0.0.4 — Deployment and Install | Historical record — no action. |
| eyerate | #9 | v0.0.5 — Cleanup | Historical record — no action (not renamed, not deleted). |
| ahimsa | #1 | Recipe System Foundation | Historical record — no action. |
| ahimsa | #2 | Build Pipeline — macOS | Historical record — no action. |
| ahimsa | #3 | Build Pipeline — Windows | Historical record — no action. |
| ahimsa | #4 | Registry Foundation | Historical record — no action. |
| ahimsa | #5 | v0.0.5 — Design | Historical record — no action. |
| ahimsa | #6 | M5 — Code Signing & Distribution Security | Historical record — no action. |

**Summary:** 15 open-milestone renames/creates; 0 flagged rows. Closed milestones: no action (historical record only).

---

## 4. RESOLVED DECISIONS

Decisions recorded for traceability. Items updated for the 2026-06-09 redesign are marked.

1. **Registry and Signing & Distribution milestone versions:** both ahimsa milestones classified as v0.0.2 — `Registry (v0.0.2)` and `Signing & Distribution (v0.0.2)`. Roadmap placement decided during ahimsa `Planning (v0.0.2)`.

2. **Closed milestone naming:** convention applies to current and future milestones only. All closed milestones — including eyerate #9 `v0.0.5 — Cleanup` — are left exactly as-is (not renamed, not deleted). Historical record; no action. **(Valid.)**

3. **ahimsa#33 test plan author:** agent-H wrote the E2E system test plan (merged via PR #45). The human executes the macOS **x86_64** matrix against the **mm QA gate** (§0) and closes the issue after sign-off. **(Updated: QA gate is mm-owned; arm64/Windows deferred.)**

4. **Repo-slug canonicalization & rename sequencing — SUPERSEDED by the redesign.** Old plan: tag v0.0.4 → merge ahimsa#35 (recipe org-migration in ahimsa) → rename repos. **Now:** the GitHub Settings renames + non-recipe lowercasing (#38-early) are **DONE** and were always tag-independent (the resolver `_canonicalize_repo` is case-insensitive + redirect-aware). The **recipe** is no longer org-migrated inside ahimsa — it is **authored fresh in mm** with canonical `manomatika/*` slugs (§1 step 4), so ahimsa#35/#30 are superseded, not sequenced. There is no remaining tag-gated recipe.json edit in ahimsa.

5. **Cross-repo work tracking:** ahimsa engine PRs that satisfy matika tracking issues use `References` (not `Closes`); the human manually closes the matika issues after merge. **(Valid — see §2 cross-repo notes.)**

6. **No outstanding open questions** on the v0.0.1 *component* work. The open design surface introduced by the redesign (mm standup, recipe + log relocation, engine retarget, release retirement) is captured as the §1 sequence.

7. **matika#43 conftest migration split out (post-plan):** matika#43 (PR #54) deferred migrating existing tests off conftest.py's session-scoped mock_plugin. Captured as **matika#56** (`Cleanup & Tooling (v0.0.4)`); non-release-blocking; backlog. **(Valid.)**

8. **matika test-DB-directory fix (post-plan):** a clean-checkout bug in matika's `tests/conftest.py` (absolute SQLite `DATABASE_URL` under `data/` with no `os.makedirs`) surfaced when eyerate's integration tier ran in a fresh worktree. Fixed in matika PR #57. eyerate's defensive `os.makedirs("data")` workaround (eyerate PR #31) is **retained** (annotated for removal once #57 propagates). Non-release-blocking. **(Valid.)**

9. **Windows QA deferral + Linux spike + release-notes annotation (post-plan, 2026-06-03):**
   - **Windows hardware QA deferred:** no Windows 11 test hardware. The Windows EXE still ships in v0.0.4 (CI-built/build-validated, **not** hardware-QA'd). matika#34, ahimsa#19, eyerate#18 closed as **Deferred** → tracker **ahimsa#46** (`Planning (v0.0.2)`).
   - **Linux install support spike:** **ahimsa#47** (`Planning (v0.0.2)`) — does not yet exist; flagged priority as the expected most-common post-v0.0.1 target.
   - **Unsigned-installer / Windows-untested annotation:** the unsigned-installer limitation and any "Windows built-but-not-hardware-QA'd" note are now carried in **notes content**, surfaced on the **mm product release** (§0), not hardcoded in a build-workflow heredoc. The honest record is the test plan + ahimsa#46 + the deferred-close trail.

10. **Release-notes generation system — IMPLEMENTED (2026-06-03), CONTENT NOW RELOCATING TO mm:** three PRs merged (ahimsa#50 `beacc36`, matika#58 `abd1bca`, eyerate#32 `8b1992f`) — per-repo notes files + tag-triggered notes-only releases for matika/eyerate; a repo-aware `(repo, tag)` validator; `release-log.yaml` seeded; renderer + `StubTagResolver`; `workflow_dispatch` refresh job. **Redesign (§1 steps 5–6):** the audit-log **content** (`release-log.yaml` + `RELEASES.md`) **relocates from ahimsa to mm**; ahimsa retains only the rendering **engine**, retargeted to render mm's log; ahimsa's **release job is retired**. See §6.

11. **#38-early DONE (2026-06-04):** non-recipe GitHub slug refs lowercased across all three repos — matika #59 (`8a86598`), eyerate #33 (`27b952f`), ahimsa #51 (`f01daaf`). The recipe portion is superseded (recipe authored fresh in mm — item 4). **(Valid.)**

12. **Lowercase install/deployment directory policy (decided + EXECUTED 2026-06-04):** install/deployment uses **lowercase** directory names. **DONE:** matika#61 (runtime app-data dir `~/Matika/`→`~/matika/` across `paths.py` + both `launcher.py` literals + the pinning test, plus log filenames `Matika.log`/`test_Matika.log`→lowercase and their retention-map keys; full matika suite 318 passed), eyerate#37 (`scripts/milestone_tasks.yaml` `~/Matika/plugins/`→`~/matika/plugins/`), ahimsa#53 (v0.0.1 QA-doc paths). The policy **does** apply to the live app-data dir. App-bundle/installer names (`Matika.app`, `Matika-<ver>.exe/.app`, `DefaultDirName …\Matika`) deliberately stay **capitalized** as proper nouns. All manual-task PRs; rollups unchanged. **(Valid — preserved.)**

13. **CLAUDE.md updated for release-notes architecture (2026-06-04):** all three CLAUDE.md files brought current with the shipped release-notes system — ahimsa #52 (`6e01da7`), matika #60 (`4f570cf`), eyerate #34 (`d2f1998`). **Redesign follow-up (§1 step 7):** ahimsa's CLAUDE.md narrows to the **engine**; the umbrella architecture moves to **mm's** `ARCHITECTURE.md`; matika/eyerate docs are re-verified before tagging. The §1-step-1 staleness guardrail governs every CLAUDE.md edit/regeneration.

14. **eyerate test-suite status — VERIFIED GREEN, no QA blocker (2026-06-04):** the full suite passes **56/56** with the correct environment (`PYTHONPATH=src:../matika/src`, eyerate beside the matika clone). The reported "18 failed + 27 errors" was a **setup artifact** — the integration tier `exec_module`s matika's `conftest.py` via a sibling-clone relative path that 404s from a non-sibling location, erroring at collection. **Not a QA blocker.** Lower-severity follow-ups in §5 R-EYERATE-TESTS. **(Valid.)**

15. **`fix/30-org-migration` precondition resolved (2026-06-14):** confirmed SAFE to delete branch `fix/30-org-migration` and close ahimsa#30 and ahimsa#35 as superseded. The branch carries exactly one commit (2026-05-30) changing only `recipes/reference-app/recipe.json` and `CLAUDE.md` (4 URL lines: pjtallman/* → manomatika/*). That work is entirely superseded by authoring the recipe fresh in mm (§1 step 4). No unique work would be orphaned.

16. **manomatika/matika#31 closed + superseded (2026-06-14):** manomatika/matika#31 ("feat: ahimsa release job — create GitHub release with DMG and EXE artifacts") was CLOSED manually 2026-06-03. It tracked implementing the ahimsa release job; that approach is superseded by §1 step 6 (retire ahimsa's release responsibility) and the mm product release (§0). No further action needed; recorded for the audit trail.

17. **ahimsa#38 scope split (2026-06-14):** ahimsa#38 has two portions. **(a) Recipe-URL-casing sub-scope** — updating recipe.json URLs from `manomatika/Matika` → `manomatika/matika` inside ahimsa — is SUPERSEDED: the recipe leaves ahimsa for mm (§1 step 4), so there is no recipe.json in ahimsa to update. **(b) Non-recipe slug-ref scope** — slug refs in ahimsa `build.yml`, `CLAUDE.md`, `README`, local remotes — is FOLDED INTO §1 step 4. ahimsa#38 closes when both portions resolve.

18. **POST-v0.0.1 ARCHITECTURAL DECISION (2026-06-14): mm release-assembly workflow.** mm will own a workflow that pulls ahimsa's built CI artifacts and publishes them to the mm product release, automating the manual artifact carry described in §1 step 11. Division of labor becomes **ahimsa BUILDS, mm ASSEMBLES + PUBLISHES** as code, not a manual step. A new issue to be filed in mm. Not in v0.0.1 scope; see Backlog in §1.

19. **cc-owned closures for task #4 (2026-06-14).** Issue/PR closures and branch deletion tied to task #4 are cc-owned as part of Phase-1/Lane-A work — not Pat's Phase-2 browser cleanup. cc owns, as part of task #4: closing manomatika/ahimsa#35 and manomatika/ahimsa#30 as superseded **[cc MUTATION]**; deleting branch `fix/30-org-migration` (local + origin) **[cc MUTATION]**; and closing manomatika/ahimsa#38 **[cc MUTATION]** once both its halves resolve — its recipe-URL sub-scope is superseded (the recipe leaves ahimsa for mm), its non-recipe slug scope is done within task #4. Correspondingly, Phase 2 (Pat) no longer includes manomatika/ahimsa#35/#30/#38 or `fix/30-org-migration`. Phase 2 now covers only: reviewing/merging Lane A PRs in dependency order, manually closing the cross-repo `Closes manomatika/<repo>#N` refs that don't auto-fire on merge, and local cleanup (sync, prune, confirm clean).

---

## 5. RISKS AND GATES

### Release gates (current model)

**Gate 1 — component prerelease tags exist:** matika v0.0.4 and eyerate v0.0.4 (both **prereleases, notes-only**) must be tagged before the ahimsa `build.yml` dispatch can resolve the recipe (now fetched **from mm**, pinning those tags). The recipe's `applug.json@v0.0.4` fetch 404s until the tags exist (§1 step 8 precedes step 9).

**Gate 2 — QA sign-off on the x86_64 DMG artifact:** the macOS **x86_64** DMG **artifact** must pass the mm QA gate (TC-B, smoke-grade, Intel hardware) before any product release is cut. arm64 and Windows are **deferred**, not gating (§1 steps 10, 13).

**Gate 3 — ahimsa tagged at the validated SHA:** ahimsa v0.0.1 is tagged at the **exact `main` SHA the validated DMG was built from**, and the mm product manifest pins all three components by **tag + resolved SHA** before the mm v0.0.1 release is cut (§1 step 11).

**Trust boundary:** the GitHub **prerelease flag** distinguishes unblessed component tags from the blessed product. The **mm v0.0.1 release is the only blessed product**; it carries the validated DMG.

### Risks

**R-RECIPE-RELOCATION — recipe moves out of ahimsa into mm (§1 step 4):** ahimsa `build.yml` must be repointed to fetch the recipe **from mm**; the canonical lowercase `manomatika/*` slugs are authored in mm's copy (not migrated via ahimsa#35). Verify the build resolves the mm-hosted recipe before tagging. ahimsa#35/#30 are superseded — close them so they don't get merged by habit; delete `fix/30-org-migration`.

**R-ENGINE-RETARGET — audit-log content moves to mm, engine stays in ahimsa (§1 step 5):** the renderer, the live cross-repo query (ahimsa#49), and the `refresh-releases-md` job must be retargeted to read/write **mm's** `release-log.yaml`/`RELEASES.md`. Risk: renderer and validator must agree on the repo-set derivation and `(repo, tag)` heading grammar across the relocation, or a render can produce a `RELEASES.md` the validator later rejects. Keep slug-derivation + heading grammar in one shared module.

**R-RELEASE-RETIREMENT — ahimsa must stop hosting releases (§1 step 6):** remove the release job **and** the self-`v*`-tag build trigger; ahimsa builds artifacts on `workflow_dispatch` only. Risk: a leftover tag-triggered path could publish an ahimsa release and bypass the mm trust boundary. Audit `build.yml` triggers after the change; the only blessed release is mm's.

**R-CROSS-REPO-CLOSE — closing keywords don't cross repos:** `Closes`/`Fixes` in a PR body only auto-close issues **in the same repo**. ahimsa engine PRs referencing matika issues create a hyperlink only; the human must manually close matika#25, #26, #29, #30 after the corresponding ahimsa PRs merge. matika#31 is superseded (not closed by an ahimsa release).

**R-UNSIGNED-INSTALLER — QA friction:** installers are unsigned. macOS Gatekeeper blocks the DMG ("can't be opened because Apple cannot check it"); Windows SmartScreen warns. QA must right-click → Open (macOS). The limitation is documented in the notes content carried on the mm product release. Signing/notarization is backlog (ahimsa#25).

**R-EYERATE-TESTS — no PR-triggered Python gate (hardening, NOT a QA blocker):** eyerate's only PR-triggered workflow is `check-compiled-assets.yml`; the pytest suite (56 tests) runs **only locally** — a real Python regression could merge unnoticed. The suite is **green on main (56/56, 2026-06-04)**, so eyerate#17 QA is **not blocked**. Mitigations: run the full suite locally before every eyerate merge (`PYTHONPATH=src:../matika/src python -m pytest tests/`); add a Python-test CI job (eyerate#36, backlog). The integration tier's sibling-clone path-sensitivity (eyerate#35) is documented in eyerate's CLAUDE.md.

**R-NODE-20 — action version pins (resolved historically):** matika#53, eyerate#29, ahimsa#41 bumped Node-based actions to then-current non-deprecated majors. Done; noted for traceability.

---

## 6. AUDIT LOG + RELEASE-NOTES ENGINE — log owned by **mm**, mechanism in **ahimsa**

> **Status (2026-06-09 redesign).** The release-notes / audit system was built in ahimsa (2026-06-03, §4 item 10). The redesign **reverses the "RELEASES.md → ahimsa" relocation**: the audit log's **content** (`release-log.yaml` source + generated `RELEASES.md`) lives in **mm**. ahimsa retains only the **rendering engine** (validator + renderer + cross-repo query + refresh job), retargeted to render mm's log from mm-hosted data. The umbrella is now **mm itself** (full product authority), **not** a separate `manomatika/release` notes repo.

### 6.1 Ownership split (authoritative)
- **mm owns the content:** `release-log.yaml` (human source of truth), the generated `RELEASES.md` (audit log), the **product release notes**, the **product manifest/BOM** (per product version: each component by **tag + resolved SHA**), and the umbrella **`ARCHITECTURE.md`**. mm also hosts the **product release** and the **single installer binary**.
- **ahimsa owns the mechanism:** the repo-aware validator, the renderer, the **live cross-repo tag query (ahimsa#49)**, and the **`workflow_dispatch` refresh** job. These **read mm's `release-log.yaml` and write/validate mm's `RELEASES.md`**. ahimsa owns no log content and hosts no release.
- **matika / eyerate:** **notes-only** releases (per-repo `docs/release-notes/<tag>.md`) that link to the **mm product release** for installers. They never attach binaries.

### 6.2 What the redesign changes from the as-built (ahimsa-hosted) system
1. **Relocate** `release-log.yaml` + `RELEASES.md` from ahimsa → **mm** (§1 step 5). matika's 6 historical entries (already migrated into `release-log.yaml`) move with it; git history in both repos preserves the trail.
2. **Retarget** the engine — ahimsa#49 live query + the refresh job — to operate on **mm-hosted data** (§1 step 5).
3. **Retire** ahimsa's release job + self-`v*`-tag trigger (§1 step 6); ahimsa builds artifacts on demand only.
4. **Relocate** the recipe ahimsa → mm (§1 step 4); `build.yml` fetches the recipe **from mm**; ahimsa#35/#30 superseded.
5. **Umbrella:** the cross-component umbrella is **mm's `ARCHITECTURE.md`** + the mm product release notes — **not** a `manomatika/release` repo (the old Q6/Q7 umbrella is superseded).

### 6.3 Validator / renderer design (retained, now reading mm's data)
- **Repo-aware headings** `## <repo> vX.Y.Z` (e.g. `## matika v0.0.1`, `## eyerate v0.0.1`, `## ahimsa v0.0.1`) — `(repo, tag)` keying resolves the matika/eyerate `v0.0.1–v0.0.3` collision. `_HEADING_RE` captures two groups (repo slug + tag); `parse_entries` returns `(repo, tag)` pairs; `validate_releases` does per-repo bidirectional consistency + duplicate detection keyed on `(repo, tag)`.
- **Repo set** = `{matika.repo} ∪ {applugs[].repo}` (from the recipe, **now in mm**) ∪ the ahimsa repo (for ahimsa's own tags). Slug = lowercased last path segment of the repo spec; the same derivation is shared by renderer and validator.
- **Un-derivable fields** (human Summary prose, `superseded_by` nuance, PRs refs, breadcrumb reasons) live in `release-log.yaml`; the renderer merges them with live tag existence/dates and emits `RELEASES.md` **newest-first**. A live tag with no YAML record → templated placeholder + warning.
- **Commit timing:** **PR-time render** (author edits `release-log.yaml`, renderer regenerates `RELEASES.md`, both committed in the same PR), **validate-only at tag/build time** (no bot push to main). Humans edit `release-log.yaml`, never the `.md`. These now happen against **mm's** repo.
- **Status/Summary/Artifact/PRs content stays unenforced** — published/superseded/breadcrumb/newest-first remain human conventions, exactly as before.
- **Between-release refresh:** the `workflow_dispatch` refresh job re-renders mm's `RELEASES.md` from live tags + `release-log.yaml` and **opens a PR** (never pushes to main).

### 6.4 Notes-file convention (unchanged)
Per-version `docs/release-notes/<tag>.md` in each repo; `gh release create "<tag>" --notes-file "docs/release-notes/<tag>.md"`. matika/eyerate notes are notes-only and **link to the mm product release** (not to ahimsa). Prerelease tags use a templated fallback when the file is absent. ahimsa's old heredoc release path is removed with its release job (§1 step 6).

### 6.5 Product manifest / BOM (new, mm-owned)
Per product version, mm carries a manifest pinning matika / eyerate / ahimsa by **tag AND resolved SHA**. For v0.0.1: matika v0.0.4 / eyerate v0.0.4 / ahimsa v0.0.1, ahimsa's SHA being the exact `main` commit the validated x86_64 DMG was built from. The mm v0.0.1 release attaches that validated DMG.

### 6.6 Project #1 add automation (retained)
- **[RETIRED 2026-06-04 — not feasible on GitHub Free]** the built-in "Auto-add to project" workflow caps a Project at **one** auto-add workflow on Free, which cannot cover all repos. **Replacement (standing process):** add issues manually via the **`addProjectV2ItemById` GraphQL mutation**. CLI caveats: `gh project item-add` **silently no-ops** (exit 0, no add) and `gh project item-list` serves **stale/paginated** data — use the ProjectV2 **GraphQL API** for both add and verification. The new **mm** repo's issues join Project #1 via this mutation (§1 step 3).
- **Backfill (2026-06-04):** Project #1 holds **58 items** (GraphQL `totalCount`). No manual backfill remains.

### 6.7 Superseded sub-decisions (from the old ahimsa-hosted design)
- **"RELEASES.md / `release-log.yaml` → ahimsa, manomatika-wide" → REVERSED.** The content lives in **mm**; ahimsa keeps the engine only.
- **Umbrella `manomatika/release` repo → SUPERSEDED** by mm (full product authority); the umbrella is mm's `ARCHITECTURE.md` + product release notes.
- **ahimsa#35 / ahimsa#30 (recipe org-migration inside ahimsa) → SUPERSEDED.** The recipe is authored fresh in mm with canonical slugs; no tag-gated ahimsa recipe.json edit remains.
- **ahimsa release job + self-`v*`-tag trigger → RETIRED.** ahimsa builds transient artifacts only.

---

## APPENDIX — SUPERSEDED: old Wave 1–6 orchestration & agent roster

> The original plan sequenced the work as Pre-Execution milestone mutations → **Wave 1** (agents A–D, parallel) → **Wave 2** (E/F) → **Wave 3** (G, build.yml serialized) → human QA/tag gates → **Wave 5** (agent-I, slug canonicalization) → **Wave 6** (agents J/K/L, docs), with a dependency graph, a parallelism map, and a complete agent roster (agents A–L). That orchestration assumed: ahimsa **owned** the recipe, **hosted** the release, and **owned** the audit log; the umbrella was a separate `manomatika/release` repo; the slug/recipe canonicalization flowed through ahimsa#35/#38 with tag-gated sequencing; and QA covered the full macOS arm64 + x86_64 + Windows matrix.
>
> **All of that is superseded by §0 (architecture) and §1 (the 13-item sequence).** Specifically: the recipe + audit log + product release + installer binary move to **mm**; ahimsa narrows to the **engine**; the `manomatika/release` umbrella becomes **mm**; ahimsa#35/#30 are **superseded** (recipe relocates rather than org-migrates in place); the build.yml Wave-2/Wave-3 serialization no longer applies (no release job; recipe fetched from mm); and QA narrows to the **x86_64 DMG artifact** (arm64/Windows deferred).
>
> The merged engineering work that those waves produced (Node-20 bumps, matika.spec/launcher, the ahimsa build pipeline, the dmgbuild/Inno-Setup packaging, #38-early lowercasing, the release-notes engine) is **real and retained** — its status is recorded in §2 (issue inventory) and §4 (resolved decisions). Only the **ordering/orchestration and the ownership assumptions** are retired. Refer to §1 for the authoritative sequence and to the `.bak` snapshot for the full historical Wave text.
