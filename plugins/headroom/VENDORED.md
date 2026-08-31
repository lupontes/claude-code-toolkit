# Vendored plugin

This directory is a **vendored copy** of the `headroom` plugin (the
`headroom-agent-hooks` plugin from the Headroom project), redistributed here
under the terms of its upstream license.

- **Upstream:** https://github.com/chopratejas/headroom
- **Author:** Headroom Contributors
- **License:** Apache-2.0 (see `LICENSE` and `NOTICE` in this directory)

It is included in this toolkit for convenience only. This is not the canonical
source — for the latest version, issues, and contributions, use the upstream
repository above. No functional changes were made to the plugin; only these
attribution files were added.

> Note: `headroom` relies on an external `headroom` CLI (Rust core, distributed
> as the `headroom-ai` Python package) that these hooks invoke. Installing this
> plugin does not install that CLI — install it separately, e.g.
> `pipx install "headroom-ai[all]"` — see the upstream repository for details.
