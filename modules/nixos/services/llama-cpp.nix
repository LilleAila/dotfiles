{ lib, ... }: {
  flake.modules.nixos.llama-cpp =
    { pkgs, config, ... }:
    let
      cfg = config.settings.llama-cpp;
    in
    {
      options.settings.llama-cpp = {
        enable = lib.mkEnableOption "llama-cpp";
      };

      config = lib.mkIf cfg.enable {
        services.llama-swap =
          let
            llama-server = lib.getExe' pkgs.llama-cpp-vulkan "llama-server";
          in
          {
            enable = true;
            port = 8080;
          };

        environment.systemPackages = with pkgs; [ llama-cpp-vulkan ];

        systemd.services.llama-swap = {
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-swap";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-swap";
          };
          serviceConfig = {
            SupplementaryGroups = [
              "video"
              "render"
            ];
            DeviceAllow = [ "/dev/dri rw" ];
          };
        };

        settings.persist = {
          home.cache = [
            ".cache/llama.cpp"
            ".cache/huggingface"
          ];
          root.directories = [
            "/var/lib/llama-cpp"
            "/var/lib/llama-models"
            "/var/lib/llama-swap"
          ];
        };
      };
    };
}
