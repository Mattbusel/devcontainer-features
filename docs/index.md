# Dev Container Features by Mattbusel

| Feature | Reference | What it adds |
|---|---|---|
| [llm-dash](llm-dash.md) | `ghcr.io/mattbusel/devcontainer-features/llm-dash:1` | Terminal dashboard that prices every LLM API call in your logs |
| [tokio-prompt-orchestrator](tokio-prompt-orchestrator.md) | `ghcr.io/mattbusel/devcontainer-features/tokio-prompt-orchestrator:1` | LLM API proxy with queue, dedup and circuit breaker |
| [every-other-token](every-other-token.md) | `ghcr.io/mattbusel/devcontainer-features/every-other-token:1` | Per-token confidence for LLM streams |
| [tensorust-mcp](tensorust-mcp.md) | `ghcr.io/mattbusel/devcontainer-features/tensorust-mcp:1` | Tensorust Ontology MCP server in VS Code |

Source is in `src/`, tests in `test/`. Each push to `main` that changes `src/` publishes new Feature versions to ghcr.io.
