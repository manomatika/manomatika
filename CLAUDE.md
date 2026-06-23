# CLAUDE.md — manomatika (product authority)

Guidance for AI agents (cc) and assistants working in this repository.

## What this repo is

`manomatika/manomatika` is the **product authority** for the ManoMatika
ecosystem. **ManoMatika is the product**: a QA-validated, pinned triple of
component versions (matika + eyerate + ahimsa). This repo is NOT a component;
it composes and releases components.

This repo owns: the **recipes** that compose a product from its components; the
**audit log** (`release-log.yaml` human-edited source + generated `RELEASES.md`);
the **product release** and single hosted **installer binary**; the per-product-version
**manifest / BOM** (each component pinned by **tag AND resolved commit SHA**); the
cross-component umbrella **docs** (`ARCHITECTURE.md` and below); and the **QA gate**
a product version must pass before release.

**TARGET-vs-CURRENT (manifest/BOM):** the per-version manifest is still a TARGET.
Today `manifests/` holds only `TEMPLATE.yaml` (the schema: `components[]` of
`{repo, tag, sha}` + `installer{filename, platform, sha256}` + `qa{suite, result,
reference}`). No concrete `<version>.yaml` exists yet — the first real BOM is
authored when the first product version is cut. (The TEMPLATE's example installer
filename predates the lowercase-slug convention in *Naming conventions* — the
convention, not the stale example, is authoritative.)

ahimsa is pure *mechanism* (the recipe engine): it builds and validates artifacts
on demand but owns no recipe content and hosts no product releases. matika and
eyerate are components that ship as notes-only prereleases.

## Working Style & Discipline

This section captures the standing working rules across the manomatika ecosystem. **CLAUDE.md is authoritative for how a fresh Claude Code instance should operate in this repo; keep it current as practices evolve.** The terminal milestone of every release is `Documentation & Release Readiness`, which includes auditing and updating every CLAUDE.md against what actually shipped.

### Documentation integrity

CLAUDE.md must never knowingly contain stale information. Whenever CLAUDE.md is edited or regenerated, every factual claim about this repo (workflow/job status, ownership boundaries, file locations, build/release state) must be verified against the actual current repo state before being written. Stale claims are defects. When a claim cannot be verified, omit it rather than guess. This integrity requirement applies to all docs in this repo, not just CLAUDE.md. TARGET-vs-CURRENT divergence (where the intended model differs from what the code/repo physically contains today) must be stated honestly, not papered over.

### Collaboration model

- **Human in the loop for every change.** The user holds architecture, code review, and merge decisions. Don't merge PRs; don't push without explicit instruction; don't open PRs without the user's go-ahead.
- **One question or command batch at a time.** When asking a question or proposing actions, stop and wait for the user's answer or for the user to read previous output before continuing. Don't paste a new prompt or run new commands on top of unreviewed output.
- **Investigate-and-report before editing when scope is unclear.** Read the relevant code/docs first, surface what you find, and let the user direct the fix. Never assume; never silently expand scope.
- **Push back on overthinking and scope creep.** Best-practice patterns, never papered-over hacks. Fix issues correctly now — except items the user has explicitly deferred (e.g. follow-on issues filed against a later milestone).
- **Flag best-practice violations before implementing.** If a request would land an anti-pattern (security bypass, hack-around, etc.), surface the concern and let the user decide before writing code.

### Git, branches, references, and worktrees

- **The user does all git review and merges in the browser.** Don't merge PRs, push to main, or tag releases unless explicitly instructed.
- **Don't stage or commit unless explicitly granted.** The user handles `git add` / `git commit` manually by default. When granted, follow the conventional-commit pattern (`docs:`, `fix:`, `feat:`, `refactor:`, etc.) and include `Closes manomatika/<repo>#N` (fully qualified) where applicable.
- **Cross-repo issue/PR references must always be fully qualified.** Write `manomatika/matika#N`, `manomatika/eyerate#N`, `manomatika/ahimsa#N` — never a bare `#N` for an issue that lives in a different repo. Bare refs are only safe when the PR and the issue are in the same repo. Cross-repo `Closes` references only cross-link — they do NOT auto-close; close manually after merge.
- **cc does not run `git merge` locally.** Integration of branches is done by the user via PR merge in the browser. For any local branch updates cc performs, use `git rebase` or `git cherry-pick`. cc may run `rm -rf` ONLY within a repo working directory under `~/dev/projects/` (a clone `~/dev/projects/<repo>/` or a worktree `~/dev/projects/<repo>-<branch>/`) or under `~/dev/projects/cc_output/` — never anywhere else on the filesystem, and never with an unanchored or variable-expanded path that could resolve outside them. Targeted `git rm` for tracked files remains the norm; `rm -rf` is the constrained exception (rule 23).
- **`VERSION` is the single source of truth** for version metadata in this repo. Never hand-edit version literals in other files; release tooling propagates from `VERSION`.
- **The user uses git worktrees** for parallel work (e.g. `~/dev/projects/matika-45/` alongside `~/dev/projects/matika/` on a separate branch). At any moment, the user may be operating in any of several working directories for the same repo. Always check the current branch (`git branch --show-current`) and confirm it matches what you expect before assuming.
- **Multi-instance/parallel discipline.** When operating as one of multiple parallel cc instances, stay strictly within the assigned worktree, branch, and scope of files described in the task. Do not modify files outside the assigned scope, even if issues are noticed elsewhere — surface those issues to the user as separate items to triage rather than fixing in-flight. Cross-cutting changes that touch another agent's work area must be coordinated by the user, not initiated unilaterally.

### Code and test discipline

- **Regression tests are required for every fix.** A bug fix that doesn't include a test that would have caught the bug isn't done.
- **All tests must RUN IN FULL and pass — 100% clean.** Every affected repo's COMPLETE suite must RUN with nothing excluded, deselected, skipped, or marked integration-only, and pass: 0 failed / 0 skipped / 0 xfail / 0 deselected / 0 warnings. No test may be excluded or filtered and no warning suppressed without the product owner's explicit, per-case approval recorded as a documented rule variation.
- **Full-suite, every change, everywhere — 100% clean (standing rule 21).** ANY code change, in ANY repo, requires the COMPLETE unit-test suite of every affected repo (and any repo whose behavior could be impacted) to RUN IN FULL — nothing excluded, deselected, skipped, or marked integration-only — and pass 100%: 0 failed / 0 skipped / 0 xfail / 0 deselected / 0 warnings. Eliminate every warning at its ROOT (fix the code or bump the dependency); never blanket-suppress with a `filterwarnings` / `-W ignore` / `-m 'not …'` filter. Use each repo's correct test environment (the uv-managed `.venv`) so a green run is never an env artifact. A change is not done until every suite is 100% clean.
- **Escaped-bug regression mandate (standing rule 22).** Any bug that reaches CI, an rc, or install/runtime testing without being caught by the suite MUST, as part of its fix, gain a regression test that would have caught it — added at the layer where it escaped (unit/integration for logic gaps; a feature/E2E check against the FROZEN, pinned artifact for product-behavior gaps). The fix is not done until that test exists, fails without the fix, and passes with it. Product-behavior regressions must be exercised against the frozen artifact on BOTH install paths (fresh install AND upgrade over a prior install), since the upgrade path is where the stale-plugin regression escaped.
- **Never weaken or disable security / correctness checks** (CSRF, permission, auth, validation) as a workaround. If a check is producing a wrong answer, fix the call site to satisfy it correctly — never bypass.

### Repository ecosystem

- **manomatika** is the GitHub org. The shipped PRODUCT is **ManoMatika** — a pinned *triple* of component versions (matika + eyerate + ahimsa), blessed by a single product release. The repos:
  - **manomatika/manomatika** — PRODUCT AUTHORITY. Owns the recipes, the audit log (`release-log.yaml` + `RELEASES.md`), the product release + single hosted installer binary, cross-component umbrella docs, the per-version manifest/BOM (pins each component by tag AND resolved SHA), and the QA gate. **This repo.**
  - **manomatika/matika** — the framework (plugin-agnostic FastAPI host). Component; notes-only releases.
  - **manomatika/eyerate** — the reference AppLug (financial security tracking). Component; notes-only releases.
  - **manomatika/ahimsa** — the recipe ENGINE: build / validation / release *mechanism* + recipe *schema*. Owns no recipes, no audit-log content, and hosts no product releases of its own.
- Local clones live at `~/dev/projects/<repo>/` (sibling directories). Additional worktrees for the same repo live at `~/dev/projects/<repo>-<branch>/`.

### Milestones, Project, and dates

- **Milestone naming is shared and match-when-present** across repos. When a milestone exists in more than one repo, its title is byte-for-byte identical so the org Project rolls it up into a single cross-repo group. Milestone names never contain version numbers or dates.
- **Canonical milestone titles in the current release cycle:**
  - `Deployment & Install`
  - `Cleanup & Tooling`
  - `Registry` (ahimsa only)
  - `Signing & Distribution` (ahimsa only)
  - `QA & System Test` (ahimsa only)
  - `Planning` (matika + eyerate + ahimsa)
  - `Playwright` (matika only)
  - `Documentation & Release Readiness` — the terminal release gate (all three)
- **Org-level Project: [ManoMatika Roadmap](https://github.com/orgs/manomatika/projects/1)** is the cross-repo backlog view. Its description records which component versions compose each manomatika release (e.g. ManoMatika v0.0.1 = matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1).
- **Milestone due dates are the single source of truth for dates.** The roadmap renders timelines from milestone Markers; do NOT create per-item date fields on the Project for scheduling (Pattern A — milestone-driven).

### Communication and output

- **Put prompts and commands in code blocks** so the user can one-tap copy them.
- The user is on **macOS** and uses **Ghostty** and **tmux** for terminal work (shell defaults to zsh). The user also runs a **Dell Latitude** (64 GB RAM, no high-performance GPU) for local models via **Ollama**, currently favoring **qwen**. All configs are managed with **chezmoi**; any change to any config must follow chezmoi best practice and standards. chezmoi usage is captured in a separate handoff file, `chezmoi-dotfiles-handoff.md`. The user edits in **neovim**, and may also use **VSC**.
- The user is **expert in software architecture and engineering, novice in git/GitHub specifics.** When git or `gh` commands appear in plans or output, explain plainly what they do, what they touch, and what the user will see.

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

## Versioning

See [docs/versioning.md](docs/versioning.md) for the full versioning contract (VERSION as source of truth, core/suffix rules, recipe field constraints, and version ladder).

## QA gate

See [docs/qa-gate.md](docs/qa-gate.md) for the full QA gate specification (ahimsa CI, tier-a/b checks, both install paths, component contracts).
