{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "zeitfetch";
  version = "0.1.16";
  cargoHash = "sha256-GM3hY3KY/G1B/ashmjusbnT1tqcP6CdyHyGnaXTskcw=";

  nativeBuildInputs = [pkg-config];

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "nidnogg";
    hash = "sha256-fmA6FPHYfSFvKCv+HjGISV8w/vVI8yCl4ZfwCUI3RS4=";
  };
}
