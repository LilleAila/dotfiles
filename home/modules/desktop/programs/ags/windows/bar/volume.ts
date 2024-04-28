import {
	Widget,
	Audio,
} from "../../imports";

const volumeIcons = {
	101: "overamplified",
	67: "high",
	34: "medium",
	1: "low",
	0: "muted",
};
const getVolumeIcon = () => {
	const icon = Audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
		threshold => threshold <= Audio.speaker.volume * 100) || 0;
	return `audio-volume-${volumeIcons[icon]}-symbolic`
}
const VolumeIcon = () => Widget.Icon({
	class_name: "volume-icon",
	icon: Utils.watch(getVolumeIcon(), Audio.speaker, getVolumeIcon),
});
const VolumeSlider = () => Widget.Slider({
	class_name: "volume-slider",
	hexpand: true,
	draw_value: false,
	on_change: ({ value }) => Audio.speaker.volume = value,
	setup: self => self.hook(Audio.speaker, () => {
		self.value = Audio.speaker.volume || 0
	}),
})
export default () => Widget.Box({
	class_name: "volume",
	children: [
		VolumeIcon(),
		VolumeSlider(),
	],
});
