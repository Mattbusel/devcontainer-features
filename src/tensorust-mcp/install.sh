#!/bin/sh
# Tensorust Ontology MCP Dev Container Feature.
# The MCP server itself is remote (https://shop.tensorust.com/api/mcp), so there is
# nothing to install. VS Code reads the server entry from this Feature's
# customizations.vscode.mcp and writes it to the container's user mcp.json.
# This script also drops a copy of the config for other MCP clients in the container.
set -e
DIR=/usr/local/share/tensorust-mcp
mkdir -p "$DIR"
cat > "$DIR/mcp.json" <<'JSON'
{
    "servers": {
        "tensorust": {
            "type": "http",
            "url": "https://shop.tensorust.com/api/mcp"
        }
    }
}
JSON
chmod 0644 "$DIR/mcp.json"
echo "[tensorust-mcp] VS Code will list the 'tensorust' MCP server in this container."
echo "[tensorust-mcp] Config for other MCP clients: $DIR/mcp.json"
