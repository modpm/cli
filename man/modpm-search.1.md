# modpm-search(1) -- Search Command

## SYNOPSIS

modpm search \[options] \[query...]

modpm search --list-categories

## DESCRIPTION

The `search` command queries available packages on Modrinth. When no query is provided, all packages matching any
filters are returned.

When `--list-categories` is specified, the command displays the full list of available categories instead of performing
a search.

## OPTIONS

`-c`, `--category=NAME,...`
:   Show only packages that are tagged with all the specified categories.

`-n`, `--not-category=NAME,...`
:   Exclude packages that have tagged with any of the specified categories.

`-o`, `--open-source`
:   Show only packages published under an open source licence.

`--sort=<relevance|downloads|follows|newest|updated>`
:    Sort results by relevance (default), downloads, follows, newest published, or most recently updated.

`--limit=COUNT`
:    Limit the number of search results displayed (default: 20).

`--page=PAGE`
:    Show the specified page of search results (1-based index).

## EXAMPLES

`modpm search -c=economy -n=game-mechanics -o bank`
:   Search for open source packages matching `bank` tagged with `economy` but excluding those tagged with
`game-mechanics`.

`modpm search -c social voice chat`
:   Search for packages matching `voice chat` tagged with `social`.

`modpm search --list-categories`
:   List all available categories.

## SEE ALSO

modpm-info(1), modpm-install(1), modpm-list(1)

## COPYRIGHT

Copyright 2025 Zefir Kirilov. modpm is available under the GPL-3.0 licence.
See <https://github.com/modpm/cli/blob/main/COPYING> for the full licence text.
