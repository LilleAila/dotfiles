import {
	Widget,
} from "../../imports";

const Settings = () => Widget.Box({
	vertical: true,
	class_name: "quicksettings",
	children: [
		Widget.Box({
			children: [
				// I found icon names using the icon browser example form ags github
				Widget.Button({
					child: Widget.Icon({ icon: "lock-symbolic" }),
					onClicked: () => print("Suspend"),
				}),
				Widget.Button({
					child: Widget.Icon({ icon: "application-exit-symbolic" }),
					onClicked: () => print("Log out"),
				}),
				Widget.Button({
					child: Widget.Icon({ icon: "system-shutdown-symbolic" }),
					onClicked: () => print("Shut down"),
				}),
			],
		}),
		// Volume slider (with mute button)
		// Brightness slider (and potentially night-light)
		Widget.Box({
			children: [
				Widget.Button({
					child: Widget.Label({ label: "wifi name" }),
					onClicked: () => print("Toggle wifi"),
				}),
				Widget.Button({
					child: Widget.Label({ label: "bluetooth" }),
					onClicked: () => print("Toggle bluetooth"),
				}),
			],
		}),
		Widget.Box({
			children: [
				Widget.Button({
					child: Widget.Label({ label: "battery limit" }),
					onClicked: () => print("Toggle battery limit"),
				}),
				Widget.Button({
					child: Widget.Label({ label: "microphone" }),
					onClicked: () => print("Toggle microphone"),
				}),
			],
		}),
		// Playing media
		// (Menu height transition and hide when not playing)
	],
});

export default (monitor: number = 0) => Widget.Window({
	monitor: monitor,
	name: "quicksettings",
	exclusivity: "exclusive",
	anchor: [ "top", "right" ],
	child: Settings(),
});
