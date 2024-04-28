import {
	Widget,
	Battery,
} from "../../imports";

const BatteryLabel = () => Widget.Label({
	// class_name: "battery_label",
	class_name: Battery.bind("percent").transform(p => "battery_label " +
		(p <= 10 ? "critical" : p <= 25 ? "warning" : "")),
	label: Battery.bind("percent").transform(p => `${p}%`),
});

const BatteryIcon = () => Widget.Icon({
	class_name: "battery_icon",
	icon: Battery.bind("icon_name"),
});

const BatteryTime = () => Widget.Label({
	label: Battery.bind("time_remaining").transform(tr => {
		const hours = Math.floor(tr / 3600);
		const minutes = Math.floor((tr % 3600) / 60)
		if (hours > 0 || minutes > 0)
			return `${hours}:${minutes < 10 ? "0" + minutes : minutes}`
		else return ""
	}),
});

const BatteryUntil = () => Widget.Label({
	label: Battery.bind("charging").transform(ch => " Remaining until " + ( ch ? "full" : "empty" )),
});

export default () => Widget.Box({
	visible: Battery.bind("available"),
	class_name: Battery.bind("charging").transform(ch => ch ? "charging battery" : "battery"),
	children: [
		BatteryLabel(),
		BatteryIcon(),
		BatteryTime(),
		// BatteryUntil(),
	],
});
