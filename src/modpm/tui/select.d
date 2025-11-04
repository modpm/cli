module modpm.tui.select;

import core.stdc.stdlib;
import std.algorithm;
import std.range;
import std.stdio;
import std.string;

import arsd.terminal;

class Select {
    private string message;
    private string[] options;
    private size_t selected;

    public this(string message, string[] opts) {
        if (opts.length < 2)
            throw new Exception("Select requires at least 2 options");
        this.message = message;
        this.options = opts.dup;
        this.selected = 0;
    }

    public string get() {
        auto term = Terminal(ConsoleOutputType.linear);
        auto input = RealTimeConsoleInput(&term, ConsoleInputFlags.raw);

        term.hideCursor();
        scope (exit) term.showCursor();

        size_t maxLen = 0;
        foreach (opt; options)
            if (opt.length > maxLen)
                maxLen = opt.length;

        int printed = 0;

        while (true) {
            if (printed > 0)
                term.moveTo(0, term.cursorY - printed + 1, ForceOption.automatic);

            printed = 0;
            term.writeln(message);
            ++printed;

            foreach (i, opt; options) {
                auto line = " " ~ opt ~ repeat(' ', maxLen - opt.length + 1).array;
                if (i == selected)
                    term.writef(" %s%s%s", "\x1b[7m", line, "\x1b[0m");
                else
                    term.writef(" %s", line);

                if (i + 1 != options.length)
                    term.writeln();
                ++printed;
            }

            term.flush();

            dchar c;
            try c = input.getch();
            catch (UserInterruptionException)
                exit(130);

            switch (c) {
                case KeyboardEvent.Key.UpArrow:
                    selected = (selected + options.length - 1) % options.length;
                    break;
                case KeyboardEvent.Key.DownArrow:
                    selected = (selected + 1) % options.length;
                    break;
                case KeyboardEvent.Key.Home:
                    selected = 0;
                    break;
                case KeyboardEvent.Key.End:
                    selected = options.length - 1;
                    break;
                case '\r':
                case '\n':
                    term.writeln();
                    return options[selected];
                default:
                    break;
            }
        }
    }
}
