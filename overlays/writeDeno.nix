final: prev: {
  writers =
    prev.writers
    // rec {
      # Takes a name and some TS sourcecode and returns an executable
      writeDeno = name: content:
        prev.writers.writeDash name
        # bash
        ''
          exec ${prev.lib.getExe prev.deno} -A ${prev.writeText "ts" content} "$@"
        '';

      # Takes the same arguments as writeDeno but outputs a directory (like writeScriptBin)
      writeDenoBin = name: writeDeno "/bin/${name}";
    };
}
