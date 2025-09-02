module modpm.ver;

import std.string;

version (BuildVersion)
    enum cliVersion = import("ver.txt").strip();
else
    enum cliVersion = "0.0.0-dev";
