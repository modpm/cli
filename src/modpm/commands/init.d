module modpm.commands.init;

import std.json;
import std.net.curl;
import std.stdio;
import std.traits : EnumMembers;

import arsd.terminal : UserInterruptionException;
import cmd;
import libmodpm.inventory.Config;
import libmodpm.registry.ReleaseChannel;
import modpm.tui.prompt;
import modpm.tui.select;

public final class InitCommand : Command {
    public static auto immutable TYPE_NAMES = [
        Config.Type.MOD: "Mod",
        Config.Type.PLUGIN: "Plugin",
        Config.Type.RESOURCE_PACK: "Resource pack",
        Config.Type.SHADER: "Shader",
        Config.Type.DATA_PACK: "Data pack",
    ];

    public static auto immutable LOADER_NAMES = [
        Config.Loader.BABRIC: "Babric",
        Config.Loader.BTA_BABRIC: "BTA (Babric)",
        Config.Loader.BUKKIT: "Bukkit",
        Config.Loader.BUNGEECORD: "BungeeCord",
        Config.Loader.CANVAS: "Canvas",
        Config.Loader.DATAPACK: TYPE_NAMES[Config.Type.DATA_PACK],
        Config.Loader.FABRIC: "Fabric",
        Config.Loader.FOLIA: "Folia",
        Config.Loader.FORGE: "Forge",
        Config.Loader.IRIS: "Iris",
        Config.Loader.JAVA_AGENT: "Java Agent",
        Config.Loader.LEGACY_FABRIC: "Legacy Fabric",
        Config.Loader.LITELOADER: "LiteLoader",
        Config.Loader.MINECRAFT: "Minecraft",
        Config.Loader.MODLOADER: "Risugami’s ModLoader",
        Config.Loader.NEOFORGE: "NeoForge",
        Config.Loader.NILLOADER: "NilLoader",
        Config.Loader.OPTIFINE: "OptiFine",
        Config.Loader.ORNITHE: "Ornithe",
        Config.Loader.PAPER: "Paper",
        Config.Loader.PURPUR: "Purpur",
        Config.Loader.QUILT: "Quilt",
        Config.Loader.RIFT: "Rift",
        Config.Loader.SPIGOT: "Spigot",
        Config.Loader.SPONGE: "Sponge",
        Config.Loader.VANILLA: "Vanilla",
        Config.Loader.VELOCITY: "Velocity",
        Config.Loader.WATERFALL: "Waterfall",
    ];

    public static auto immutable ENV_NAMES = [
        Config.Environment.SERVER: "Server",
        Config.Environment.CLIENT: "Client",
    ];

    public static auto immutable CHANNEL_NAMES = [
        ReleaseChannel.RELEASE: "Stable \x1b[2m– only stable versions\x1b[22m",
        ReleaseChannel.BETA:    "Beta   \x1b[2m– beta and stable versions\x1b[22m",
        ReleaseChannel.ALPHA:   "Alpha  \x1b[2m– alpha, beta, and stable versions\x1b[22m",
    ];

    this() {
        super("init")
            .description("Initialise a directory to manage.")
            .action((args) {
                try {
                    writeln("\x1b[1mType of packages that will be managed\x1b[0m");
                    Config.Type type = new Select!(Config.Type)()
                        .labelFormat((v) => "  " ~ TYPE_NAMES[v] ~ " ")
                        .selectedFormat((v) => " ✔ " ~ TYPE_NAMES[v])
                        .get();
                    writeln();

                    auto compat = Config.TYPE_COMPATIBILITY[type];

                    Config.Loader loader;
                    if (compat.loaders.length == 1)
                        loader = compat.loaders[0];
                    else {
                        writefln("\x1b[1mSelect %s loader\x1b[0m", cast(string) type);
                        loader = new Select!(Config.Loader)(compat.loaders)
                            .labelFormat((v) => "  " ~ LOADER_NAMES[v] ~ " ")
                            .selectedFormat((v) => " ✔ " ~ LOADER_NAMES[v])
                            .get();
                        writeln();
                    }

                    Config.Environment env;
                    if (compat.environments.length == 1)
                        env = compat.environments[0];
                    else {
                        writefln("\x1b[1mSelect environment\x1b[0m");
                        env = new Select!(Config.Environment)(compat.environments)
                            .labelFormat((v) => "  " ~ ENV_NAMES[v] ~ " ")
                            .selectedFormat((v) => " ✔ " ~ ENV_NAMES[v])
                            .get();
                        writeln();
                    }

                    writeln("\x1b[1mRelease channel\x1b[0m");
                    ReleaseChannel channel = new Select!ReleaseChannel()
                        .labelFormat((v) => "  " ~ CHANNEL_NAMES[v] ~ " ")
                        .selectedFormat((v) => " ✔ " ~ CHANNEL_NAMES[v])
                        .get();
                    writeln();

                    write("\x1B[?25l\x1b[3m\x1b[2mFetching versions…\x1b[0m");
                    stdout.flush();
                    string[] versions;
                    JSONValue versionManifest = parseJSON(get("https://api.modrinth.com/v2/tag/game_version"));

                    foreach (ver; versionManifest.array)
                        versions ~= ver["version"].str;
                    write("\x1B[?25h\r");

                    string ver = new Prompt("\x1b[1mSelect version:\x1b[0m ")
                        .completions(versions)
                        .validator(versions)
                        .get();

                    writefln("Selected type=%s loader=%s env=%s channel=%s ver=%s", type, loader, env, channel, ver);

                    return 0;
                }
                catch (UserInterruptionException e) {
                    return 130;
                }
            });
    }
}
