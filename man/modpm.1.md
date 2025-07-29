# modpm(1) -- Modrinth Package Manager

## SYNOPSIS

modpm \<command> \[options] \[\<args...>]

## DESCRIPTION

`modpm` is a command-line package manager for Modrinth projects. It allows users to install, upgrade, and remove
Modrinth projects as packages. `modpm` supports managing any project type available on Modrinth, providing standard
package management functionalities tailored to Modrinth’s ecosystem.

## COMMANDS

Here is a list of the available commands. For detailed information on each command’s usage and options, see the
respective manual pages, for example, `man modpm install`.

`autoremove`
:   Remove unneeded packages.

`history`
:   Manage transaction history.

`info`
:   Provide detailed information about installed or available packages.

`init`
:   Initialise a directory to manage.

`install`
:   Install packages.

`list`
:   List installed packages.

`mark`
:   Change the reason for a package to be installed.

`reinstall`
:   Reinstall packages.

`remove`
:   Remove packages.

`search`
:   Search for packages using keywords.

`upgrade`
:   Upgrade packages.

`versionlock`
:   Protect packages from being changed.

## OPTIONS

The following options are available for all `modpm` commands:

`-h`, `--help`
:   Show the help.

`-v`, `--version`
:   Show the version of the modpm CLI and libmodpm library.

## EXIT STATUS

The `modpm` command exits with the following exit codes:

`0`
:   Operation succeeded.

`1`
:   An error occurred during the operation.

`2`
:   An error occurred during processing of arguments.

`3`
:   A network error occurred.

`130`
:   Operation cancelled by user.

## FILES

`.modpm/`
:   Directory created by `modpm init` to mark the scope of package management.

`.modpm/bak/`
:   Backup directory where packages pending removal are temporarily stored.

`.modpm/config.json`
:   Configuration file created during initialisation. Can be edited to change settings.

`.modpm/history.json`
:   Transaction history log. Modifying manually is not advised.

`.modpm/manifest.json`
:   Manifest of the installed packages. Modifying manually is not advised.

## SEE ALSO

modpm-autoremove(1), modpm-history(1), modpm-info(1), modpm-init(1), modpm-install(1), modpm-list(1), modpm-mark(1), modpm-reinstall(1), modpm-remove(1), modpm-search(1), modpm-upgrade(1), modpm-versionlock(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
