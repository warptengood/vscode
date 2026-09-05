#!/usr/bin/env bash
# Run only on a disposable Linux CI runner or container, not a managed workstation.
set -euo pipefail

if [[ "$(uname -s)" != Linux ]]; then
	echo "The native policy smoke fixture currently supports Linux only." >&2
	exit 1
fi

root=()
if [[ "$(id -u)" != 0 ]]; then
	root=(sudo)
fi

# A successful exclusive mkdir establishes ownership. Never reuse existing policy state.
"${root[@]}" mkdir /etc/vscode
cleanup() {
	"${root[@]}" rm -f /etc/vscode/policy.json
	"${root[@]}" rmdir /etc/vscode
}
trap cleanup EXIT
"${root[@]}" chown "$(id -u):$(id -g)" /etc/vscode

VSCODE_SMOKE_TEST_POLICY=1 npm run smoketest-no-compile -- "$@"
