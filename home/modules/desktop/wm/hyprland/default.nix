{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./binds.nix
    ./settings.nix
    ./screenshots.nix
  ];

  options.settings.wm.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    useLegacyRenderer = lib.mkEnableOption "legacyRenderer";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.wm.hyprland.enable) {
      # Random dependencies and stuff
      home.packages = with pkgs; [
        libnotify
        avizo
        pamixer
        pavucontrol
        playerctl
        brightnessctl
        qalculate-gtk
        wlr-randr
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        # wayland.windowManager.hyprland.package = lib.mkDefault inputs.hyprland.packages."${pkgs.system}".hyprland;
        package = pkgs.hyprland;
        systemd.enable = true;
        xwayland.enable = true;
      };

      settings.wm.hyprland.screenshots.enable = lib.mkDefault true;
    })
    # There is probably a more clean way to do this
    # (lib.mkIf (config.settings.wm.hyprland.useLegacyRenderer) {
    #   wayland.windowManager.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland.override {legacyRenderer = true;};
    # })
  ];
}
