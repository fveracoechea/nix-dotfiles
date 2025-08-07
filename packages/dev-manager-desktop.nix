{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  cargo-tauri,
  gtk3,
  gtk4,
  nodejs,
  perl,
  glib-networking,
  npmHooks,
  wrapGAppsHook4,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "dev-manager-desktop";
  version = "1.99.16";
  cargoHash = "sha256-a6H7MEHNkOOfw1VdvYQ/ZN8myVcBIk8fdm6LUHUYOAg=";

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "webosbrew";
    hash = "sha256-mWqPEAQW59HRDoV3JEosAxe3IrFgSihWB0Joz1rpdh8=";
  };

  doCheck = false;

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-YYm8nZ5eKoy1kx28oA2buocQB3bZ6IGWV48pYDJZR4g=";
  };

  nativeBuildInputs = [
    perl
    # Pull in our main hook
    cargo-tauri.hook
    # Setup npm
    nodejs
    npmHooks.npmConfigHook
    # Make sure we can find our libraries
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_1
      gtk4
      gtk3
    ];
}
