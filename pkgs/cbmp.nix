{
  pkgs,
  buildNpmPackage,
  mkYarnPackage,
  mkYarnModules,
  fetchYarnDeps,
  fetchFromGitHub,
  stdenv,
  lib,
  ...
}: let
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "cbmp";
    rev = "10b6e72397850fef5f9c5956ef02a3a34d3cdf2d";
    hash = "sha256-vOEz2KGJLCiiX+Or9y0JE9UF7sYbwaSCVm5iBv4jIdI=";
  };
in
  mkYarnPackage rec {
    pname = "cbmp";
    version = "1.1.1";

    src = source;

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-9iGfwMyy+cmIp7A5qOderuyL/0wrJ/zCTFPyLL/w3qE=";
    };

    postPatch = ''
      substituteInPlace tsconfig.json --replace '"target": "ES2015"' '"target": "es6"'
      substituteInPlace tsconfig.json --replace '"module": "node16"' '"module": "es6"'
    '';

    buildPhase = ''
      yarn --ofline prebuild
      yarn --ofline build
    '';

    meta = with lib; {
      license = licenses.mit;
    };
  }
