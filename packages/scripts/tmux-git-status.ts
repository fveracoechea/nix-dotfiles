async function isGitRepo() {
  try {
    const stats = await Deno.stat(".git");
    return stats.isDirectory;
  } catch {
    return false;
  }
}

async function run(cmd: string[]) {
  try {
    const command = new Deno.Command(cmd[0], { args: cmd.slice(1) });
    const { stdout } = await command.output();
    return new TextDecoder().decode(stdout).trim();
  } catch {
    return "";
  }
}

async function main() {
  try {
    if (!(await isGitRepo())) {
      console.log("N/A");
      return;
    }
    const [branch, upstream, status] = await Promise.all([
      run(["git", "rev-parse", "--abbrev-ref", "HEAD"]),
      run(["git", "rev-list", "--left-right", "--count", "@{upstream}...HEAD"]),
      run(["git", "status", "--porcelain"]),
    ]);

    const currentBranch = branch.trim();
    const [behind, ahead] = upstream.split("\t").map(Number);

    const lines = status.split("\n").filter((l) => l.trim());
    const deleted = lines.filter((l) => l.startsWith(" D")).length;
    const modified = lines.filter((l) => l.startsWith(" M")).length;
    const added = lines.filter((l) =>
      l.startsWith("A ") || l.startsWith("?? ")
    ).length;

    let out = currentBranch;
    if (ahead) out += ` ↑${ahead}`;
    if (behind) out += ` ↓${behind}`;
    if (added) out += ` ?${added}`;
    if (modified) out += ` ~${modified}`;
    if (deleted) out += ` -${deleted}`;

    console.log(out);
  } catch (error) {
    console.error(error);
  }
}

main();
