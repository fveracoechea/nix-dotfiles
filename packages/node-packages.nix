# This file has been generated by node2nix 1.11.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {};
in
{
  relay-compiler = nodeEnv.buildNodePackage {
    name = "relay-compiler";
    packageName = "relay-compiler";
    version = "18.2.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/relay-compiler/-/relay-compiler-18.2.0.tgz";
      sha512 = "P3o5/Gv/oLC9hckUaz/a+KvDgbFERpjtz5lgsJSIQILg9paaF3k1yaX9qSxErGuU4icZvjoK5G82a/bfPgGZpA==";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "A compiler tool for building GraphQL-driven applications.";
      homepage = "https://relay.dev";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
