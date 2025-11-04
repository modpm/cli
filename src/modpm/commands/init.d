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
                writeln("\x1b[1mType of packages that will be managed\x1b[0m");
                Config.Type type = new Select!(Config.Type)(" ✔ %s").get();
                writeln();
                
                auto compat = Config.TYPE_COMPATIBILITY[type];
                
                Config.Loader loader;
                if (compat.loaders.length == 1)
                    loader = compat.loaders[0];
                else {
                    writefln("\x1b[1mSelect %s loader\x1b[0m", cast(string) type);
                    loader = new Select!(Config.Loader)(compat.loaders, " ✔ %s").get();
                    writeln();
                }
                
                Config.Environment env;
                if (compat.environments.length == 1)
                    env = compat.environments[0];
                else {
                    writefln("\x1b[1mSelect environment\x1b[0m");
                    env = new Select!(Config.Environment)(compat.environments, " ✔ %s").get();
                    writeln();
                }
                
                writefln("Selected type=%s loader=%s env=%s", type, loader, env);
                
                return 0;
            });
    }
}
