# tokio-prompt-orchestrator (LLM API proxy)

Installs `orchestrator` from [tokio-prompt-orchestrator](https://github.com/Mattbusel/tokio-prompt-orchestrator). It is an HTTP proxy that puts a queue, deduplication and a circuit breaker in front of any LLM API, so repeated prompts cost one call and outages fail fast.

```jsonc
"features": {
    "ghcr.io/mattbusel/devcontainer-features/tokio-prompt-orchestrator:1": {}
}
```

## Options

| Option | Default | Meaning |
|---|---|---|
| `version` | `latest` | Release to install, for example `2.4.1`. `latest` follows the newest GitHub release. |

## How it installs

The Feature downloads the prebuilt x86_64 Linux binary from the GitHub release, checks it against `SHA256SUMS.txt`, and puts `orchestrator` in `/usr/local/bin`. It needs glibc 2.34 or newer. On aarch64 (there is no prebuilt Linux arm64 binary yet), Alpine or older distros, it runs `cargo install --bin orchestrator tokio-prompt-orchestrator` if Rust is present; add `ghcr.io/devcontainers/features/rust:1` for that case.
