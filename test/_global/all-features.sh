#!/bin/bash
set -e
source dev-container-features-test-lib
check "llm-dash" bash -c "llm-dash --version"
check "orchestrator" bash -c "orchestrator --version"
check "every-other-token" bash -c "every-other-token --version"
check "tensorust mcp config" bash -c "test -f /usr/local/share/tensorust-mcp/mcp.json"
reportResults
