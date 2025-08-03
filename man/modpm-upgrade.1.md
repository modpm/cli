# modpm-upgrade(1) -- Upgrade Command

## SYNOPSIS

modpm upgrade \[options] \[package...]

## DESCRIPTION

The `upgrade` command updates installed packages to their latest compatible versions by querying the Modrinth registry
for available updates.

When no packages are specified, the command attempts to upgrade all installed packages to their latest compatible
versions. If one or more package names are provided, only those packages are considered for upgrade.

## OPTIONS

`--skip-broken`
:   Allow skipping packages that cannot be upgraded due to dependency conflicts.

`--skip-unavailable`
:   Allow skipping packages that cannot be found on Modrinth.

`-y`, `--assumeyes`
:   Automatically answer yes to all prompts.

## SEE ALSO

modpm-list(1), modpm-install(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
