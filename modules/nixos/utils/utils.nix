{ lib, ... }:
{
  flake.modules.nixos.utils =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.utils.enable = lib.mkEnableOption "various general utilities";

      config = lib.mkIf config.settings.utils.enable {
        environment.shells = [
          pkgs.zsh
          pkgs.fish
        ];
        programs.zsh.enable = true;
        programs.fish.enable = true;

        services.fstrim.enable = true;
        services.upower.enable = true;

        programs.nh = {
          enable = true;
          flake = "/home/olai/dotfiles";
          # clean.enable = true;
          # clean.extraArgs = "--nogcroots --keep-since 4d --keep 4";
        };

        programs.nano.enable = false;

        programs.nix-ld.enable = true;
        services.envfs.enable = true;

        environment.systemPackages = with pkgs; [
          pciutils
          usbutils
          lshw
          wirelesstools
        ];
      };
    };
}
