import Bar from "./windows/bar.ts";
import ScreenCorners from "./windows/screencorners.ts";
import { App } from "./imports.ts";

// TODO: replace app launcher, notification daemon and wlogout with ags
// `ags -t `windowname`
App.config({
		style: App.configDir + "/style.css",
    windows: [
			Bar(0),
			ScreenCorners(0),
    ],
});
