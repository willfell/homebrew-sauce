# CI runner routing

The formula and shared actionlint job use the canonical hosted ARM expression,
ten-minute timeouts and v1.19.0 fleet policy. This public repository has zero
private hosted billed minutes. Homebrew receives only the job token through
`HOMEBREW_GITHUB_API_TOKEN`; no credential value is tracked. Native unittest
guards cover the complete job inventory, timeouts and provider tag.

The migration changes workflow routing only. The formula and source repository
remain untouched. The pool can retire after seven days without any workflow
job on its label and a catalog consumer check. Only the operator changes the
recovery variable; a retired pool label cannot serve as a fallback. Record PR
and main job runner names, labels, conclusions and durations before retirement.
