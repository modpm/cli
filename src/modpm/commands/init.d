module modpm.commands.init;

import std.stdio;

import cmd;

public final class InitCommand : Command {
    this() {
        super("init")
            .description("Initialise a directory to manage.")
            .action((args) {
                return 0;
            });
    }
}
