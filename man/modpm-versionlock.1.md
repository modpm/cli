# modpm-versionlock(1) -- Version Lock Command

## SYNOPSIS

modpm versionlock \<subcommand> \[package...]

## DESCRIPTION

The `versionlock` command manages package version locks, preventing any change to the installed version of a package.

## SUBCOMMANDS

`add`
:   Lock one or more installed packages to their current versions.

`clear`
:   Clear all package version locks.

`delete`
:   Remove the version lock from one or more specified packages.

`list`
:   List all installed packages with version locks.

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
