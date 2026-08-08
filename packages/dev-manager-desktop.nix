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
  version = "1.99.18";
  cargoHash = "sha256-FE2XXDuK89wYEDOzdYkUEybtz34qjQbTshjoN9ovy4s=";

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "webosbrew";
    hash = "sha256-5N/sW8GIu5HrDYNXt8Kb3vmgBubC1bN0qQRKHW5fPjM=";
  };

  doCheck = false;

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-HLpJpOiiwJVEzqW8mvvlWQczaS0V+phhAJo7HM+GxtA=";
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
