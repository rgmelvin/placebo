#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]")/.." && pwd)"
exec ."$REPO_ROOT/beargrease/scripts/run-tests.sh"