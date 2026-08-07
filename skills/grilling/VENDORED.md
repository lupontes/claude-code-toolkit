# Vendored skill

This directory is a **vendored copy** of the `grilling` skill, redistributed
here under the terms of its upstream license.

- **Upstream:** https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling
- **Author:** Matt Pocock
- **License:** MIT (see `LICENSE` in this directory)

It is included in this toolkit for convenience only. This is not the canonical
source — for the latest version, issues, and contributions, use the upstream
repository above. No functional changes were made to the skill; only this
attribution file was added.

`grilling` is the underlying interview primitive: it is model-invocable (no
`disable-model-invocation` flag), meaning Claude may reach for it on its own
when a plan or decision fits its description, or it can be run explicitly via
`/grilling`. See [`grill-me`](../grill-me) for the explicit-only front door.
