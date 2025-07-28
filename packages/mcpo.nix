{
  python3,
  python3Packages,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mcpo";
  version = "0.0.16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "mcpo";
    rev = "v${version}";
    hash = "sha256-T4eAhPgm1ysf/+ZmqZxAoc0SwQbkl8x8lBGwamMYcpU=";
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
  ];
}
