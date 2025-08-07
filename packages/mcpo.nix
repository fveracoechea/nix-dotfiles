{
  python3,
  python3Packages,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mcpo";
  version = "0.0.17";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "mcpo";
    rev = "v${version}";
    hash = "sha256-oubMRHiG6JbfMI5MYmRt4yNDI8Moi4h7iBZPgkdPGd4=";
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
