import std.stdio;
import core.stdc.stdlib : exit;

import commandr;

import modpm.ver;
import modpm.commands;

void main(string[] args) {
    Program program = new Program("modpm", cliVersion)
        .summary("Modrinth package manager")
        .add(new InitCommand());

    ProgramArgs programArgs = program.parse(args);
    Command[string] commands = program.commands();

    foreach (label, command; commands) {
        auto custom = cast(CustomCommand) command;
        if (custom is null)
            continue;

        programArgs.on(label, (args) {
            exit(custom.action(args));
        });
    }
}
