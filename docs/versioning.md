> Part of [CLAUDE.md](../CLAUDE.md) — see the main file for orientation.

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
