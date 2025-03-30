{
  appimageTools,
  fetchFromGitHub,
  ...
}:
appimageTools.wrapType2 rec {
  name = "dev-manager-desktop";
  src = fetchFromGitHub {
    repo = name;
    owner = "webosbrew";
    rev = "3a79bd0b2da8934b7546d5ba35a2ed2c55ea7ca7";
    hash = "sha256-Kaz/Tx0qDT1ir88BsWv6JqstlF4ck9G+6k0cpV5m5QE=";
  };
}
