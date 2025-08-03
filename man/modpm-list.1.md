# modpm-list(1) -- List Command

## SYNOPSIS

modpm list \[options]

## DESCRIPTION

The `list` command displays all packages currently installed.

## OPTIONS

`--user`
:   Show only packages that were explicitly installed by the user.

`--dependencies`
:   Show only packages that were installed as dependencies.

`--deps-of=PACKAGE_NAME,...`
:   Show only packages that are dependencies of the specified packages.

`--rdeps-of=PACKAGE_NAME,...`
:   Show only packages that depend on the specified packages.

`--autoremove`
:   Show only packages that will be removed by the <u>autoremove</u> command.

## SEE ALSO

modpm-info(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
