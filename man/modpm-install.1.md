# modpm-install(1) -- Install Command

## SYNOPSIS

modpm install \[options] \<package\[:version]...>

## DESCRIPTION

The `install` command installs one or more Modrinth projects as packages. modpm resolves and installs all required
dependencies unless the target package is already installed. In that case, no dependency resolution is performed, and
modpm only verifies that the package is present. Only one version of each package may be installed at any given time.

Each package may optionally specify a version using a colon (:) delimiter. If no version is specified, the latest
compatible version is selected.

## OPTIONS

`--ignore-installed`
:   Ignore packages that are already installed.

`--skip-broken`
:   Allow skipping packages that cannot be installed due to dependency conflicts.

`--skip-unavailable`
:   Allow skipping packages that cannot be found on Modrinth.

`-y`, `--assumeyes`
:   Automatically answer yes to all prompts.

## EXAMPLES

`modpm install foo bar`
:   Install the latest versions of `foo` and `bar`.

`modpm install foo:1.2.3 bar`
:   Install the defined version for `foo` and the latest version for `bar`.

# SEE ALSO

modpm-reinstall(1), modpm-upgrade(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
