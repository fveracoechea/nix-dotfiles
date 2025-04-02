{
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.6";
  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "v${version}";
    hash = "sha256-qpwzuzEqXsGO4y3ClaY25Q4rFm2RyPl/X3yNcQz3R4E=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-UguHTRHdcogxg/8DmRWSE7XwmaF36MTGHzF5CpMBc3Y=";
  passthru.updateScript = nix-update-script {};
}
