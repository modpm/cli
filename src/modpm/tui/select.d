module modpm.tui.select;

import core.stdc.stdlib;
import std.algorithm;
import std.range;
import std.stdio;
import std.string;
import std.traits : EnumMembers;

import arsd.terminal;

class Select(T = string) {
    private T[] options;
    private size_t selected;
    private string selectedFormat;

    public this(immutable(T[]) opts, string selectedFormat = "%s") {
        if (opts.length < 2)
            throw new Exception("Select requires at least 2 options");
        this.options = opts.dup;
        this.selected = 0;
        this.selectedFormat = selectedFormat;
    }

    static if (is(T == enum)) this(string selectedFormat = "%s") {
        this([EnumMembers!T], selectedFormat);
    }

    public T get() {
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

            foreach (i, opt; options) {
                auto line = "  " ~ cast(string) opt ~ repeat(' ', maxLen - opt.length + 1).array;
                if (i == selected)
                    term.writef("%s%s%s", "\x1b[7m", line, "\x1b[0m");
                else
                    term.writef("%s", line);

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
                    term.moveTo(0, term.cursorY - printed + 1, ForceOption.automatic);

                    foreach (i; 0 .. printed) {
                        term.write("\x1b[2K");
                        if (i < printed - 1)
                            term.writeln();
                    }
                    term.moveTo(0, term.cursorY - (printed - 1), ForceOption.automatic);
                    term.writefln(selectedFormat, cast(string) options[selected]);
                    term.flush();

                    return options[selected];
                default:
                    break;
            }
        }
    }
}
