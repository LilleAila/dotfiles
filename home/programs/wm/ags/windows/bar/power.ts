import { Widget } from "../../imports";

const PowerButton = () =>
  Widget.Button({
    class_name: "button power",
    onClicked: () => App.openWindow("powermenu"),
    child: Widget.Icon({ icon: "system-shutdown-symbolic" }),
    hexpand: false,
    vexpand: false,
    hpack: "center",
    vpack: "center",
  });

export default PowerButton;
