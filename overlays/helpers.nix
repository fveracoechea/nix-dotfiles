# Custom globally available helper functions
# accessed via `pkgs.helpers`
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
      final.writers.writeDenoBin name (prev.lib.fileContents ../scripts/${name}.ts);

    # Creates deno packages
    mkDenoDerivation = {
      src,
      name,
      entryPoint ? "mod.ts",
      denoFlags ? [],
    }:
      prev.stdenv.mkDerivation {
        inherit src;
        inherit name;
        buildPhase = ''
          DENO_DIR=$(mktemp -d)
          export DENO_DIR

          ${prev.deno}/bin/deno compile -A -o ${name} ${entryPoint}
        '';

        installPhase = ''
          mkdir -p "$out/bin"
          mv ${name} "$out/bin/"
        '';
      };
  };
}
