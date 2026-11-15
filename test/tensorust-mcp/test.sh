#!/bin/bash
# Runs inside a container built with the 'tensorust-mcp' Feature.
set -e
source dev-container-features-test-lib
check "mcp.json written" bash -c "grep -q 'https://shop.tensorust.com/api/mcp' /usr/local/share/tensorust-mcp/mcp.json"
reportResults
