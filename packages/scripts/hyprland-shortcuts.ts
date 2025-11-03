// Generates a Markdown table of Hyprland binds
async function run(cmd: string[]): Promise<string> {
  try {
    const command = new Deno.Command(cmd[0], { args: cmd.slice(1) });
    const { stdout } = await command.output();
    return new TextDecoder().decode(stdout).trim();
  } catch {
    return "";
  }
}

interface Bind {
  type: string;
  mods: string;
  key: string;
  action: string;
  arg: string;
}

function parseLine(line: string): Bind | null {
  const trimmed = line.trim();
  if (!trimmed || !/^bind/.test(trimmed)) return null;
  const [prefix, restRaw] = trimmed.split("=", 2);
  if (!restRaw) return null;

  // Split remainder into at most 4 segments (mods, key/button, dispatcher, arg)
  const parts: string[] = [];
  let current = "";
  let splits = 0;
  for (let i = 0; i < restRaw.length; i++) {
    const c = restRaw[i];
    if (c === "," && splits < 3) {
      parts.push(current);
      current = "";
      splits++;
    } else {
      current += c;
    }
  }
  parts.push(current);
  while (parts.length < 4) parts.push("");

  const [modsRaw, keyRaw, dispatcherRaw, argRaw] = parts.map((p) => p.trim());

  const typeMap: Record<string, string> = {
    bind: "Key",
    binde: "Repeat",
    bindr: "Release",
    bindl: "Locked",
    bindm: "Mouse",
  };
  const type = typeMap[prefix] ?? prefix;

  const mods = modsRaw
    .split(/[|+]/)
    .map((m) => m.trim())
    .filter(Boolean)
    .join("+");

  return {
    type,
    mods,
    key: keyRaw,
    action: dispatcherRaw,
    arg: argRaw,
  };
}

function toMarkdown(binds: Bind[]): string {
  const header = "| Type | Modifiers | Key/Button | Action | Argument |\n|------|-----------|------------|--------|----------|";
  const rows = binds
    .sort((a, b) =>
      a.type === b.type
        ? (a.mods + a.key).localeCompare(b.mods + b.key)
        : a.type.localeCompare(b.type)
    )
    .map((b) => `| ${b.type} | ${b.mods || "-"} | ${b.key || "-"} | ${b.action || "-"} | ${b.arg || "-"} |`);
  return [header, ...rows].join("\n");
}

async function main(): Promise<void> {
  const output = await run(["hyprctl", "binds"]);
  if (!output) {
    console.error("Failed to get binds (is Hyprland running?).");
    return;
  }
  const binds: Bind[] = [];
  for (const line of output.split("\n")) {
    const b = parseLine(line);
    if (b) binds.push(b);
  }
  console.log(toMarkdown(binds));
}

if (import.meta.main) {
  main();
}
