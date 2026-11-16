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
          rec {
            enable = true;
            port = 8080;

            settings = {
              healthCheckTimeout = 120;
              models = {
                "borealis2" = {
                  aliases = [
                    "borealis"
                    "norsk"
                  ];
                  ttl = 180;
                  # Command was ai generated, idk what all the params do
                  cmd = lib.concatStringsSep " " [
                    "${llama-server}"
                    "--port \${PORT}"
                    "-m /var/lib/llama-models/borealis2-26b-a4b-preview-Q3_K_M.gguf"
                    "--jinja" # Uses the embedded Gemma 4 chat template
                    "-ngl 99" # Offload all layers to the Arc B390 iGPU
                    "-fa on" # Enable Flash Attention
                    "-ctk q8_0" # Quantize K cache to 8-bit to stay under 16GB RAM
                    "-ctv q8_0" # Quantize V cache to 8-bit
                    "-c 32768" # 32K context window (drop to 16384 if RAM is tight)
                    "-t 4" # 4 P-cores for generation
                    "-tb 12" # 4 P-cores + 8 E-cores for prompt processing
                    "--no-mmap" # Pin weights directly in unified memory
                  ];
                };

                "borealis-4b" = {
                  aliases = [
                    "borealis-fast"
                    "norsk-fast"
                  ];
                  ttl = 300;
                  cmd = lib.concatStringsSep " " [
                    "${llama-server}"
                    "--port \${PORT}"
                    "-m /var/lib/llama-models/borealis-4b-Q6_K.gguf"
                    "--jinja" # Uses the embedded Gemma 3 chat template
                    "-ngl 99" # Offload all layers to the Arc B390 iGPU
                    "-fa on" # Enable Flash Attention
                    "-ctk q8_0" # Keep KV cache compact
                    "-ctv q8_0"
                    # "-c 32768" # context
                    "-c 131072" # max supported context for this model
                    "-t 4" # 4 P-cores for token generation
                    "-tb 6" # Fewer prompt threads so all 12 cores don't spike heat/fans
                    "--no-mmap"
                  ];
                };
              };
            };
          };

        environment.systemPackages = with pkgs; [
          llama-cpp-vulkan
          aichat
        ];

        systemd.services.llama-swap = {
          environment = {
            # XDG_CACHE_HOME = "/var/cache/llama-swap-mesa";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-swap-mesa";
            VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
            VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
            LD_LIBRARY_PATH = "/run/opengl-driver/lib";
          };
          serviceConfig = {
            privateDevices = lib.mkForce false;
            SupplementaryGroups = [
              "video"
              "render"
            ];
            DeviceAllow = [
              "/dev/dri rw"
              "char-drm rw"
            ];
          };
        };

        settings.persist = {
          home.cache = [
            ".cache/llama.cpp"
            ".cache/huggingface"
            ".config/aichat"
          ];
          root.directories = [
            "/var/lib/llama-cpp"
            "/var/lib/llama-models"
            "/var/lib/llama-swap"
            "/var/cache/llama-swap-mesa"
          ];
        };
      };
    };
}
