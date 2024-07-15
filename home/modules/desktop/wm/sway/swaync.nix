{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf config.settings.wm.sway.enable {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      notification-2fa-action = true;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 800;
      control-center-margin-top = 16;
      control-center-margin-right = 16;
      widgets = [
        "mpris"
        "title"
        "dnd"
        "notifications"
      ];
    };

    style = pkgs.stdenv.mkDerivation {
      name = "style.css";
      nativeBuildInputs = [ pkgs.sass ];
      src = pkgs.writeTextFile {
        name = "style.scss";
        text = import ./swaync-style.nix config;
      };
      unpackPhase = "true";
      buildPhase = ''
        sass $src $out
      '';
    };

  };

  # Required for waybar to recognise the program properly
  # FIXME: maybe just start waybar from sway instead of through systemd (disable systemd.enable in waybar)
  systemd.user.services.waybar.Service.Environment = "PATH=${
    lib.makeBinPath [ config.services.swaync.package ]
  }";
}
