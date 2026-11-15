#!/bin/bash
set -e
source dev-container-features-test-lib
check "pinned version installed" bash -c "llm-dash --version | grep -q '1.2.2'"
reportResults
