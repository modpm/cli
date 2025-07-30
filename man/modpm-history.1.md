# modpm-history(1) -- History Command

## SYNOPSIS

modpm history \<subcommand> \[options] \[\<transaction-id>]

## DESCRIPTION

The `history` command displays the transaction history of modpm, allowing users to review past operations, restore the
system to a previous state, or retry incomplete transactions.

## SUBCOMMANDS

`list`
:   List recorded transactions.

`info`
:   Display details about a specific transaction.

`redo`
:   Repeat the specified transaction.

`revert`
:   Revert the specified and all subsequent transactions.

## OPTIONS FOR LIST

`--reverse`
:   List transactions in reverse chronological order.

`--contains-pkgs=PACKAGE_NAME,...`
:   Show only transactions containing the specified package names.

`-n`, `--limit=COUNT`
:   Limit the number of transactions displayed.

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
