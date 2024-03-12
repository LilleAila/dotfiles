import Bar from "./windows/bar.ts";
import { App } from "./imports.ts";

App.config({
		style: App.configDir + "/style.css",
    windows: [
			Bar()
    ],
});
