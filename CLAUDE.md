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

ahimsa is pure *mechanism* (the recipe engine): it builds and validates
artifacts on demand but owns no recipe content and hosts no product releases.
matika and eyerate are components that ship as notes-only prereleases.

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
- The product's installed identity stays capitalized as a proper noun
  (`Matika.app`, `Matika-<ver>.exe`, FastAPI `title="Matika"`); lowercase still
  applies to repo slugs, URLs, internal/runtime data dirs (e.g. `~/matika/`),
  and config refs.

## Cross-repo references

Always fully qualified: `manomatika/<repo>#N`, never a bare `#N` (issue numbers
collide across repos). Cross-repo `Closes` references only cross-link — they do
NOT auto-close; close manually after merge.

## Versioning

`VERSION` is the single source of truth for version metadata. The product
manifest pins each component by tag AND resolved commit SHA — no ranges, no
wildcards.
