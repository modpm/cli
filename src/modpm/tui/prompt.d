module modpm.tui.prompt;

import arsd.terminal;
import std.string : strip;
import std.algorithm : startsWith, canFind;
import std.conv : to;

public class Prompt {
    private string message;
    private string delegate(string) _formatter;
    private string[] _completions;
    private bool _strictMode = false;

    public this(string message) {
        this.message = message;
        this._formatter = (s) => s.strip();
        this._completions = [];
    }

    public Prompt completions(string[] comps) {
        _completions = comps;
        return this;
    }

    public Prompt formatter(string delegate(string) dg) {
        _formatter = dg;
        return this;
    }

    public Prompt strict(bool strict = true) {
        _strictMode = strict;
        return this;
    }

    public string get() {
        Terminal terminal = Terminal(ConsoleOutputType.linear);
        auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.raw);

        string buf;
        size_t pos = 0;

        while (true) {
            terminal.hideCursor();
            terminal.moveTo(0, terminal.cursorY);
            terminal.clearToEndOfLine();
            terminal.write(message);

            bool valid = _strictMode && _completions.canFind(buf);
            string colorStart = (_strictMode && buf.length != 0) ? (valid ? "\x1b[32m" : "\x1b[31m") : "";
            string colorEnd = colorStart.length != 0 ? "\x1b[0m" : "";
            terminal.write(colorStart ~ buf ~ colorEnd);
            int bufEndX = terminal.cursorX;

            string sugg;
            foreach (c; _completions)
                if (c.startsWith(buf)) {
                    sugg = c[buf.length .. $];
                    break;
                }

            if (sugg.length != 0) {
                terminal.write("\x1b[90m");
                terminal.write(sugg);
                terminal.write("\x1b[0m");
            }

            terminal.moveTo(0, terminal.cursorY);
            terminal.write(message);
            terminal.write(colorStart ~ buf[0..pos] ~ colorEnd);
            int cursorX = terminal.cursorX;
            int cursorY = terminal.cursorY;

            terminal.moveTo(cursorX, cursorY);
            terminal.showCursor();
            terminal.flush();

            auto ch = input.getch();

            switch (ch) {
                case '\t':
                    if (sugg.length != 0) {
                        buf ~= sugg;
                        pos = buf.length;
                    }
                    break;

                case '\b':
                    if (pos > 0) {
                        buf = buf[0 .. pos-1] ~ buf[pos .. $];
                        pos--;
                    }
                    break;

                case '\n':
                case '\r':
                    if (!_strictMode || _completions.canFind(buf)) {
                        terminal.moveTo(bufEndX, terminal.cursorY);
                        terminal.clearToEndOfLine();
                        terminal.writeln("");
                        return (_formatter !is null) ? _formatter(buf) : buf;
                    }
                    break;

                case KeyboardEvent.Key.Delete:
                    if (pos < buf.length) buf = buf[0 .. pos] ~ buf[pos+1 .. $];
                    break;

                case KeyboardEvent.Key.LeftArrow:
                    if (pos > 0) pos--;
                    break;

                case KeyboardEvent.Key.RightArrow:
                    if (pos < buf.length) pos++;
                    else if (pos == buf.length && sugg.length != 0) {
                        buf ~= sugg;
                        pos = buf.length;
                    }
                    break;

                case KeyboardEvent.Key.Home:
                    pos = 0;
                    break;

                case KeyboardEvent.Key.End:
                    pos = buf.length;
                    break;

                case '\0': break;

                case '\u000b':
                    buf = buf[0 .. pos];
                    break;

                default:
                    buf = buf[0 .. pos] ~ ch.to!string ~ buf[pos .. $];
                    pos++;
                    break;
            }
        }
    }
}
