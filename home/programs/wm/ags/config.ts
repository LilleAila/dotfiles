import Bar from "./windows/bar.ts";
import { App } from "./imports.ts";

// TODO: replace app launcher, notification daemon and wlogout with ags
// `ags -t `windowname`
App.config({
		style: App.configDir + "/style.css",
    windows: [
			Bar()
    ],
});
