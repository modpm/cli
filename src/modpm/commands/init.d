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
                writeln("Type of packages that will be managed");
                Config.Type type = new Select!(Config.Type)([EnumMembers!(Config.Type)]).get();
                writeln(type);
                return 0;
            });
    }
}
