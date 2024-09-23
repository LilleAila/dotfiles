{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.settings.plover;
  iniFormat = pkgs.formats.ini { };
in
{
  options.settings.plover = {
    enable = lib.mkEnableOption "plover, an open source stenotype engine";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.plover.dev;
      example =
        lib.literalExpression # nix
          ''
            inputs.plover-flake.${pkgs.system}.plover.with-plugins (ps: with ps; [
              plover-lapwing-aio
              plover-uinput
            ])
          '';
    };
    settings = lib.mkOption {
      inherit (iniFormat) type;
      default = { };
      example =
        lib.literalExpression # nix
          ''
            {
              "Machine Configuration" = {
                machine_type = "Keyboard";
                auto_start = false;
              };
              "Output Configuration" = {
                undo_levels = 100;
                xkb_layout = "no";
              };
              "Translation Frame" = {
                opacity = 100;
              };
              "Gemini PR" = {
                baudrate = 9600;
                bytesize = 8;
                parity = "N";
                port = "/dev/serial/by-id/usb-beekeeb_piantor_pro-if02";
                stopbits = 1;
                timeout = 2.0;
              };
              "Plugins" = {
                enabled_extensions = ["modal_update" "plover_auto_reconnect_machine" "plover_uinput"];
              };
              "System" = {
                name = "English Stenotype";
              };
              "Startup" = {
                "start minimized" = false;
              };
              "Logging Configuration" = {
                log_file = "strokes.log";
              };
            }
          '';
      description = ''
        Plover settings written to
        {file}`$XDG_CONFIG_HOME/plover/plover.cfg`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."plover/plover.cfg".source = iniFormat.generate cfg.settings;
    # TODO: plover.qss https://plover.wiki/index.php/Theming_Plover_with_QSS
  };
}
