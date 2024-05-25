{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = lib.mkIf config.hm.settings.browser.firefox.enable {
    programs.firefox = {
      enable = true;
      # TODO: install extensions and configure stuff here
      # nativeMessagingHosts.tridactyl = true;
    };
  };
}
