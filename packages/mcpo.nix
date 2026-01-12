{
  python3,
  python3Packages,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mcpo";
  version = "0.0.19";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "mcpo";
    rev = "v${version}";
    hash = "sha256-ZfTVMrXXEsEKHmeG4850Hq3MEpQA/3WMpAVZS0zvp1I=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    fastapi
    mcp
    passlib
    pydantic
    pyjwt
    typer
    uvicorn
    watchdog
  ];
}
