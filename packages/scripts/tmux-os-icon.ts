const icons: Record<string, string> = {
  linux: "",
  darwin: "",
  windows: "",
  freebsd: "",
  netbsd: "",
  openbsd: "",
  android: "",
  aix: "💻",
  solaris: "☀",
  illumos: "✨",
  default: "",
};

const platform = Deno.build.os;
console.log(icons[platform] ?? icons.default);
