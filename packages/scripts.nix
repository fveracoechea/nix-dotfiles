{
  lib,
  writers,
  writeText,
  deno,
  ...
}: let
  # Takes a name and some TS sourcecode and returns an executable
  writeDeno = name: content:
    writers.writeDash name
    # bash
    ''
      exec ${lib.getExe deno} -A ${writeText "${name}-ts" content} "$@"
    '';

  # Takes the same arguments as writeDeno but outputs a directory (like writeScriptBin)
  writeDenoBin = name: writeDeno "/bin/${name}";

  # deno scripts from `scripts` directory
  denoScript = name:
    writeDenoBin name (lib.fileContents ./scripts/${name}.ts);

  # deno scripts from `scripts` directory
  nodeJsScript = name:
    writers.writeJSBin name {} (lib.fileContents ./scripts/${name}.js);
in {
  # Node Scripts
  keycloak-proxy = nodeJsScript "keycloak-proxy";
  # Deno Scripts
  tmux-git-status = denoScript "tmux-git-status";
  tmux-uptime = denoScript "tmux-uptime";
  tmux-os-icon = denoScript "tmux-os-icon";
  deno-keycloak-proxy = denoScript "deno-keycloak-proxy";
}
