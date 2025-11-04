module modpm.commands.init;

import std.stdio;
import std.traits : EnumMembers;

import cmd;
import libmodpm.inventory.Config;
import modpm.tui.prompt;
import modpm.tui.select;

public final class InitCommand : Command {
    this() {
        super("init")
            .description("Initialise a directory to manage.")
            .action((args) {
                string[] values = [EnumMembers!(Config.Loader)];
                writeln("Please select loader");
                auto o = new Select(values).get();
                writeln(o);
                return 0;
            });
    }
}
