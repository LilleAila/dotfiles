# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the necessary packages and configuration for Apple Silicon support.
      # ./apple-silicon-support
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

	services.logind.extraConfig = /*conf*/ ''
	HandlePowerKey=ignore
	'';

  swapDevices = [
	  {
			device = "/var/lib/swapfile";
			size = 16 * 1024;
		}
	];

	services.fstrim.enable = true;

	services.upower.enable = true;
	# Use TLP for battery charging thresholds
	# https://github.com/PaddiM8/asahi-battery-threshold/issues/3
	# https://www.reddit.com/r/AsahiLinux/comments/y26qx5/comment/is1l7hm/
	# services.tlp = {
	# 	enable = true;
	# 	settings = {
	# 		START_CHARGE_THRESH_macsmc-battery = 70;
	# 		STOP_CHARGE_THRESH_macsmc-battery = 80;
	# 		# Recalibrate with `tlp fullcharge/recalibrate`.
	# 		# This restores charge threshold before reboot:
	# 		RESTORE_THRESHOLDS_ON_BAT = 1;
	# 	};
	# };

	services.seatd.enable = true;

	# Idk if this actually works, but it seems to set it to 80/75 for some reason????
# TODO: add script to enable / disable fullcharge:
# echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
# echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
	services.udev.extraRules = ''
KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="60"
	'';

	# Configure asahi
	hardware.asahi = {
		peripheralFirmwareDirectory = ./firmware;
		useExperimentalGPUDriver = true;
		experimentalGPUInstallMode = "replace";
		withRust = true;
	};
	# TODO: switch to using overlays instead of replacing, so that I can rebuild without `--impure`
	# Overlay has to be made manually, because of infinite loop error from asahi
	# Something like: ( causes full rebuild :( )
	# nixpkgs.overlays = [
	# 	(final: prev: { mesa = final.mesa-asahi-edge; })
	# ];

	programs.hyprland.enable = true; # Wai dis enabel??

	# Enable OpenGL
	hardware.opengl = {
		# package = pkgs.mesa-asahi-edge;
		enable = true;
		driSupport = true;
		# driSupport32Bit = true;
	};

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
			};
		};
		vt = 2;
	};

  # Configure X11 (for xwayland)
  services.xserver = {
    enable = true;

    xkb.layout = "no";
    xkb.variant = "";
    displayManager.lightdm.enable = false;

    updateDbusEnvironment = true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };
    enableCtrlAltBackspace = true;
  };
  programs.xwayland.enable = true;


  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  networking.hostName = "nixos-mac"; # Define your hostname.
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };


	hardware.bluetooth.enable = true;
	services.blueman.enable = true;
	sound.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # This allows swaylock to login with password
  security.pam.services.swaylock = {};

  # Enable XDG-desktop-portals
  xdg.portal = {
   enable = true;
   wlr.enable = true;
   configPackages = [ pkgs.xdg-desktop-portal-gtk ];
   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable dconf and xconf
  programs.dconf.enable = true;
	programs.xfconf.enable = true;
	services.gvfs.enable = true;
  
  fonts.packages = with pkgs; [ terminus_font ];
  # Set console font and keyboard
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-u32n";
    keyMap = "no";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Add a user account
  users.users.olai = {
    isNormalUser = true;
    description = "Olai";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    home-manager
    git
		pciutils
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

