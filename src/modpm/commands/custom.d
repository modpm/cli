module modpm.commands.custom;

import commandr.args;

public interface CustomCommand {
    public int action(ProgramArgs args);
}
