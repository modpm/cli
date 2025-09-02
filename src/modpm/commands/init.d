module modpm.commands.init;

import std.stdio;

import commandr.program;
import commandr.args;

import modpm.commands.custom;

public final class InitCommand : Command, CustomCommand {
    this() {
        super("init", "Initialise a directory to manage.");
    }

    public override int action(ProgramArgs args) {
        writeln("init");
        return 0;
    }
}
