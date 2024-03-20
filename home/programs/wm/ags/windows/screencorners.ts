import {
	GLib,
	App,
	Service,
	Utils,
	Variable,
	Widget,
	Audio,
	Battery,
	Bluetooth,
	Hyprland,
	Mpris,
	Network,
	Notifications,
	PowerProfiles,
	SystemTray,
} from "../imports";
import Gdk from "gi://Gdk"

export default (monitor: number = 0) => Widget.Window({
    monitor: monitor,
    name: `corner${monitor}`,
    class_name: "screen-corner",
    anchor: ["top", "bottom", "right", "left"],
    click_through: true,
    child: Widget.Box({
        class_name: "corners",
				expand: true,
    }),
})
