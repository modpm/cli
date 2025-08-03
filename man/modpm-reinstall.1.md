# modpm-reinstall(1) -- Reinstall Command

## SYNOPSIS

modpm reinstall \[options] \[package...]

## DESCRIPTION

The `reinstall` command reinstalls packages in the active scope.

When one or more packages are specified, only those packages are checked and reinstalled if necessary.

When no packages are specified, all installed packages are checked and reinstalled if needed. The command may also
suggest removal of packages found on disk that are not recorded in the manifest. Packages not available on Modrinth are
always ignored.

## OPTIONS

`--no-remove`
:   Skip removing Modrinth packages found on disk that are not recorded in the manifest.

## SEE ALSO

modpm-list(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
