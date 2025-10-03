{
  user,
  pkgs,
  outputs,
  config,
  lib,
  ...
}:
{
  settings = {
    aerospace.enable = true;
    brew.enable = true;
    home-manager.enable = true;
    jankyborders.enable = true;
    misc.enable = true;
    nix.enable = true;
    system.enable = true;
  };

  home-manager.users.${user} = import ./home.nix;

  environment.systemPackages = [
    config.hm.settings.plover.package
  ];
  hm.programs.plover.package = lib.mkForce pkgs.emptyDirectory;
  # launchd.user.agents.plover = {
  #   command = "${config.hm.settings.plover.package}/Applications/Plover.app/Contents/MacOS/Plover";
  #   serviceConfig = {
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #   };
  #   managedBy = "settings.plover.enable";
  # };

  # NOTE: might want to do this in hm instead.
  system.activationScripts.extraActivation.text =
    let
      wallpaper = outputs.packages.${pkgs.system}.wallpaper.override {
        inherit (config.hm) colorScheme;
        logo = "apple";
      };
    in
    ''
      /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"${wallpaper}\""
    '';

}
