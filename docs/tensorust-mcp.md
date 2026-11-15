# Tensorust Ontology MCP server

Adds the remote [Tensorust Ontology](https://github.com/Mattbusel/tensorust-mcp) MCP server to VS Code inside the dev container. Copilot agent mode and any other MCP client in VS Code can then ask who owns and controls US companies and property (county property rolls, state business registries, SEC subsidiary lists, FCC, USAC E-Rate, federal awards, FAA aircraft registry), what BDC lenders say a private loan is worth, which federal research awards touch banned-vendor lists, and browse a catalog of 145 datasets with free samples.

```jsonc
"features": {
    "ghcr.io/mattbusel/devcontainer-features/tensorust-mcp:1": {}
}
```

The Feature sets `customizations.vscode.mcp`. When the container starts for the first time, the Dev Containers extension writes the server into the container's user `mcp.json`, so it shows up under **MCP: List Servers** as `tensorust`. Nothing runs in the container: the server is `https://shop.tensorust.com/api/mcp` (streamable HTTP).

A copy of the config is also written to `/usr/local/share/tensorust-mcp/mcp.json` for other MCP clients in the container.

## Free tier and keys

Free answers are previews and need no key. For full data, get a `tdk_` key at https://shop.tensorust.com/ontology and override the server in your own `devcontainer.json` (entries there win over the Feature's):

```jsonc
"customizations": {
    "vscode": {
        "mcp": {
            "servers": {
                "tensorust": {
                    "type": "http",
                    "url": "https://shop.tensorust.com/api/mcp",
                    "headers": { "Authorization": "Bearer ${input:tensorust-key}" }
                }
            },
            "inputs": [
                { "id": "tensorust-key", "type": "promptString", "description": "Tensorust key (tdk_...)", "password": true }
            ]
        }
    }
}
```
