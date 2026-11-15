#!/bin/bash
# Runs inside a container built with the 'every-other-token' Feature and default options.
set -e
source dev-container-features-test-lib
check "every-other-token is on PATH" bash -c "command -v every-other-token"
check "every-other-token --version runs" bash -c "every-other-token --version"
check "every-other-token --help runs" bash -c "every-other-token --help >/dev/null"
reportResults
