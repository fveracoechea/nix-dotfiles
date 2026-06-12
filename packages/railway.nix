{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sH6jlS1Ep95+863t9B1i/0lrgY8hLhH9/EAIGem0pVk=";
  };

  cargoHash = "sha256-QSGmq6lFPcSKm41eooXgAKZEHwJGk6DtQLOAbYjMcX8=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [openssl];

  env.OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    wrapProgram $out/bin/railway \
      --set RAILWAY_NO_AUTO_UPDATE true
  '';

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
})
