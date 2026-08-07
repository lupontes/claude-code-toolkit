# Vendored skill

This directory is a **vendored copy** of the `grill-me` skill, redistributed
here under the terms of its upstream license.

- **Upstream:** https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me
- **Author:** Matt Pocock
- **License:** MIT (see `LICENSE` in this directory)

It is included in this toolkit for convenience only. This is not the canonical
source — for the latest version, issues, and contributions, use the upstream
repository above. No functional changes were made to the skill; only this
attribution file was added.

`grill-me` is a one-line wrapper (`disable-model-invocation: true`) that runs
a [`grilling`](../grilling) session only when explicitly invoked via
`/grill-me` — it never fires on its own, unlike `grilling` itself. Requires
the `grilling` skill to also be installed.
