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
const lock = () => Utils.exec("hyprlock");
const logout = () => Utils.exec("pkill hyprland");
const suspend = () => Utils.exec("systemctl suspend");
const poweroff = () => Utils.exec("systemctl poweroff");

const Powermenu = () =>
  Widget.Box({
    class_name: "powermenu",
    vpack: "center",
    hpack: "center",
    children: [
      // TODO: close menu before running other actions
      Button("powerbutton cancel", "window-close-symbolic", closeMenu),
      Button("powerbutton lock", "lock-symbolic", lock),
      Button("powerbutton logout", "application-exit-symbolic", logout),
      Button("powerbutton suspend", "system-suspend-symbolic", suspend),
      Button("powerbutton poweroff", "system-shutdown-symbolic", poweroff),
    ],
    setup: (w) => {
      w.keybind("Escape", closeMenu);
      w.keybind("l", lock);
      w.keybind("e", logout);
      w.keybind("s", suspend);
      w.keybind("p", poweroff);
    },
  });

export default (monitor: number = 0) =>
  Widget.Window({
    monitor: monitor,
    name: `powermenu`,
    keymode: "exclusive",

    hexpand: false,
    vexpand: false,
    hpack: "center",
    vpack: "center",

    exclusivity: "ignore",
    anchor: ["top"],
    margins: [100, 0, 0, 0],
    // anchor: ["top", "right", "bottom", "left"],

    child: Powermenu(),
    visible: false,
  });
