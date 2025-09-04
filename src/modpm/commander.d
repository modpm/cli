module modpm.commander;

import std.array;
import std.stdio;
import std.string;
import std.algorithm.searching;
import core.stdc.stdlib;

public class ArgumentException : Exception {
    public this(string problem, string name) {
        super("error: " ~ problem ~ " '" ~ name ~ "'");
    }
}

public class Program : BaseCommand!Program {
    private Flag _verFlag;
    private Command _verCommand;
    private Flag _helpFlag;

    public this(string name = null) {
        super(name);
    }

    public auto ver(string ver, Flag verFlag) {
        this.add(verFlag);
        this._verFlag = verFlag;
        return this.ver(ver);
    }

    public auto ver(string ver, Flag verFlag, Command verCommand) {
        this._verCommand = verCommand;
        return this.ver(ver, verFlag);
    }

    public auto ver(string ver, string option, string description) {
        auto names = BaseOption!Flag.parseName(option);
        return this.ver(ver, new Flag(names[0], names[1], description).preset(false));
    }

    public auto ver(string ver, string option, string description, Command verCommand) {
        this._verCommand = verCommand;
        return this.ver(ver, option, description);
    }

    public auto ver(string ver) {
        this._version = ver;
        if (this._verCommand is null)
            this._verCommand = new VersionCommand(this);
        return this;
    }

    public string getVersion() {
        return this._version;
    }

    public void parse(string[] args) {
        try {
            int status = handle(args);
            exit(status);
        }
        catch (ArgumentException e) {
            stderr.writefln(e.msg);
            exit(2);
        }
    }

    private int handle(string[] args) {
        ProgramOptions options = new ProgramOptions();
        ProgramArgs arguments = new ProgramArgs();

        const bool commandMode = _commands.length > 0;
        Command cmd = null;
        int firstArgument = -1;

        for (int i = 1; i < args.length; ++i) {
            string arg = args[i];
            if (arg.startsWith("-")) {
                string value = null;

                auto equals = arg.indexOf('=');
                if (equals > -1) {
                    arg = arg[0 .. equals];
                    value = arg[equals + 1 .. $];
                }

                auto flag = findOpt!Flag(_flags, arg);
                if (flag !is null) {
                    if (value !is null)
                        switch (value) {
                            case "true", "1", "yes":
                                flag._set();
                                break;
                            default:
                                throw new ArgumentException("invalid value for flag", arg);
                        }
                    else flag._set();
                    options._add(flag);
                    continue;
                }

                auto opt = findOpt!Option(_options, arg);
                if (opt is null)
                    throw new ArgumentException("unknown option", arg);

                if (value !is null)
                    opt._add(value);
                else if (i + 1 < args.length)
                    opt._add(args[++i]);
                else
                    throw new ArgumentException("missing value for option", arg);

                options._add(opt);
                continue;
            }

            if (commandMode && cmd is null) {
                cmd = getCommand(arg);
                if (cmd is null)
                    throw new ArgumentException("unknown command", arg);
                continue;
            }

            if (this._args.length == 0)
                throw new ArgumentException("unexpected argument", arg);

            if (firstArgument == -1)
                firstArgument = i;

            if (i - firstArgument >= this._args.length) {
                auto lastArgument = this._args[$];
                if (cast(ArgumentList) lastArgument) {
                    (cast(ArgumentList) lastArgument)._add(arg);
                    continue;
                }
                throw new ArgumentException("unexpected argument", arg);
            }

            auto argument = this._args[i - firstArgument];
            if (cast(Argument) argument)
                (cast(Argument) argument)._set(arg);
            else if (cast(ArgumentList) argument)
                (cast(ArgumentList) argument)._add(arg);
            else
                throw new Exception("Unrecognised argument type " ~ typeid(argument).toString()
                    ~ " for argument " ~ argument.name());
            arguments._add(argument);
        }

        if (_verFlag !is null && _verCommand !is null && _verFlag.get())
            return _verCommand._action(arguments, options);

        if (commandMode && cmd !is null)
            return cmd._action(arguments, options);
        else return this._action(arguments, options);
    }
}

public class BaseCommand(T) {
    static assert(is(T : BaseCommand!T), "T must be a subclass of Command!T");

    protected static findOpt(T)(T[] arr, string query) {
        foreach (item; arr)
            if (item._is(query))
                return item;
        return null;
    }

    protected BaseArgument findArg(string query) {
        foreach (arg; this._args)
            if (arg._name == query)
                return arg;
        return null;
    }

    protected string _name;
    protected string _description;
    protected string _version;

    protected Option[] _options = [];
    protected Flag[] _flags = [];
    protected BaseArgument[] _args = [];
    protected Command[] _commands = [];

    protected int delegate(ProgramArgs, ProgramOptions) _action = null;

    public this(string name = null) {
        this._name = name;
        this._action = (args, options) => 0;
    }

    public T name(string name) {
        this._name = name;
        return cast(T) this;
    }

    public T description(string description) {
        this._description = description;
        return cast(T) this;
    }

    public T add(Option option) {
        foreach (opt; this._options)
            if (opt._is(option))
                throw new Exception("Option " ~ option.name() ~ " conflicts with " ~ opt.name());
        this._options ~= option;
        return cast(T) this;
    }

    public T add(Flag flag) {
        foreach (flg; this._flags)
            if (flg._is(flag))
                throw new Exception("Flag " ~ flag.name() ~ " conflicts with " ~ flg.name());
        this._flags ~= flag;
        return cast(T) this;
    }

    public T add(Command command) {
        if (_args.length > 0)
            throw new Exception("Cannot add subcommands if there are arguments");
        if (command._name is null)
            throw new Exception("Cannot add command without a name");
        foreach (cmd; this._commands)
            if (cmd._name == command._name)
                throw new Exception("Command with name " ~ command._name ~ " already registered");
        this._commands ~= command;
        return cast(T) this;
    }

    public T add(BaseArgument arg) {
        if (_commands.length > 0)
            throw new Exception("Cannot add arguments if there are subcommands");
        if (arg.name is null)
            throw new Exception("Cannot add argument without a name");
        if (findArg(arg.name) !is null)
            throw new Exception("Argument with name " ~ arg.name ~ " already registered");
        if (this._args.length > 0 && cast(ArgumentList) this._args[$ - 1])
            throw new Exception("Cannot add further arguments after an ArgumentList");
        this._args ~= arg;
        return cast(T) this;
    }

    public T flag(string name, string description) {
        auto names = BaseOption!Flag.parseName(name);
        return add(new Flag(names[0], names[1], description));
    }

    public T option(string shortOption, string longOption, string description) {
        auto names = BaseOption!Option.parseName(shortOption ~ "," ~ longOption);
        return add(new Option(names[0], names[1], description));
    }

    public T command(Command command) {
        return add(command);
    }

    public T argument(string name, string description) {
        return add(new Argument(name, description));
    }

    public T action(int delegate(ProgramArgs, ProgramOptions) action) {
        this._action = action;
        return cast(T) this;
    }

    public Command getCommand(string name) {
        foreach (cmd; this._commands)
            if (cmd._name == name)
                return cmd;
        return null;
    }
}

public class Command : BaseCommand!Command {
    public this(string name = null) {
        super(name);
    }
}

private interface Named {
    public string name();
}

private class BaseOption(T) : Named {
    static assert(is(T : BaseOption), "T must be a subclass of BaseOption");

    public const string longOption;
    public const string shortOption;
    public const string description;
    protected bool _required = false;

    public static string[2] parseName(string name) {
        string[] parts = name.split(",");
        if (parts.length > 2 || parts.length == 0)
            throw new Exception("Invalid flag name: " ~ name);

        string s = parts.length < 2 ? null : parts[0].strip();
        if (s is null || s.length < 2 || s[0] != '-' || s[1] == '-')
            throw new Exception("Invalid short flag name: " ~ s);


        string l = parts.length < 2 ? parts[0].strip() : parts[1].strip();
        if (l.length < 3 || l[0] != '-' || l[1] != '-' || l[2] == '-')
        throw new Exception("Invalid long flag name: " ~ l);

        return [s is null ? null : s[1 .. $], l[2 .. $]];
    }

    public this(string shortOption, string longOption, string description) {
        this.shortOption = shortOption;
        this.longOption = longOption;
        this.description = description;
    }

    public this(string longOption, string description) {
        this(null, longOption, description);
    }

    public bool _is(string query) {
        return query == "--" ~ longOption || (shortOption !is null && query == "-" ~ shortOption);
    }

    public bool _is(BaseOption query) {
        return typeid(this) == typeid(query)
            && (this.longOption == query.longOption || this.shortOption == query.shortOption);
    }

    public string name() {
        return this.shortOption !is null
            ? "-" ~ this.shortOption ~ ", --" ~ this.longOption
            : "--" ~ this.longOption;
    }

    public T required() {
        this._required = true;
        return cast(T) this;
    }
}

public class Option : BaseOption!Option {
    protected string[] _values;
    protected string[] _default;

    public this(string shortOption, string longOption, string description) {
        super(shortOption, longOption, description);
    }

    public this(string longOption, string description) {
        this(null, longOption, description);
    }

    public auto preset(string[] value) {
        if (this._required)
            throw new Exception("Cannot set default value for required flag");
        this._default = value;
        return this;
    }

    public auto preset(string value) {
        return preset([value]);
    }

    public auto _add(string value, ...) {
        this._values ~= value;
        return this;
    }

    public bool satisfied() {
        return this._required ? this._default !is null || (this._values !is null && this._values.length > 0) : true;
    }

    public string[] getAll() {
        if (!satisfied())
            throw new ArgumentException("missing required option", "--" ~ this.name());
        return this._values is null ? this._default : this._values;
    }

    public string get() {
        return getAll()[0];
    }
}

public class Flag : BaseOption!Flag {
    protected bool _value;
    protected bool _default = false;

    public this(string shortOption, string longOption, string description) {
        super(shortOption, longOption, description);
    }

    public this(string longOption, string description) {
        this(null, longOption, description);
    }

    public auto preset(bool value) {
        if (this._required)
            throw new Exception("Cannot set default value for required flag");
        this._default = value;
        return this;
    }

    public auto _set() {
        this._value = true;
        return this;
    }

    public bool satisfied() {
        return this._required ? this._value || this._default : true;
    }

    public bool get() {
        if (!satisfied())
            throw new ArgumentException("missing required flag", name);
        return this._value || this._default;
    }
}

public class BaseArgument : Named {
    public const string _name;
    public const string description;
    protected bool _required = false;

    public this(string name, string description) {
        this._name = name;
        this.description = description;
    }

    public string name() {
        return this._name;
    }
}

public class Argument : BaseArgument {
    protected string _value;
    protected string _default = null;

    public this(string name, string description) {
        super(name, description);
    }

    public auto required() {
        this._required = true;
        return this;
    }

    public auto preset(string value) {
        if (this._required)
            throw new Exception("Cannot set default value for required argument");
        this._default = value;
        return this;
    }

    public auto _set(string value) {
        this._value = value;
        return this;
    }

    public bool satisfied() {
        return this._required ? this._default !is null || this._value !is null : true;
    }

    public string get() {
        if (!satisfied())
            throw new ArgumentException("missing required argument", name);
        return this._value is null ? this._default : this._value;
    }
}

public class ArgumentList : BaseArgument {
    public string[] values = [];
    protected string[] _default = [];

    public this(string name, string description) {
        super(name, description);
    }

    public auto required() {
        this._required = true;
        return this;
    }

    public auto preset(string[] value) {
        if (this._required)
            throw new Exception("Cannot set default value for required argument");
        this._default = value;
        return this;
    }

    public auto _add(string value, ...) {
        this.values ~= value;
        return this;
    }

    public bool satisfied() {
        return this._required ? this._default.length > 0 || this.values.length > 0 : true;
    }

    public string[] get() {
        if (!satisfied())
            throw new ArgumentException("missing required argument", name);
        return this.values.length == 0 ? this._default : this.values;
    }
}

public class ProgramOptions {
    private Option[] _options = [];
    private Flag[] _flags = [];

    public void _add(Option option) {
        foreach (opt; _options)
            if (opt._is(option))
                return;
        _options ~= option;
    }

    public void _add(Flag flag) {
        foreach (flg; _flags)
            if (flg._is(flag))
                return;
        _flags ~= flag;
    }

    public string[] options(string option) {
        foreach (opt; _options)
            if (opt._is(option))
                return opt.getAll();
        throw new Exception("Option not found: " ~ option);
    }

    public string option(string option) {
        auto opts = options(option);
        return opts.length > 0 ? opts[0] : null;
    }

    public bool flag(string flag) {
        foreach (f; _flags)
            if (f._is(flag))
                return f.get();
        return false;
    }
}

public class ProgramArgs {
    private BaseArgument[string] _args;

    public void _add(BaseArgument arg) {
        foreach (a; _args)
            if (a.name == arg.name)
                return;
        _args[arg.name] = arg;
    }

    public string[] args(string name) {
        if (name !in _args)
            throw new Exception("Argument not found: " ~ name);
        auto arg = cast(Argument) _args[name];
        if (arg)
            return [arg.get()];
        auto args = cast(ArgumentList) _args[name];
        if (args)
            return args.get();
        throw new Exception("Unrecognised argument type " ~ typeid(_args[name]).toString() ~ " for argument " ~ name);
    }

    public string arg(string name) {
        auto args = this.args(name);
        return args.length > 0 ? args[0] : null;
    }
}

public final class VersionCommand : Command {
    public this(Program program) {
        super(null)
            .description("Show version information.");
        super
            .action((args, options) {
                writeln(program.getVersion());
                return 0;
            });
    }
}
