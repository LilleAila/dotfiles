import { Widget } from "../../imports";

const Button = (classname: string, icon: string, click: any) =>
  Widget.Button({
    class_name: classname,
    child: Widget.Icon({ icon: icon, size: 96 }),
    onClicked: click,
    hexpand: false,
    vexpand: false,
    hpack: "center",
    vpack: "center",
  });

const closeMenu = () => App.closeWindow("powermenu");

const Powermenu = () =>
  Widget.Box({
    class_name: "powermenu",
    children: [
      // TODO: close menu before running other actions
      Button("powerbutton cancel", "window-close-symbolic", closeMenu),
      Button("powerbutton lock", "lock-symbolic", () => Utils.exec("hyprlock")),
      Button("powerbutton suspend", "system-suspend-symbolic", () =>
        Utils.exec("systemctl suspend"),
      ),
      Button("powerbutton logout", "application-exit-symbolic", () =>
        Utils.exec("pkill Hyprland"),
      ),
      Button("powerbutton poweroff", "system-shutdown-symbolic", () =>
        Utils.exec("systemctl poweroff"),
      ),
    ],
  });

// TODO: Add margin to window (only on top) or alternatively center it on screen
export default (monitor: number = 0) =>
  Widget.Window({
    monitor: monitor,
    name: `powermenu`,

    hexpand: false,
    vexpand: false,
    hpack: "center",
    vpack: "center",

    exclusivity: "ignore",
    anchor: ["top"],
    // anchor: ["top", "right", "bottom", "left"],
    child: Powermenu(),
    visible: false,
  });
