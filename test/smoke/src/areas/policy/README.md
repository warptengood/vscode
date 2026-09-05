# Native policy smoke tests

These tests exercise startup policy ingestion in the unmodified desktop product.
They set `extensions.autoUpdate` to `on` in a fresh user-data directory and check
the value, editability, and organization-managed indicator with and without
`ExtensionsAutoUpdate="off"`.

Run only on a disposable test runner. A fresh VS Code profile does not isolate
OS policy state:

- Linux uses `/etc/vscode/policy.json`. From the repository root, run
  `bash test/smoke/scripts/run-with-policy.sh --tracing -g "Policy Plumbing"`.
  The wrapper requires root or sudo, refuses an existing `/etc/vscode` directory,
  and removes its fixture on exit.
- Windows uses the tested product's HKCU policy registry key. The fixture refuses
  an existing value in either HKLM or HKCU and removes only its own value.
- macOS uses `defaults` for the tested product's policy bundle identifier. The
  fixture refuses existing system preference files or an existing user policy
  value, then removes its own user preference. This covers the native
  `CFPreferences` read path, not MDM profile installation or live notifications.

On Windows/macOS, set `VSCODE_SMOKE_TEST_POLICY=1` in the test process environment
and run `npm run smoketest-no-compile -- --tracing -g "Policy Plumbing"`.
The desktop CI steps opt in explicitly. Ordinary local smoke runs do not.

Each variant starts a fresh process. Cleanup runs after application shutdown.
Existing policy is never intentionally overwritten; fixture conflicts fail the
run rather than silently skipping coverage.
