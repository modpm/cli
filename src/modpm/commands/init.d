module modpm.commands.init;

import std.stdio;

import modpm.commander;

public final class InitCommand : Command {
    this() {
        super("init")
            .description("Initialise a directory to manage.")
            .flag("-t, --test", "Test flag")
            .action((args, options) {
                writeln("Init command!");
                return 0;
            });
    }
}
