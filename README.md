# ManoMatika

**ManoMatika is the product**: a specific, QA-validated, pinned triple of three
component versions —

| Component | Repo | Role |
|-----------|------|------|
| matika | `manomatika/matika` | The framework — a plugin-agnostic FastAPI host with a TypeScript frontend. |
| eyerate | `manomatika/eyerate` | The reference applug (plugin); domain is financial security tracking. |
| ahimsa | `manomatika/ahimsa` | The recipe engine — build, validation, and release mechanism only. |

A ManoMatika release is not any one repo's release. It is this repository naming
an exact set of component versions that have been built and validated together.

## What this repository is

`manomatika/manomatika` is the **product authority**. It owns:

- the **recipes** that compose a product from its components;
- the **audit log** (`release-log.yaml` source + generated `RELEASES.md`);
- the **product release** and the single hosted **installer binary**;
- the per-product-version **manifest / BOM**, which pins each component by
  **tag AND resolved commit SHA**;
- the cross-component umbrella **docs** (`ARCHITECTURE.md` and below);
- the **QA gate** that a product version must pass before release.

The component repos own their own code, docs, and notes-only prereleases. ahimsa
owns the build/validation/release *mechanism* but holds no product content and
hosts no product releases.

## The release flow

1. **Components ship as prereleases.** matika and eyerate are tagged as
   notes-only prereleases; their built artifacts are inputs, not the product.
2. **ahimsa builds an installer artifact on demand** (`workflow_dispatch`) from
   the recipe, cloning the pinned component tags. It produces artifacts; it does
   not create a release.
3. **QA gate.** The candidate installer is validated against the QA suite.
4. **Product release.** Only on a pass does ManoMatika get cut: the manifest is
   authored (component tag + resolved SHA), product release notes are written,
   and the validated installer is attached to the ManoMatika release here.

Nothing is "blessed" before QA. Components remain prereleases; only the
ManoMatika product release is the blessed, distributable thing.

## Current release composition

**ManoMatika v0.0.1 = matika v0.0.4 + eyerate v0.0.4 + ahimsa v0.0.1**

## Layout

- `manomatika-v0.0.1-plan.md` — the authoritative living release plan.
- `shell_scripts/` — developer helper scripts (e.g. `sync-repos.sh`).

(Recipes, audit log, product manifest, and `ARCHITECTURE.md` land here as the
v0.0.1 release sequence proceeds.)
