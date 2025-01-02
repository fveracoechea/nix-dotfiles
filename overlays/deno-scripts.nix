final: prev: {
  writers =
    prev.writers
    // rec {
      # Takes a name and some TS sourcecode and returns an executable
      writeDeno = name: content:
        prev.writers.writeDash name
        # bash
        ''
          exec ${prev.lib.getExe prev.deno} -A ${prev.writeText "${name}-ts" content} "$@"
        '';

      # Takes the same arguments as writeDeno but outputs a directory (like writeScriptBin)
      writeDenoBin = name: writeDeno "/bin/${name}";
    };

  lib =
    prev.lib
    // {
      denoScript = name:
        final.writers.writeDenoBin name (prev.lib.fileContents ../scripts/${name}.ts);
    };
}
