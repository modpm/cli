# modpm-init(1) -- Init Command

## SYNOPSIS

modpm init \[options]

## DESCRIPTION

The `init` command interactively initialises a new modpm scope in the current directory, setting up the necessary
metadata and configuration for package management within the scope.

It attempts to detect packages already present in the scope. Packages unavailable on Modrinth are reported with a
warning, while recognised packages may be imported into the manifest for modpm to manage.

## SEE ALSO

modpm(1), modpm-mark(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
