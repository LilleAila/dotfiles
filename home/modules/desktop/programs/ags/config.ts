import Bar from "./windows/bar/bar.ts";
import ScreenCorners from "./windows/screencorners.ts";
import QuickSettings from "./windows/quicksettings/quicksettings.ts";
import Powermenu from "./windows/powermenu/powermenu.ts";
import Notifications from "./windows/notifications/notifications.ts";
import Applauncher from "./windows/applauncher/applauncher.ts";
import OSD from "./windows/osd/osd.ts";
import { App } from "./imports.ts";

// TODO: replace app launcher, notification daemon and wlogout with ags
// `ags -t `windowname`
App.config({
  style: App.configDir + "/style.css",
  windows: [
    Bar(0),
    //ScreenCorners(0),
    QuickSettings(0),
    Powermenu(0),
    Notifications(0),
    Applauncher(),
    OSD(),
  ],
});
