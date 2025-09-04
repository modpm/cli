import std.stdio;
import core.stdc.stdlib : exit;

import modpm.ver;
import modpm.commander;
import modpm.commands;

void main(string[] args) {
    new Program("modpm")
        .description("Modrinth package manager")
        .ver(cliVersion, "-v, --version", "Show version information.")
        .helpOption("-h, --help", "Show help for command.")
        .command(new InitCommand())
        .command(new HelpCommand())
        .parse(args);
}
