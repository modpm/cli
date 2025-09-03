import std.stdio;
import core.stdc.stdlib : exit;

import modpm.ver;
import modpm.commander;
import modpm.commands;

void main(string[] args) {
    new Program("modpm")
        .description("Modrinth package manager")
        .ver(cliVersion, "-v, --version", "Show version information.")
        .command(new InitCommand())
        .parse(args);
}
