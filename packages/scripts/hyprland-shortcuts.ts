// Generates a Markdown table of Hyprland binds with robust parsing
// Usage: deno run --allow-run packages/scripts/hyprland-shortcuts.ts > HYPRLAND_SHORTCUTS.md

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
  description?: string;
}

function normalizeMods(modsRaw: string): string {
  return modsRaw
    .split(/[|+\s]/)
    .map((m) => m.trim())
    .filter(Boolean)
    .join("+");
}

function parseEqualsStyle(prefix: string, restRaw: string): Bind | null {
  // Determine number of segments; bindd may contain description
  const parts: string[] = [];
  let current = "";
  let splits = 0;
  // Allow up to 5 splits for bindd (mods,key,description,dispatcher,arg)
  const maxSplits = prefix === "bindd" ? 4 : 3;
  for (let i = 0; i < restRaw.length; i++) {
    const c = restRaw[i];
    if (c === "," && splits < maxSplits) {
      parts.push(current);
      current = "";
      splits++;
    } else {
      current += c;
    }
  }
  parts.push(current);
  while (parts.length < (prefix === "bindd" ? 5 : 4)) parts.push("");

  const typeMap: Record<string, string> = {
    bind: "Key",
    binde: "Repeat",
    bindr: "Release",
    bindl: "Locked",
    bindm: "Mouse",
    bindd: "Key", // descriptive bind variant
  };

  const type = typeMap[prefix] ?? prefix;

  if (prefix === "bindd") {
    const [modsRaw, keyRaw, descRaw, dispatcherRaw, argRaw] = parts.map((p) => p.trim());
    return {
      type,
      mods: normalizeMods(modsRaw),
      key: keyRaw,
      action: dispatcherRaw,
      arg: argRaw,
      description: descRaw,
    };
  } else {
    const [modsRaw, keyRaw, dispatcherRaw, argRaw] = parts.map((p) => p.trim());
    return {
      type,
      mods: normalizeMods(modsRaw),
      key: keyRaw,
      action: dispatcherRaw,
      arg: argRaw,
    };
  }
}

function parseBracketStyle(line: string): Bind | null {
  // Example: bind[SUPER][K] -> movefocus u
  const r = /^(bind[a-z]?)[\[]([^\]]+)]\[([^\]]+)]\s*->\s*(\S+)(?:\s+(.*))?$/;
  const m = line.match(r);
  if (!m) return null;
  const [, prefix, modsRaw, keyRaw, action, rest] = m;
  const typeMap: Record<string, string> = {
    bind: "Key",
    binde: "Repeat",
    bindr: "Release",
    bindl: "Locked",
    bindm: "Mouse",
    bindd: "Key",
  };
  return {
    type: typeMap[prefix] ?? prefix,
    mods: normalizeMods(modsRaw),
    key: keyRaw.trim(),
    action: action.trim(),
    arg: (rest || "").trim(),
  };
}

function parseJSON(output: string): Bind[] | null {
  try {
    const data = JSON.parse(output) as unknown;
    const arr = Array.isArray(data)
      ? data
      : Array.isArray((data as { data?: unknown }).data)
      ? (data as { data: unknown[] }).data
      : [];
    const binds: Bind[] = [];
    for (const item of arr) {
      if (typeof item !== "object" || item === null) continue;
      const obj = item as Record<string, unknown>;
      const rawVal = obj.bind || obj.name || obj.value;
      if (typeof rawVal !== "string" || !rawVal) continue;
      const raw = rawVal;
      const prefixMatch = raw.match(/^(bind[a-z]?)=/);
      if (prefixMatch) {
        const [prefix, rest] = raw.split("=", 2);
        const b = parseEqualsStyle(prefix, rest);
        if (b) binds.push(b);
        continue;
      }
      const b2 = parseBracketStyle(raw);
      if (b2) binds.push(b2);
    }
    return binds.length ? binds : null;
  } catch {
    return null;
  }
}

function parseLine(line: string): Bind | null {
  const trimmed = line.trim();
  if (!trimmed) return null;

  if (trimmed.startsWith("[") || trimmed.startsWith("{")) return null;

  const eqIdx = trimmed.indexOf("=");
  if (eqIdx > 0 && trimmed.startsWith("bind")) {
    const prefix = trimmed.slice(0, eqIdx).trim();
    const rest = trimmed.slice(eqIdx + 1);
    return parseEqualsStyle(prefix, rest);
  }

  if (trimmed.startsWith("bind") && trimmed.includes(":")) {
    const [prefixPart, rest] = trimmed.split(":", 2);
    const prefix = prefixPart.replace(/\s+/g, "").trim();
    return parseEqualsStyle(prefix, rest.trim());
  }

  if (trimmed.startsWith("bind") && trimmed.includes("->")) {
    return parseBracketStyle(trimmed);
  }

  return null;
}

function toMarkdown(binds: Bind[]): string {
  const anyDescriptions = binds.some((b) => b.description && b.description.trim());
  const headerBase = anyDescriptions
    ? "| Type | Modifiers | Key/Button | Action | Argument | Description |\n|------|-----------|------------|--------|----------|------------|"
    : "| Type | Modifiers | Key/Button | Action | Argument |\n|------|-----------|------------|--------|----------|";

  const rows = binds
    .sort((a, b) =>
      a.type === b.type
        ? (a.mods + a.key).localeCompare(b.mods + b.key)
        : a.type.localeCompare(b.type)
    )
    .map((b) =>
      anyDescriptions
        ? `| ${b.type} | ${b.mods || "-"} | ${b.key || "-"} | ${b.action || "-"} | ${b.arg || "-"} | ${b.description || "-"} |`
        : `| ${b.type} | ${b.mods || "-"} | ${b.key || "-"} | ${b.action || "-"} | ${b.arg || "-"} |`
    );
  return [headerBase, ...rows].join("\n");
}

async function main(): Promise<void> {
  // Try JSON first
  let output = await run(["hyprctl", "-j", "binds"]);
  let binds: Bind[] | null = [];
  if (output) binds = parseJSON(output);

  // Fallback: plain text streaming format (block style we observed)
  if (!binds || binds.length === 0) {
    output = await run(["hyprctl", "binds"]);
    const lines = output.split("\n");
    const collected: Bind[] = [];
    let currentType = "";
    let current: Partial<Bind & { rawMods?: string; rawDescription?: string }> = {};

    function finalizeCurrent() {
      if (!current.key) return;
      const typeMap: Record<string, string> = {
        bind: "Key",
        binde: "Repeat",
        bindr: "Release",
        bindl: "Locked",
        bindm: "Mouse",
        bindd: "Key",
      };
      const type = (typeMap[currentType] ?? currentType) || "Key";
      collected.push({
        type,
        mods: normalizeMods(current.rawMods || ""),
        key: current.key || "",
        action: current.action || "",
        arg: current.arg || "",
        description: current.description || current.rawDescription || "",
      });
      current = {};
    }

    for (const line of lines) {
      const l = line.trim();
      if (!l) continue;
      if (l === "bind" || l === "bindm" || l === "bindd" || l === "binde" || l === "bindr" || l === "bindl") {
        finalizeCurrent();
        currentType = l;
        continue;
      }
      const kv = l.split(":", 2);
      if (kv.length === 2) {
        const key = kv[0].trim();
        const value = kv[1].trim();
        switch (key) {
          case "modmask":
            current.rawMods = value; // will map later
            break;
          case "key":
            current.key = value;
            break;
          case "dispatcher":
            current.action = value;
            break;
          case "arg":
            current.arg = value;
            break;
          case "description":
            current.description = value;
            break;
        }
      }
    }
    finalizeCurrent();
    binds = collected;
  }

  if (!binds || binds.length === 0) {
    console.error("No binds parsed. Please paste 'hyprctl binds' output to refine parser.");
    return;
  }

  console.log(toMarkdown(binds));
}

if (import.meta.main) {
  main();
}
