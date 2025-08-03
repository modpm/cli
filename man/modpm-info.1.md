# modpm-info(1) -- Info Command

## SYNOPSIS

modpm info \[options] \[\<package\[:version\]>]

## DESCRIPTION

The `info` command displays detailed information about an installed package managed by modpm in the active scope, or
available packages on Modrinth.

A specific version may be selected using a colon (:) delimiter. If no version is specified, information about any
installed version and the latest available version is shown.

## OPTIONS

`--all-deps`
:   Lists all required dependencies, both direct and transitive.

## SEE ALSO

modpm-search(1), modpm-list(1), modpm-install(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
