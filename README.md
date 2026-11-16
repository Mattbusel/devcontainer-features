# Dev Container Features

Four [Dev Container Features](https://containers.dev/implementors/features/) that add LLM tooling to any dev container or GitHub Codespace. Each one installs a prebuilt, checksum-verified binary, or wires an MCP server into VS Code.

| Feature | Reference | What it adds |
|---|---|---|
| [llm-dash](https://github.com/Mattbusel/devcontainer-features/blob/main/docs/llm-dash.md) | `ghcr.io/mattbusel/devcontainer-features/llm-dash:1` | Terminal dashboard that prices every LLM API call in your logs |
| [tokio-prompt-orchestrator](https://github.com/Mattbusel/devcontainer-features/blob/main/docs/tokio-prompt-orchestrator.md) | `ghcr.io/mattbusel/devcontainer-features/tokio-prompt-orchestrator:1` | LLM API proxy with a queue, dedup and a circuit breaker |
| [every-other-token](https://github.com/Mattbusel/devcontainer-features/blob/main/docs/every-other-token.md) | `ghcr.io/mattbusel/devcontainer-features/every-other-token:1` | Per-token confidence for LLM streams |
| [tensorust-mcp](https://github.com/Mattbusel/devcontainer-features/blob/main/docs/tensorust-mcp.md) | `ghcr.io/mattbusel/devcontainer-features/tensorust-mcp:1` | Tensorust Ontology MCP server in VS Code |

## Install

Add one or more Features to `.devcontainer/devcontainer.json` and rebuild the container:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/mattbusel/devcontainer-features/llm-dash:1": {},
        "ghcr.io/mattbusel/devcontainer-features/tensorust-mcp:1": {}
    }
}
```

The three binary Features take a `version` option (default `latest`), for example `{ "version": "1.2.2" }`.

## Docs and license

- Feature docs: [docs/](https://github.com/Mattbusel/devcontainer-features/tree/main/docs)
- Source in `src/`, tests in `test/`. Each push to `main` that changes `src/` publishes new versions to ghcr.io.
- MIT license: [LICENSE](https://github.com/Mattbusel/devcontainer-features/blob/main/LICENSE). Each installed tool keeps its own license.
