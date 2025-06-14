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
in {
  keycloak-proxy = denoScript "keycloak-proxy";
  teams-proxy = denoScript "teams-proxy";
  tmux-git-status = denoScript "tmux-git-status";
  tmux-uptime = denoScript "tmux-uptime";
  tmux-os-icon = denoScript "tmux-os-icon";
}
