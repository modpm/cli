module modpm.tui.prompt;

import arsd.terminal;
import std.string : strip;
import std.algorithm : startsWith;
import std.conv : to;

public class Prompt {
    private string message;
    private string delegate(string) _formatter;
    private string delegate(string) _completions;
    private bool delegate(string) _validator;
    private string currentSuggestion;

    public this(string message) {
        this.message = message;
        this._formatter = (s) => s.strip();
    }

    public Prompt completions(string[] values) {
        _completions = (string buf) {
            foreach (s; values) {
                if (s.startsWith(buf))
                    return s;
            }
            return "";
        };
        return this;
    }

    public Prompt completions(string delegate(string) func) {
        _completions = func;
        return this;
    }

    public Prompt validator(string[] validValues) {
        _validator = (string buf) {
            foreach (v; validValues)
                if (v == buf)
                    return true;
            return false;
        };
        return this;
    }

    public Prompt validator(bool delegate(string) func) {
        _validator = func;
        return this;
    }

    public Prompt formatter(string delegate(string) func) {
        _formatter = func;
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

            string colorStart = (_validator !is null) ? (_validator(buf) ? "\x1b[32m" : "\x1b[31m") : "";
            string colorEnd = colorStart.length != 0 ? "\x1b[0m" : "";
            terminal.write(colorStart ~ buf ~ colorEnd);
            int bufEndX = terminal.cursorX;

            string sugg;
            if (_completions !is null) {
                if (currentSuggestion.length == 0 || !currentSuggestion.startsWith(buf))
                    currentSuggestion = _completions(buf);

                if (currentSuggestion.startsWith(buf))
                    sugg = currentSuggestion[buf.length .. $];
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
                        currentSuggestion = "";
                    }
                    break;

                case '\b':
                    if (pos > 0) {
                        buf = buf[0 .. pos-1] ~ buf[pos .. $];
                        --pos;
                        if (!currentSuggestion.startsWith(buf))
                            currentSuggestion = "";
                    }
                    break;

                case '\n':
                case '\r':
                    if (_validator is null || _validator(buf)) {
                        terminal.moveTo(bufEndX, terminal.cursorY);
                        terminal.clearToEndOfLine();
                        terminal.writeln("");
                        return (_formatter !is null) ? _formatter(buf) : buf;
                    }
                    break;

                case KeyboardEvent.Key.Delete:
                    if (pos < buf.length) {
                        buf = buf[0 .. pos] ~ buf[pos+1 .. $];
                        if (!currentSuggestion.startsWith(buf))
                            currentSuggestion = "";
                    }
                    break;

                case KeyboardEvent.Key.LeftArrow:
                    if (pos > 0) --pos;
                    break;

                case KeyboardEvent.Key.RightArrow:
                    if (pos < buf.length) ++pos;
                    else if (pos == buf.length && sugg.length != 0) {
                        buf ~= sugg;
                        pos = buf.length;
                        currentSuggestion = "";
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
                    if (!currentSuggestion.startsWith(buf))
                        currentSuggestion = "";
                    break;

                default:
                    buf = buf[0 .. pos] ~ ch.to!string ~ buf[pos .. $];
                    ++pos;
                    if (!currentSuggestion.startsWith(buf))
                        currentSuggestion = "";
                    break;
            }
        }
    }
}
