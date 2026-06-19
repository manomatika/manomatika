# ManoMatika Ecosystem Architecture

**ManoMatika** | Version: **v0.0.1** | Copyright (c) 2026 Patrick James Tallman

---

## 1. Product Model

ManoMatika is the **product**: a pinned triple of three component versions that
have been built and QA-validated together. A release is not any one repo's
event — it is the act of blessing exactly one validated triple.

| Component | Repo | Role |
|---|---|---|
| matika | `manomatika/matika` | The framework — plugin-agnostic FastAPI host |
| eyerate | `manomatika/eyerate` | Reference AppLug — financial security tracking |
| ahimsa | `manomatika/ahimsa` | Recipe engine — build, validation, and release mechanism |
| *(this repo)* | `manomatika/manomatika` | Product authority — recipes, audit log, product release, BOM, QA gate |

The **prerelease flag** is the trust boundary. Component tags (`matika v0.0.4`,
`eyerate v0.0.4`) are GitHub prereleases (notes-only, no binaries). Only the
`manomatika/manomatika` product release carries the blessed, distributable
installer.

---

## 2. Component Architecture

### 2.1 matika — The Framework

matika is a plugin-agnostic FastAPI host. It provides:

- User authentication (bcrypt, sessions, CSRF protection)
- RBAC and permission system
- Dynamic navigation (menu hub with Default / Application / Role / System zones)
- Plugin discovery — scans `plugins/` for `applug.json` manifests at startup
- Internationalization (core strings; AppLugs contribute overrides via locale files)
- Alembic-managed core schema migrations

matika has zero hardcoded knowledge of the applications it hosts. All domain
logic lives in AppLugs. matika releases as a **notes-only prerelease**; its
distributable installer binary is produced by ahimsa from a recipe.

Stack: FastAPI (Python 3.14+), SQLAlchemy ORM, SQLite/PostgreSQL, Jinja2 + TypeScript.

See: [matika/docs/ARCHITECTURE.md](https://github.com/manomatika/matika/blob/main/docs/ARCHITECTURE.md)

### 2.2 eyerate — The Reference AppLug

eyerate is the reference AppLug for the ManoMatika ecosystem. Domain: financial
security tracking (securities price monitoring and eye-strain scoring for
extended work sessions).

eyerate demonstrates the canonical AppLug contract (see §4). It extends matika's
core schema with a `securities` table and contributes its own routes, templates,
menus, and locale strings through the standard AppLug interfaces.

eyerate releases as a **notes-only prerelease** (no installer binary).

See: [eyerate/docs/DEVELOPER_GUIDE.md](https://github.com/manomatika/eyerate/blob/main/docs/DEVELOPER_GUIDE.md)

### 2.3 ahimsa — The Recipe Engine

ahimsa is the build, validation, and release **mechanism**. It owns:

- The recipe schema (required fields, formats, consistency rules)
- `ahimsa-validate` — recipe validator CLI; verifies schema and fetches each
  AppLug's `applug.json` from GitHub at the declared tag
- `ahimsa-validate-releases` — audits `RELEASES.md` (fetched from this repo)
  against live git tags across the ecosystem
- The build pipeline (`build.yml`) — clones pinned components at their tags,
  produces macOS DMG and Windows EXE **artifacts** (not releases)
- The release-notes renderer (`scripts/render_releases_md.py`) — merges
  `release-log.yaml` with live tag data to generate `RELEASES.md`

ahimsa owns **no** recipes, **no** audit-log content, and hosts **no** GitHub
releases of its own. Installers are transient CI artifacts; the product release
is cut here in `manomatika/manomatika`.

See: [ahimsa/CLAUDE.md](https://github.com/manomatika/ahimsa/blob/main/CLAUDE.md)

---

## 3. The Recipe Model

A recipe is a JSON lockfile declaring exactly which version of matika and which
AppLugs compose an application. Recipes live at `recipes/<app>/recipe.json` in
this repo.

```json
{
  "application": {
    "name": "Matika Reference Application",
    "product_name": "ManoMatika",
    "version": "0.0.1",
    "bundle_id": "com.manomatika.matika-reference-app",
    "icon": "assets/icon.icns"
  },
  "matika": {
    "version": "0.0.4",
    "tag": "v0.0.4",
    "repo": "github.com/manomatika/matika"
  },
  "applugs": [
    {
      "name": "eyerate",
      "repo": "github.com/manomatika/eyerate",
      "version": "0.0.4",
      "matika_version": "0.0.4",
      "tag": "v0.0.4"
    }
  ]
}
```

### Invariants

- **Exact pins only.** Every version field is the bare core `X.Y.Z` — no
  ranges, wildcards, or pre-release suffixes (`-dev`, `-rc.N`). Pre-release
  suffixes belong only on human/audit surfaces (the `VERSION` string, git tags,
  GitHub release titles/bodies, and the audit log), never inside recipe pins.
- **AppLug–matika agreement.** Every `applugs[].matika_version` must equal
  `matika.version`. AppLugs must declare the same framework version they were
  built against.
- **Cross-applug consistency.** All `applugs[].matika_version` values must be
  identical across the applug list.
- **Repo format.** `host/owner/repo` — no URL scheme, no `.git`, no SSH form.
  Default allowed host: `github.com`.
- **Product identity.** `application.product_name` is the canonical PRODUCT
  brand (`ManoMatika`). ahimsa's build derives every user-facing name from it:
  the lowercase slug names the artifact FILE
  (`manomatika-<version>-<os>-<arch>.dmg/.exe`) and the proper-noun name is the
  installed bundle/exe identity (`ManoMatika-<version>.app`/`.exe`). The version
  embedded is the PRODUCT version (`application.version`), not matika's framework
  version. `application.name` is a separate descriptive title and drives no
  artifact name.

ahimsa's validator verifies all rules in a single pass and additionally fetches
each AppLug's `applug.json` from GitHub at the declared tag to confirm `id`,
`version`, and `matika_version`.

---

## 4. The AppLug Contract

An AppLug must provide at its repo root:

| Artifact | Purpose |
|---|---|
| `applug.json` | Manifest: `id`, `version`, `matika_version`; optional `name`, `entry_point`, `permissions` |
| `<id>_menus.json` | Menu metadata (schema v1.0): optional `application`, `roles`, and `system` sections |
| Python class extending `BaseAppLug` | `on_load(db)` and `on_unload(db)` lifecycle hooks |

ahimsa fetches `applug.json` from the declared repo at the declared tag during
recipe validation to verify compatibility before a build. Matika discovers
`applug.json` at deploy time by scanning `plugins/<id>/`.

**Compatibility guarantee:** patch-level matika bumps are non-breaking within a
minor version. A minor-version bump (`0.1.0`) may introduce breaking interface
changes; AppLugs must update `matika_version` and be re-tested before inclusion
in a recipe targeting the new minor.

See: [ahimsa/docs/applug-schema.md](https://github.com/manomatika/ahimsa/blob/main/docs/applug-schema.md)

---

## 5. Build and Release Flow

```
[code complete, docs finalized]
          ↓
[tag matika + eyerate as notes-only prereleases]
          ↓
[dispatch ahimsa build.yml — workflow_dispatch]
(fetches recipe from manomatika/manomatika; clones pinned components)
          ↓
[installer artifacts produced — macOS DMG, Windows EXE]
(CI artifacts only; no GitHub release created by ahimsa)
          ↓
[QA gate — macOS x86_64 DMG validated]
          ↓  (pass only)
[ManoMatika product release cut]
  • tag ahimsa at the exact SHA the validated DMG was built from (notes-only)
  • author product manifest in manomatika/manomatika (tag + resolved SHA per component)
  • write product release notes
  • create manomatika/manomatika product release; attach the validated DMG
```

Nothing is blessed before QA. Components remain prereleases until the product
release is cut. The `manomatika/manomatika` product release is the **only**
distributable, blessed artifact.

---

## 6. Product Manifest / BOM

Each product version has a manifest in `manifests/` that pins every component
by both tag and resolved commit SHA:

```yaml
product: ManoMatika
version: 0.0.1
components:
  matika:
    tag: v0.0.4
    sha: <resolved-commit-sha>
  eyerate:
    tag: v0.0.4
    sha: <resolved-commit-sha>
  ahimsa:
    tag: v0.0.1
    sha: <resolved-commit-sha>
```

The manifest is the audit record for exactly what was QA-validated. SHA pins
prevent silent drift if a tag is ever moved.

---

## 7. Versioning — Core / Suffix Contract

`VERSION` (this repo root) is the single source of truth for this repo's version
metadata. It reads a SemVer string of the form `X.Y.Z` or `X.Y.Z-<suffix>` with
no leading `v` (today: `0.0.1-dev`).

- **Version core (`X.Y.Z`)** is the canonical identity used for comparison,
  artifact naming, and OS/installer fields. Recipe pins (`recipe.json`
  `version` / `matika_version`, manifest tags) carry the **bare core** only.
- **Pre-release suffix** (`-dev`, `-rc.N`) lives ONLY on human/audit surfaces:
  the `VERSION` string, git tags, GitHub release titles/bodies, and the audit
  log. It never appears inside a recipe pin or BOM SHA mapping.
- **Ladder:** `X.Y.Z-dev` < `X.Y.Z-rc.N` < `X.Y.Z` (final). The suffix is
  delimited with a hyphen (`-dev`), which is valid SemVer; the underscore form
  (`_dev`) is invalid and is not used anywhere in the ecosystem.

---

## 8. Audit Log

`release-log.yaml` (this repo) is the human-edited source of truth for the
ecosystem-wide release audit log. `RELEASES.md` is the generated output — do
NOT hand-edit `RELEASES.md`.

One record per `(repo, tag)` pair across all component repos:

```yaml
entries:
  - repo: matika
    tag: v0.0.4
    date: 2026-MM-DD
    status: published
    artifact: "@manomatika/matika-frontend@0.0.4 (GitHub Packages)"
    prs: "manomatika/matika#N"
    summary: "..."
```

To regenerate `RELEASES.md`, dispatch the `refresh-releases-md` job in
`ahimsa/build.yml`. That job checks out this repo, runs the renderer with live
GitHub tag data, and opens a PR here with the updated file.

The bidirectional consistency rule is enforced by `ahimsa-validate-releases`:
every live git tag matching `vX.Y.Z` or `vX.Y.Z-PRERELEASE` must have a
`## <repo> <tag>` entry in `RELEASES.md`, and every entry must correspond to
an actual tag.

---

## 9. Component Documentation Links

| Document | Location |
|---|---|
| matika architecture | [matika/docs/ARCHITECTURE.md](https://github.com/manomatika/matika/blob/main/docs/ARCHITECTURE.md) |
| matika install guide | [matika/docs/INSTALL.md](https://github.com/manomatika/matika/blob/main/docs/INSTALL.md) |
| matika deployment guide | [matika/docs/DEPLOYMENT.md](https://github.com/manomatika/matika/blob/main/docs/DEPLOYMENT.md) |
| matika developer guide | [matika/docs/DEVELOPER_GUIDE.md](https://github.com/manomatika/matika/blob/main/docs/DEVELOPER_GUIDE.md) |
| eyerate user guide | [eyerate/docs/USER_GUIDE.md](https://github.com/manomatika/eyerate/blob/main/docs/USER_GUIDE.md) |
| eyerate developer guide | [eyerate/docs/DEVELOPER_GUIDE.md](https://github.com/manomatika/eyerate/blob/main/docs/DEVELOPER_GUIDE.md) |
| AppLug JSON schema | [ahimsa/docs/applug-schema.md](https://github.com/manomatika/ahimsa/blob/main/docs/applug-schema.md) |
| ahimsa engine reference | [ahimsa/CLAUDE.md](https://github.com/manomatika/ahimsa/blob/main/CLAUDE.md) |
