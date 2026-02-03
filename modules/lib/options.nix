{ lib, ... }:
{
  flake.lib = with lib; rec {
    mkOption' = type: default: mkOption { inherit type default; };

    mkStrOption = default: mkOption' types.str default;
    mkDisableOption = name: mkEnableOption name // { default = true; };
  };
}
