import { Widget } from "../../imports";

const Button = (classname: string, icon: string, click: any, tooltip: string) =>
  Widget.Button({
    class_name: classname,
    child: Widget.Icon({ icon: icon, size: 64 }),
    onClicked: click,
    hexpand: false,
    vexpand: false,
    hpack: "center",
    vpack: "center",
    "tooltip-text": tooltip,
  });

const closeMenu = () => App.closeWindow("powermenu");
const lock = () => {
  closeMenu();
  Utils.exec("swaylock");
};
const logout = () => Utils.exec("hyprctl dispatch exit");
const suspend = () => {
  closeMenu();
  Utils.exec("swaylock & systemctl suspend");
};
const hibernate = () => {
  closeMenu();
  Utils.exec("swaylock & systemctl hibernate");
};
const poweroff = () => Utils.exec("systemctl poweroff");

const Powermenu = () =>
  Widget.Box({
    class_name: "powermenu",
    vpack: "center",
    hpack: "center",
    children: [
      Button("powerbutton cancel", "window-close-symbolic", closeMenu, "Cancel"),
      Button("powerbutton lock", "lock-symbolic", lock, "Lock"),
      Button("powerbutton logout", "application-exit-symbolic", logout, "Log out"),
      Button("powerbutton suspend", "system-suspend-symbolic", suspend, "Suspend"),
      Button("powerbutton hibernate", "system-hibernate-symbolic", hibernate, "Hibernate"),
      Button("powerbutton poweroff", "system-shutdown-symbolic", poweroff, "Power off"),
    ],
    setup: (w) => {
      w.keybind("Escape", closeMenu);
      w.keybind("l", lock);
      w.keybind("e", logout);
      w.keybind("s", suspend);
      w.keybind("h", hibernate);
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
    //anchor: ["top", "right", "bottom", "left"],

    child: Powermenu(),
    visible: false,
  });
