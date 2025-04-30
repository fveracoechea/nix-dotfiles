{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "zeitfetch";
  version = "0.1.14";
  useFetchCargoVendor = true;
  # cargoHash = lib.fakeHash;
  cargoHash = "sha256-lr9JXzCCUjXS+JFUp1gPzPTyslLGXFUhb5H3uAdH/o0=";

  nativeBuildInputs = [pkg-config];

  src = fetchFromGitHub {
    repo = pname;
    rev = "v${version}";
    owner = "nidnogg";
    hash = "sha256-VSwEPAJStiEtnCl/UOA1nxtiLupMnizQyidmen2Ytls=";
  };
}
