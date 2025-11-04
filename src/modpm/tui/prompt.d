module modpm.tui.prompt;

import std.stdio;
import std.string;

public class Prompt {
    private string message;
    private string delegate(string) _formatter;

    public this(string message) {
        this.message = message;
        this._formatter = (s) => s.strip();
    }

    public auto formatter(string delegate(string) dg) {
        this._formatter = dg;
        return this;
    }

    public string get() {
        while(true) {
            write(message);
            stdout.flush();
            string line = readln();

            if (_formatter !is null)
                return _formatter(line);
            return line;
        }
    }
}
