# modpm-mark(1) -- Mark Command

## SYNOPSIS

modpm mark \<subcommand> \[options] \<package>...

## DESCRIPTION

The `mark` command changes the installation reason for one or more installed packages.

## SUBCOMMANDS

`user`
:   Mark the specified packages as explicitly installed by the user.

`dependency`
:   Mark the specified packages as installed as dependencies.

## OPTIONS

`--skip-unavailable`
:   Allow skipping packages that are not installed.

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
