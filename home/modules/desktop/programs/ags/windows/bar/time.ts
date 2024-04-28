import {
	Widget,
} from "../../imports";

const date = Variable('', {
	poll: [1000, 'date +"%H:%M"'],
});
const full_date = Variable('', {
	poll: [1000, 'date +"%A %d. %B %Y, Uke %V"'],
});
export default () => Widget.Label({
	label: date.bind(),
	"tooltip-text": full_date.bind().transform(text =>
		text.charAt(0).toUpperCase() + text.slice(1)
	),
	class_name: "date",
});
