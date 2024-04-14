{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home = {
    username = "olai";
    homeDirectory = "/home/olai";
    stateVersion = "23.11"; # Changed from stable 23.05
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./programs/shell

    ./programs/browser.nix
    ./programs/discord.nix
    ./programs/emacs
    ./programs/zathura.nix
    ./programs/files.nix
    ./programs/other.nix

    # ./programs/wallpaper/wallpaper.nix
    ./programs/wm/wayland
    ./programs/wm/ags
  ];

  # Random other packages (hmm, it seems that all unfree packages are allowed because useGlobalPkgs... TODO)
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "geogebra6"
      "_1password-gui-beta"
    ];

  home.packages = with pkgs; [
    gcc
    cmake

    fd

    nodejs_20
    python311
    dconf

    pavucontrol
    #geogebra6
    nurl
    sops

    _1password-gui-beta
    handbrake

    (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (ps:
      with ps; [
        plover-uinput
      ]))
  ];

  home.sessionVariables."PLOVER_UINPUT_LAYOUT" = "no";
}
