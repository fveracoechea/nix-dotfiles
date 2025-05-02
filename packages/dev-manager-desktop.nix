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
  version = "1.99.13";
  useFetchCargoVendor = true;
  cargoHash = "sha256-zd2+sGU+ytS4VRu80FfK7BpjjeM5qSm95Udou2WuUfE=";

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "webosbrew";
    hash = "sha256-0omtip+jhJvINFy1B5YtrLhcuEXVpUQmL5Hv48G3qtA=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-3dngwzQY8pabMCCqAQodNjQnPOb0FnoOd+W5GAbbd2Y=";
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
