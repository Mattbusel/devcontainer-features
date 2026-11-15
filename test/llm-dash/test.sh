#!/bin/bash
# Runs inside a container built with the 'llm-dash' Feature and default options.
set -e
source dev-container-features-test-lib
check "llm-dash is on PATH" bash -c "command -v llm-dash"
check "llm-dash --version runs" bash -c "llm-dash --version"
check "llm-dash --help runs" bash -c "llm-dash --help >/dev/null"
reportResults
