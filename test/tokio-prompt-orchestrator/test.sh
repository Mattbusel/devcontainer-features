#!/bin/bash
# Runs inside a container built with the 'tokio-prompt-orchestrator' Feature and default options.
set -e
source dev-container-features-test-lib
check "orchestrator is on PATH" bash -c "command -v orchestrator"
check "orchestrator --version runs" bash -c "orchestrator --version"
check "orchestrator --help runs" bash -c "orchestrator --help >/dev/null"
reportResults
