{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellScriptBin "install.sh" ''
  #!/usr/bin/env bash
  set -e

  # Authorize the computer with git
  ${lib.getExe pkgs.cage} -s ${lib.getExe pkgs.firefox} https://github.com/settings/keys & sleep 2; cat ̃~/.ssh/id_ed25519.pub | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
''
