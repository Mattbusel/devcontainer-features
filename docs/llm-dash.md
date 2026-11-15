# llm-dash (LLM cost dashboard)

Installs `llm-dash` from [llm-cost-dashboard](https://github.com/Mattbusel/llm-cost-dashboard). It prices every LLM API call in your request logs and shows spend and budget alerts in a terminal dashboard.

```jsonc
"features": {
    "ghcr.io/mattbusel/devcontainer-features/llm-dash:1": {}
}
```

## Options

| Option | Default | Meaning |
|---|---|---|
| `version` | `latest` | Release to install, for example `1.2.2`. `latest` follows the newest GitHub release. |

## How it installs

The Feature downloads the prebuilt binary for the container's CPU (x86_64 or aarch64) from the GitHub release, checks it against the release's `SHA256SUMS.txt`, and puts it in `/usr/local/bin`. The binaries need glibc 2.34 or newer (Debian 12, Ubuntu 22.04 and newer). On Alpine, older distros or a version that has no prebuilt binary, it builds the crate with `cargo install` if Rust is present; add `ghcr.io/devcontainers/features/rust:1` for that case.
