import std.stdio;
import core.stdc.stdlib : exit;

import modpm.ver;
import cmd;
import modpm.commands;

void main(string[] args) {
    new Program("modpm")
        .description("Modrinth package manager")
        .versionString(cliVersion)
        .versionOption("--version", "Show version information")
        .helpOption("-h, --help", "Show help for command")
        .command(new InitCommand())
        .command(new HelpCommand())
        .run(args);
}
