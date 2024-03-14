{ config, pkgs, lib, inputs, ... }:

{
	# TODO: rewrite in ags
	programs.wlogout = {
		enable = true;
		package = pkgs.wlogout;
		layout = [
		{
			label = "lock";
			action = "sleep 1; swaylock";
			text = "Lock";
			keybind = "l";
		}
		{
			label = "hibernate";
			action = "systemctl hibernate";
			text = "Hibernate";
			keybind = "h";
		}
		{
			label = "logout";
			action = "loginctl terminate-user $USER";
			# action = "hyprctl dispatch exit"
			text = "Logout";
			keybind = "e";
		}
		{
			label = "shutdown";
			action = "systemctl poweroff";
			text = "Shutdown";
			keybind = "s";
		}
		{
			label = "suspend";
			action = "sleep 1; swaylock & systemctl suspend";
			text = "Suspend";
			keybind = "u";
		}
		{
			label = "reboot";
			action = "systemctl reboot";
			text = "Reboot";
			keybind = "r";
		}
		];
		style = /* css */ with config.colorScheme.palette; ''
* {
	background-image: none;
}
window {
	background-color: rgba(12, 12, 12, 0.9);
}
button {
	color: #${base07};
	background-color: #${base01};
	border-style: solid;
	border-width: 2px;
	background-repeat: no-repeat;
	background-position: center;
	background-size: 25%;
	border-radius: 0;
}

button:focus, button:active, button:hover {
	background-color: #${base03};
	outline-style: none;
}

#lock {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
	border-top-left-radius: 42px;
}

#logout {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
}

#suspend {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
	border-top-right-radius: 42px;
}

#hibernate {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
	border-bottom-left-radius: 42px;
}

#shutdown {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
}

#reboot {
	background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
	border-bottom-right-radius: 42px;
}
		'';
	};
}
