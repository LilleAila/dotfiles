import { Widget } from "../../imports";

const Powermenu = () =>
  Widget.Box({
    vertical: true,
    class_name: "powermenu",
    // hpack: "center",
    // vpack: "center",
    // child: Widget.Box({
    //   class_name: "powerbuttons",
    children: [
      Widget.Button({
        class_name: "powerbutton lock",
        child: Widget.Icon({ icon: "lock-symbolic" }),
        onClicked: () => Utils.exec("ags -t powermenu && hyprlock"),
      }),
      Widget.Button({
        class_name: "powerbutton suspend",
        child: Widget.Icon({ icon: "system-suspend-symbolic" }),
        onClicked: () => Utils.exec("ags -t powermenu && systemctl suspend"),
      }),
      Widget.Button({
        class_name: "powerbutton logout",
        child: Widget.Icon({ icon: "application-exit-symbolic" }),
        onClicked: () => Utils.exec("ags -t powermenu && pkill Hyprland"),
      }),
      Widget.Button({
        class_name: "powerbutton poweroff",
        child: Widget.Icon({ icon: "system-shutdown-symbolic" }),
        onClicked: () => Utils.exec("ags -t powermenu && systemctl poweroff"),
      }),
    ],
    // }),
  });

export default (monitor: number = 0) =>
  Widget.Window({
    monitor: monitor,
    name: `powermenu`,
    exclusivity: "exclusive",
    // anchor: ["top", "right", "bottom", "left"],
    child: Powermenu(),
    visible: false,
  });
