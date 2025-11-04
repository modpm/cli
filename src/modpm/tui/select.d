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
    private string delegate(T) _selectedFormat;
    private string delegate(T) _labelFormat;

    public this(immutable(T[]) opts) {
        if (opts.length < 2)
            throw new Exception("Select requires at least 2 options");
        this.options = opts.dup;
        this.selected = 0;

        this._selectedFormat = (v) => v;
        this._labelFormat = (v) => v;
    }

    static if (is(T == enum)) this() {
        this([EnumMembers!T]);
    }

    public auto selectedFormat(string delegate(T) formatter) {
        this._selectedFormat = formatter;
        return this;
    }

    public auto labelFormat(string delegate(T) formatter) {
        this._labelFormat = formatter;
        return this;
    }

    public T get() {
        auto term = Terminal(ConsoleOutputType.linear);
        auto input = RealTimeConsoleInput(&term, ConsoleInputFlags.raw);

        term.hideCursor();
        scope (exit) term.showCursor();

        size_t maxLen = 0;
        foreach (opt; options) {
            auto labelLength = _labelFormat(opt).length;
            if (labelLength > maxLen)
                maxLen = labelLength;
        }

        int printed = 0;

        while (true) {
            if (printed > 0)
                term.moveTo(0, term.cursorY - printed + 1, ForceOption.automatic);

            printed = 0;

            foreach (i, opt; options) {
                auto label = _labelFormat(opt);
                auto line = label ~ repeat(' ', maxLen - label.length).array;
                if (i == selected)
                    term.writef("%s%s%s", "\x1b[7m", line, "\x1b[0m");
                else
                    term.writef("%s", line);

                if (i + 1 != options.length)
                    term.writeln();
                ++printed;
            }

            term.flush();

            dchar c = input.getch();

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
                    term.writeln(_selectedFormat(options[selected]));
                    term.flush();

                    return options[selected];
                default:
                    break;
            }
        }
    }
}
