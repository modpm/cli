module modpm.commands.init;

import std.stdio;

import cmd;
import modpm.tui.prompt;
import modpm.tui.select;

public final class InitCommand : Command {
    this() {
        super("init")
            .description("Initialise a directory to manage.")
            .action((args) {
                auto o = new Select("Please select", ["Hello world!", "Hi", "A much longer option"]).get();
                writeln(o);
                return 0;
            });
    }
}
