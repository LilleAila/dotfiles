{ config, pkgs, lib, inputs, ... }:

let
	startupScript = pkgs.pkgs.writeShellScriptBin "start" /* bash */ ''
		${inputs.hyprland.packages."${pkgs.system}".hyprland}/bin/hyprctl setcursor "Bibata-Modern-Ice" 24 &
		# ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
		ags &
		${pkgs.mako}/bin/mako &
	'';
in

{
	home.packages = with pkgs; [
		seatd # TODO: this probably doesn't even do anything, idk why here, should be enabled in configuration.nix
		rofi-wayland
		dolphin
		# qutebrowser
		libnotify
		grim
		slurp
		wl-clipboard
		swappy
		avizo
		pamixer
		playerctl
		brightnessctl
		grimblast
		qalculate-gtk
	];

	# TODO: cursor does not work properly on m1pro14
	# TODO: fix monitor refresh rate (120hz instead of 60hz) (on m1pro14)
	# TODO: legacyRenderer override only for m1pro14
	# TODO: enable display under notch to show bar
	# TODO: set up blueberry (bluetooth) and nm-applet / networkmanager (wifi)
	wayland.windowManager.hyprland = {
		enable = true;
		package = (inputs.hyprland.packages."${pkgs.system}".hyprland.override { legacyRenderer = true; });
		systemd.enable = true;
		xwayland.enable = true;

		settings = {
			monitor = [
				", preferred, auto, 1"
				"eDP-1, 3024x1890@60, 0x0, 2" # Scaled to 1512x945
				# X-offset of 2nd monitor = (2560 - 1512) / 2 = 524
				# Y-offset of 2nd monitor = height (1440)
				"HDMI-A-1, 2560x1440@144, -524x-1440, 1" # Negative because top-left corner offset
			];
			exec-once = ''${startupScript}/bin/start'';
			env = [
				"XCURSOR_SIZE,24"
				"GRIMBLAST_EDITOR,\"swappy -f\""
			];

			"$terminal" = "kitty";
			"$fileManager" = "dolphin";
			"$webBrowser" = "firefox"; # TODO: maybe switch to qutebrowser?
			"$discord" = "vesktop";
			"$launcher" = "rofi -show drun -show-icons";
			"$calculator" = "qalculate-gtk";

			"$mainMod" = "SUPER";
			"$screenshot_args" = "--notify --freeze"; # TODO: fix cursor in screenshots (switch to grim+slurp directly??)
			"$screenshot_path" = "~/Screenshots/Raw/$(date +\"%Y-%m-%d,%H:%M:%S.png\")";

			bind = [
				# Screenshots
				"$mainMod SHIFT, E, exec, wl-paste | swappy -f -"
				"$mainMod, S, exec, grimblast $screenshot_args copysave area $screenshot_path"
				"$mainMod SHIFT, S, exec, grimblast $screenshot_args copysave active $screenshot_path"
				", PRINT, exec, grimblast $screenshot_args copysave output $screenshot_path"
				"SHIFT, PRINT, exec, grimblast $screenshot_args copysave screen $screenshot_path"
				# Same as two above but without PrtSc
				"$mainMod ALT, S, exec, grimblast $screenshot_args copysave output $screenshot_path"
				"$mainMod ALT SHIFT, S, exec, grimblast $screenshot_args copysave screen $screenshot_path"

				# Apps
				"$mainMod, return, exec, $terminal"
				# ", XF86Launch1, exec, $terminal"
				"$mainMod, space, exec, $launcher"
				"$mainMod, E, exec, emacsclient -c"
				# "$mainMod, D, exec, $fileManager"
				"$mainMod, B, exec, $webBrowser"
				# "$mainMod, D, exec, $discord"

				# Special workspaces
				"$mainMod, Q, exec, bash -c 'pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &'"
				# Using pgrep -f to match against window name or smth idk it works
				# "$mainMod, D, exec, bash -c 'pgrep -f vesktop && hyprctl dispatch togglespecialworkspace discord || vesktop &'"
				# Same thing but a script
				"$mainMod, D, exec, ${pkgs.writeShellScriptBin "toggle_discord" /*bash*/ ''
				#!/usr/bin/env bash

				if [[ $(pgrep -f vesktop | wc -l) -ne 0 ]]; then
					hyprctl dispatch togglespecialworkspace discord
				else
					vesktop &
				fi
				''}/bin/toggle_discord"
				"$mainMod, C, togglespecialworkspace, config"

				# WM commands
				", XF86PowerOff, exec, pgrep -x wlogout && pkill -x wlogout || wlogout"
				", XF86Launch1, exec, pgrep -x wlogout && pkill -x wlogout || wlogout"
				", XF86WLAN, exec, rfkill toggle all"
				", XF86Back, workspace, -1"
				", XF86Forward, workspace, +1"

				"$mainMod, W, killactive,"
				"$mainMod, O, fullscreen, 0"
				"$mainMod SHIFT, O, fullscreen, 1"
				"$mainMod ALT, O, fakefullscreen"
				"$mainMod, F, togglefloating,"
				"$mainMod, P, pseudo,"
				"$mainMod, T, togglesplit,"
				# "$mainMod, M, exit," # use wlogout instead

				# Move focus
				"$mainMod, h, movefocus, l"
				"$mainMod, j, movefocus, d"
				"$mainMod, k, movefocus, u"
				"$mainMod, l, movefocus, r"

				# Move windows
				"$mainMod SHIFT, h, movewindow, l"
				"$mainMod SHIFT, j, movewindow, d"
				"$mainMod SHIFT, k, movewindow, u"
				"$mainMod SHIFT, l, movewindow, r"

				"$mainMod CONTROL, 1, movewindow, mon:0"
				"$mainMod CONTROL, 2, movewindow, mon:1"
				"$mainMod CONTROL, 3, movewindow, mon:2"
				"$mainMod CONTROL, 4, movewindow, mon:3"

				"$mainMod ALT SHIFT, h, moveactive, -10 0"
				"$mainMod ALT SHIFT, j, moveactive, 0 -10"
				"$mainMod ALT SHIFT, k, moveactive, 0 10"
				"$mainMod ALT SHIFT, l, moveactive, 10 0"

				# Swap windows
				"$mainMod CONTROL, h, swapwindow, l"
				"$mainMod CONTROL, j, swapwindow, d"
				"$mainMod CONTROL, k, swapwindow, u"
				"$mainMod CONTROL, l, swapwindow, r"

				"$mainMod, n, swapnext"
				"$mainMod SHIFT, n, swapnext, prev"

				# Resize windows
				"$mainMod ALT, h, resizeactive, -10 0"
				"$mainMod ALT, j, resizeactive, 0 -10"
				"$mainMod ALT, k, resizeactive, 0 10"
				"$mainMod ALT, l, resizeactive, 10 0"

				# Switch workspace with $mainMod + [0-9]
				"$mainMod, 1, workspace, 1"
				"$mainMod, 2, workspace, 2"
				"$mainMod, 3, workspace, 3"
				"$mainMod, 4, workspace, 4"
				"$mainMod, 5, workspace, 5"
				"$mainMod, 6, workspace, 6"
				"$mainMod, 7, workspace, 7"
				"$mainMod, 8, workspace, 8"
				"$mainMod, 9, workspace, 9"

				# Move window to workspace with $mainMod + SHIFT + [0-9]
				"$mainMod SHIFT, 1, movetoworkspace, 1"
				"$mainMod SHIFT, 2, movetoworkspace, 2"
				"$mainMod SHIFT, 3, movetoworkspace, 3"
				"$mainMod SHIFT, 4, movetoworkspace, 4"
				"$mainMod SHIFT, 5, movetoworkspace, 5"
				"$mainMod SHIFT, 6, movetoworkspace, 6"
				"$mainMod SHIFT, 7, movetoworkspace, 7"
				"$mainMod SHIFT, 8, movetoworkspace, 8"
				"$mainMod SHIFT, 9, movetoworkspace, 9"

				# Move workspaces between monitors
				"$mainMod ALT, 1, movecurrentworkspacetomonitor, 0"
				"$mainMod ALT, 2, movecurrentworkspacetomonitor, 1"
				"$mainMod ALT, 3, movecurrentworkspacetomonitor, 2"
				"$mainMod ALT, 4, movecurrentworkspacetomonitor, 3"

				# Scroll through workspaces with $mainMod + scroll
				"$mainMod, mouse_down, workspace, e+1"
				"$mainMod, mouse_up  , workspace, e-1"
			];

			# Move/resize windows with $mainMod + LMB/RMB and dragging
			bindm = [
				"$mainMod, mouse:272, movewindow"
				"$mainMod, mouse:273, resizewindow"
				"$mainMod ALT, mouse:272, resizewindow"
			];

		# l -> do stuff even when locked
		# e -> repeats when key is held 
			bindl = [
				", XF86AudioMute, exec, volumectl toggle-mute"
				", XF86AudioMicMute, exec, volumectl -m toggle-mute"
				"SHIFT, XF86AudioMute, exec, volumectl -m toggle-mute"
				", XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles "
				", XF86AudioNext, exec, playerctl next "
				", XF86AudioPrev, exec, playerctl previous"
			];

			bindle = [
				", XF86AudioRaiseVolume, exec, volumectl -u up 10"
				", XF86AudioLowerVolume, exec, volumectl -u down 10"
				"SHIFT, XF86AudioRaiseVolume, exec, volumectl -mu up 10"
				"SHIFT, XF86AudioLowerVolume, exec, volumectl -mu down 10"

				", XF86MonBrightnessUp, exec, lightctl up 10"
				", XF86MonBrightnessDown, exec, lightctl down 10"
				", XF86Search, exec, $launcher"
			];

			input = {
				kb_layout = "no";
				follow_mouse = 1;
				touchpad = {
					natural_scroll = true;
					disable_while_typing = true;
					tap-to-click = false;
					clickfinger_behavior = true; # one, two and three finger click
				};
				sensitivity = 0.0;
				accel_profile = "flat";
				kb_options = [
					"ctrl:nocaps"
				];
			};

			# "device:synps/2-synaptics-touchpad"

			gestures = {
				workspace_swipe = false;
			};

			general = {
				gaps_in = 20;
				gaps_out = 20;
				border_size = 2;
				"col.active_border" = "rgba(${config.colorScheme.palette.base04}ee) rgba(${config.colorScheme.palette.base05}ee) 45deg";
				"col.inactive_border" = "rgba(${config.colorScheme.palette.base00}aa)";
				layout = "dwindle";
				allow_tearing = "false";
			};

			decoration = {
				rounding = 10;
				# blur = {
				# 	enabled = true;
				# 	brightness = 1.0;
				# 	contrast = 1.0;
				# 	noise = 0.02;
				# 	passes = 3;
				# 	size = 10;
				# 	# size = 3;
				# 	# passes = 1;
				# 	# vibrancy = 0.1696;
				# };
				blur = {
					enabled = false;
				};
				# drop_shadow = true;
				# shadow_range = 4;
				# shadow_render_power = 3;
				# "col.shadow" = "rgba(1a1a1aee)";
				drop_shadow = false;
			};

			animations = {
				enabled = "true";
				# Good place to find beziers: https://easings.net/
				bezier = [
					"easeOutQuart, 0.25, 1, 0.5, 1"
					"easeOutQuad, 0.5, 1, 0.89, 1"
					"easeInOutBack, 0.68, -0.6, 0.32, 1.6"
				];

				animation = [
					"windows, 1, 4, easeOutQuart"
					"windowsOut, 1, 4, easeOutQuart, popin 80%"
					"border, 1, 10, default"
					"borderangle, 1, 8, default"
					"fade, 1, 4, default"
					"workspaces, 1, 2, easeOutQuad"
					"specialWorkspace, 1, 4, easeInOutBack, slidevert"
				];
			};

			dwindle = {
				pseudotile = "true";
				preserve_split = "true";
			};

			master = {
				new_is_master = "true";
			};

			misc = {
				force_default_wallpaper = 0;
				# disable_hyprland_logo = true
				vfr = true;
			};

			windowrulev2 = [
				# "nomaximizerequest, class:.*"

				# Put apps in special workspace
				"float,class:(qalculate-gtk)"
				"workspace special:calculator,class:(qalculate-gtk)"

				"float,class:(vesktop)"
				"workspace special:discord,class:(vesktop)"

				"float,class:(nm-*)"
				"float,class:(.blueman-*)"
				"float,class:(pavucontrol)"
				"workspace special:config,class:(nm-*)"
				"workspace special:config,class:(.blueman-*)"
				"workspace special:config,class:(pavucontrol)"
			];

			# layerrule = [
			# 	"blur, bar"
			# ];
		};
	};
}
