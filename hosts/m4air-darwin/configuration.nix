{
  user,
  pkgs,
  outputs,
  config,
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
