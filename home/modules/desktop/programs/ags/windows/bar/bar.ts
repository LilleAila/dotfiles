import { Widget } from "../../imports";
import Workspaces from "./workspaces.ts";
import Time from "./time.ts";
import SysTray from "./systray.ts";
import Volume from "./volume.ts";
import BatteryStatus from "./battery.ts";
import PowerMenu from "./power.ts";

const Start = () =>
  Widget.Box({
    hexpand: true,
    hpack: "start",
    children: [Time(), Workspaces()],
  });

const Center = () =>
  Widget.Box({
    children: [Time()],
  });

const End = () =>
  Widget.Box({
    hexpand: true,
    hpack: "end",
    children: [SysTray(), Volume(), BatteryStatus(), PowerMenu()],
  });

export default (monitor: number = 0) =>
  Widget.Window({
    // monitor: monitor
    monitor: monitor,
    name: `bar${monitor}`,
    class_name: "bar_window",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    // margins: [5, 5, 0, 5],
    child: Widget.CenterBox({
      className: "bar",

      startWidget: Start(),
      //centerWidget: Center(),
      endWidget: End(),
    }),
  });
