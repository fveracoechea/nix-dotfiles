# Custom helper functions that can be accessed globally via `pkgs.helpers`
final: prev: {
  helpers = rec {
    # Takes a name and some TS sourcecode and returns an executable
    writeDeno = name: content:
      prev.writers.writeDash name
      # bash
      ''
        exec ${prev.lib.getExe prev.deno} -A ${prev.writeText "${name}-ts" content} "$@"
      '';

    # Takes the same arguments as writeDeno but outputs a directory (like writeScriptBin)
    writeDenoBin = name: writeDeno "/bin/${name}";

    # deno scripts from `scripts` directory
    denoScript = name:
      writeDenoBin name (prev.lib.fileContents ../scripts/${name}.ts);

    # deno scripts from `scripts` directory
    nodeJsScript = name:
      final.writers.writeJsBin name (prev.lib.fileContents ../scripts/${name}.js);
  };
}
