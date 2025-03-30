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
  version = "1.99.10";
  useFetchCargoVendor = true;
  cargoHash = "sha256-AhQ3bQ4wCP3qFy1Yk8hqSrBCU4QXEWED7BPAzDZpsGA=";

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "webosbrew";
    hash = "sha256-IrwWfEJzQxfp8BKZuqOk7aY28Ozuuo4TCp/p0b1saS4=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-VnIyUr6gWQXV6/gRUWfui2EXUBI9Gk3CVJgJ9jfRI5M=";
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
      webkitgtk_4_1
    ];
}
