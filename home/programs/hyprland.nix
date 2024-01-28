{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
	  seatd
		# wezterm
		# kitty
		wofi
		dolphin
		# firefox
		qutebrowser
	];

	wayland.windowManager.hyprland = {
		enable = true;
		enableNvidiaPatches = true;
		systemd.enable = true;
		xwayland.enable = true;
		extraConfig = ''
		monitor=eDP-1,preferred,auto,1

		$terminal = kitty
		$fileManager = dolphin
		$webBrowser = qutebrowser
		$menu = wofi --show drun
		env = XCURSOR_SIZE,24

		$mainMod = SUPER
		
		bind = $mainMod, return, exec, $terminal
		bind = $mainMod, W, killactive,
		bind = $mainMod, E, exec, $fileManager
		bind = $mainMod, B, exec, $webBrowser
		bind = $mainMod, F, togglefloating,
		bind = $mainMod, P, pseudo,
		bind = $mainMod, T, togglesplit,
		bind = $mainMod, M, exit,

		bind = $mainMod, h, movefocus, l
		bind = $mainMod, l, movefocus, r
		bind = $mainMod, k, movefocus, u
		bind = $mainMod, j, movefocus, d

		# Switch workspace with $mainMod + [0-9]
		bind = $mainMod, 1, workspace, 1
		bind = $mainMod, 2, workspace, 2
		bind = $mainMod, 3, workspace, 3
		bind = $mainMod, 4, workspace, 4
		bind = $mainMod, 5, workspace, 5
		bind = $mainMod, 6, workspace, 6
		bind = $mainMod, 7, workspace, 7
		bind = $mainMod, 8, workspace, 8
		bind = $mainMod, 9, workspace, 9

		# Move window to workspace with $mainMid + SHIFT + [0-9]
		bind = $mainMod SHIFT, 1, movetoworkspace, 1
		bind = $mainMod SHIFT, 2, movetoworkspace, 2
		bind = $mainMod SHIFT, 3, movetoworkspace, 3
		bind = $mainMod SHIFT, 4, movetoworkspace, 4
		bind = $mainMod SHIFT, 5, movetoworkspace, 5
		bind = $mainMod SHIFT, 6, movetoworkspace, 6
		bind = $mainMod SHIFT, 7, movetoworkspace, 7
		bind = $mainMod SHIFT, 8, movetoworkspace, 8
		bind = $mainMod SHIFT, 9, movetoworkspace, 9

		# Scroll through workspaces with $mainMod + scroll
		bind = $mainMod, mouse_down, workspace, e+1
		bind = $mainMod, mouse_up  , workspace, e-1

		# Move/resize windows with $mainMod + LMB/RMB and dragging
		bindm = $mainMod, mouse:272, movewindow
		bindm = $mainMod, mouse:273, resizewindow

    #### Other config

		input {
			kb_layout = no
				 follow_mouse = 1
			touchpad {
			  natural_scroll = true
			}
			sensitivity = 0.0
			accel_profile = flat
		}

		general {
			gaps_in = 20
			gaps_out = 20
			border_size = 2
			col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
			col.inactive_border = rgba(595959aa)

			layout = dwindle
			allow_tearing = false
		}

		decoration {
			rounding = 10

			blur {
				enabled = true
				size = 3
				passes = 1
				vibrancy = 0.1696
			}
			
			drop_shadow = true
			shadow_range ) 4
			shadow_render_power = 3
			col.shadow = rgba(1a1a1aee)
		}

		animations {
			enabled = true

			bezier = myBezier, 0.05, 0.9, 0.1, 1.05

			animation = windows, 1, 7, myBezier
			animation = windowsOut, 1, 7, myBezier, popin 80%
			animation = border, 1, 10, default
			animation = borderangle, 1, 8, default
			animation = fade, 1, 7, default
			animation = workspaces, 1, 6, default
		}

		dwindle {
			pseudotile = true
			preserve_split = true
		}

		master {
			new_is_master = true
		}

		gestures {
			workspace_swipe = falsee
		}

		misc {
			force_default_wallpaper = 0
			# disable_hyprland_logo = true
		}

		windowrulev2 = nomaximizerequest, class:.*
		'';
	};
}
