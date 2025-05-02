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
  version = "1.99.14";
  useFetchCargoVendor = true;
  cargoHash = "sha256-R3XoREDLaW4TZ7bzitF/GitxJv40evzTRa5FmnwJq4M=";

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "webosbrew";
    hash = "sha256-XLP3dw7mMpT3Rl7jHNnfIoU8+/V5WCh+cjXbh+Le6+s=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "sha256-WauHKKtZwdE1qUHkOZJE3/ofoze0ZeirLxESaoPe6BA=";
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
