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
  buildNpmPackage rec {
    pname = "cbmp";
    version = "1.1.1";
    src = source;
    npmDepsHash = "sha256-L3DWmEEkgyE3R0Wxbd0cX/QhG3LhzlfYEw+4CIpCjhk=";

    postPatch = ''
      cat > package-lock.json << EOF
        ${builtins.readFile ./package-lock.json}
      EOF
      export PUPPETEER_SKIP_DOWNLOAD=1
    '';
  }
# mkYarnPackage rec {
#   pname = "cbmp";
#   version = "1.1.1";
#
#   src = source;
#
#   offlineCache = fetchYarnDeps {
#     yarnLock = src + "/yarn.lock";
#     hash = "sha256-9iGfwMyy+cmIp7A5qOderuyL/0wrJ/zCTFPyLL/w3qE=";
#   };
#
#   buildPhase = ''
#     yarn --ofline prebuild
#     yarn --ofline build
#   '';
#
#   meta = with lib; {
#     license = licenses.mit;
#   };
# }

