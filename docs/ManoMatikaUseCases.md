# ManoMatika — Use Cases & Security Posture

> **Companion document.** The architecture this doc references lives in
> `ARCHITECTURE.md` (the ecosystem model, component roles, recipe model, build/
> release flow, BOM, and versioning contract). This document is the authority for
> **what ManoMatika is for** — its deployment use cases and the trust/security
> posture that governs applug behavior across every deployment.

---

## 1. What ManoMatika Is

ManoMatika is an **ecosystem for applug deployment**. The framework, **matika**,
is a plugin-agnostic FastAPI host with zero hardcoded domain knowledge; all
domain logic lives in plugins called **applugs**. A shipped product is a recipe-
composed, QA-validated triple of component versions (matika + an applug set +
the ahimsa engine), blessed by a single product release.

The framework is **one uniform mechanism**. It behaves identically regardless of
who deploys it, whose infrastructure it runs on, or who authored a given applug.
Whatever protections matika provides are intrinsic to matika and therefore travel
with **every** deployment and protect **every** deployer's instance the same way.
There is no special org-operated gate that some deployments get and others do not.

---

## 2. Trust & Security Posture (decided)

The governing posture is **install-trust**: at this stage we **trust everything**.
Installing an applug — via recipe at build time, or via the forthcoming runtime
applug loading (see §5, Use Case 3) — **is** the trust decision. We do not attempt
to make trust unnecessary; we make the trust decision **better-informed and harder
to abuse**, while being honest that a determined bad actor will always find a way.

The posture rests on four commitments:

1. **No first-party / third-party distinction in mechanism.** matika treats every
   applug identically. Any differentiation by author or by infrastructure owner is
   explicitly out of scope — it would add needless complexity and undermine the
   ecosystem model.

2. **ManoMatika-authored applugs are trusted by provenance.** The ManoMatika
   organization will produce applugs that we develop and whose safety we guarantee.
   These will live in an organization applug repository that is **not open to the
   public**. The SDK release itself only ever bundles the **reference applug**
   (eyerate); other org applugs are optionally composed into a deployment by
   authoring a recipe that includes them.

3. **Dangerous operations are funneled through matika APIs (safe-by-default
   surface).** The framework provides a reduced, documented, auditable API surface
   for any operation that touches the host (network, filesystem, process, secrets,
   etc.). Applugs are expected to perform such operations **only** through these
   APIs. This is enforced as a **convention and review target**, not as a hard
   guarantee — an applug is ordinary in-process Python and can, in principle,
   reach host primitives directly; Python's dynamic runtime makes true in-process
   prevention infeasible. The value is a small, well-understood surface that the
   honest path runs through and that review/inspection can be aimed at.

4. **Hindrances, not guarantees.** We layer in obstacles to bad behavior to the
   extent practical (the capability surface of §6, the advisory inspection of §7).
   None of these is claimed to make a malicious applug safe. They raise the floor
   against accidental and lazy misuse and produce a review signal; they do not
   move the ceiling against a determined adversary. That ceiling is accepted.

**Explicitly rejected approaches.** Hard runtime isolation of applug code
(restricted subprocess, constrained interpreter, or a WebAssembly/WASM runtime
boundary) is **out**. It does not fit the in-process FastAPI model, cannot run the
real product stack (compiled C/Rust extensions, sockets), and imposes complexity
and a security-critical runtime dependency we are not willing to carry. We are not
building an Apple-Store-style certification service either; we lack the resources
to validate and certify externally submitted applugs.

---

## 3. applug Unit Test Execution (decided)

Every applug declares its unit tests against a **known framework interface** so
that the build can discover and invoke them. During a build, the framework
**automatically executes all applug unit tests**. Period.

- **No trust dimension.** This is pure build automation, not a security boundary.
  There is no sandbox and no isolation around test execution, because none is
  needed: the framework runs the tests the applug provided, the same way for every
  applug.
- **No first-party / third-party distinction.** The reference applug and any
  third-party applug are discovered and run through the identical interface and
  mechanism.
- **Discipline applies as everywhere.** The complete suite runs in full and clean
  (no excluded / skipped / xfail / deselected tests, no suppressed warnings), and
  any escaped bug gains a regression test at the layer it escaped, per the standing
  rules.

The only real engineering here is the **stability and clarity of the test
interface** every applug implements so the framework can reliably kick the tests
off.

---

## 4. Deployment Models

Two basic deployments are supported, both via a browser UI:

**(a) Single machine — hidden local server.** ManoMatika is installed on one
machine. Clicking the application icon starts the server transparently and opens
the browser; the user is unaware a server is running. They interact entirely
through the browser.

**(b) Hosted application.** A party installs one or more ManoMatika instances on a
hosting platform, composed (via recipe) with the applugs of their choosing. Users
access each instance through a browser.

In both models the framework's behavior and protections are identical — see §1.

---

## 5. Use Cases

### Use Case 1 — ManoMatika SDK release (organization)

The ManoMatika organization releases fully tested, verified versions of ManoMatika
that include the **reference applug** implementation. This is the **SDK**: the
basis third-party developers use to build applications with the framework and their
own custom applugs.

- The SDK only ever includes the **reference applug**.
- ManoMatika may develop additional applugs (org-authored, trusted, safety
  guaranteed) that a deployment can **optionally** include by authoring a recipe;
  these are distributed from the organization's non-public applug repository.
- All ManoMatika-produced artifacts — the SDK, the reference applug, and any other
  org applug — are fully tested and verified as safe and functioning.

### Use Case 2 — Third-party application development

A third party builds an application on the ManoMatika SDK by implementing the
required applug interfaces and base-class extensions, producing one or more
applugs.

- The third party uses the SDK to author the **recipe** that builds their
  application for deployment (i.e. defines which applugs compose it).
- The third party defines unit tests per the SDK's test interface; those tests are
  **executed automatically at build time** by the framework (§3), exactly as the
  reference applug's are.
- The third party is **responsible for the good behavior of their applug(s)**.
  Under the install-trust posture (§2), the act of composing an applug into a
  recipe — by whoever builds the deployment — is the trust decision.

### Use Case 3 — Runtime applug loading (future milestone)

Future work will extend deployment beyond recipe-time composition to **loading an
applug into a running ManoMatika environment**. The §2 posture applies unchanged:
load is the trust decision, dangerous operations are funneled through matika APIs,
and the advisory inspection of §7 runs at load just as it runs at recipe build.

---

## 6. Capability Surface (matika API mediation)

The mechanism behind commitment §2.3. The framework offers a **reduced, documented
API** for host-touching operations (network, filesystem, process, secrets, and
similar). The intent is that an applug needing to do anything dangerous does it
**through matika**, so that the dangerous surface is small, centralized, and
auditable.

- This is the **safe-by-default path**, not a sandbox. It is enforced by
  convention, documentation, review, and the advisory inspection of §7.
- It is **not** a guarantee that an applug cannot bypass it; in-process Python
  cannot prevent direct access to host primitives. The design goal is to make the
  mediated path the obvious and only *documented* path, and to keep the surface
  small enough to reason about.

Designing exactly which operations are mediated, and the shape of that API, is
ongoing work (see Open Issues).

---

## 7. Install / Load-Time Inspection (advisory)

As defense-in-depth for the install-trust posture, applug code is **inspected** —
at recipe build/validate time, and (per Use Case 3) at runtime applug load — for
patterns that bypass the matika API surface or hit known weak points.

- **Mode: advisory.** Inspection **surfaces findings; a human decides.** A finding
  does not, by itself, fail a build or block a load.
- **Allowlist-preferred.** The check declares the *allowed* import/operation set
  (a stdlib subset + `matika.*` + the applug's own package) and flags everything
  else, rather than chasing a denylist of "bad" imports. It additionally flags the
  dynamic-dispatch primitives that defeat static analysis (`eval`, `exec`,
  `compile`, `__import__`, `importlib`, builtin `getattr`, and similar).
- **What it is.** A **hygiene and review gate.** It catches honest mistakes (a
  direct `os`/`subprocess`/`socket` call instead of the matika API), encodes our
  policy as executable rules, and produces a review signal.
- **What it is not.** A safety guarantee. The same Python dynamism that makes
  in-process sandboxing infeasible also defeats static detection of a *determined*
  bypass; obfuscated dynamic dispatch is not reliably catchable. Scanning raises
  the floor; it does not change the ceiling, and it does not make the install-trust
  decision unnecessary.
- **Ownership and invocation.** The policy is about matika's API surface, so
  **matika owns the canonical check**. ahimsa invokes it at recipe build/validate;
  matika invokes the *same* check at runtime applug load. One canonical
  implementation, two invocation points — intrinsic to matika, uniform for every
  applug.
- **Candidate tooling** (to be selected/combined during implementation):
  `import-linter` (import-contract enforcement — best fit for the core allowlist),
  a small custom AST check we own for the dynamic-dispatch primitives, and
  `Bandit` as a broad SAST pass. (`pip-audit` / `safety` are a separate concern —
  dependency CVE scanning, not bypass detection.)

---

## 8. Open Issues

To be addressed going forward; none gates the current release:

- **Hard enforcement is deliberately not pursued.** "Dangerous operations only
  through matika APIs" remains a convention, not a guarantee, for as long as
  applugs run as in-process Python. If a future requirement ever demands a true
  guarantee, it would require an isolation boundary around applug code — the
  complexity we have explicitly declined here. Documented as a known, accepted
  limitation.
- **Capability surface design.** The concrete set of host operations to mediate
  and the exact shape of the matika API for each (§6) is unspecified and is design
  work going forward.
- **Advisory inspection implementation.** Tool selection (import-linter + custom
  AST + Bandit), the allowlist definition, finding format/severity, and the two
  invocation points (ahimsa build/validate; matika runtime load) are not yet
  built (§7).
- **Runtime applug loading (Use Case 3).** The mechanism to load an applug into a
  running instance — and how §2/§6/§7 attach to it at load time — is future
  milestone work.
- **Organization applug repository.** The non-public org applug repo (hosting,
  access control, distribution into recipes) is not yet specified.
