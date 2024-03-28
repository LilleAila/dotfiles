import { Widget } from "../../imports";

const Settings = () =>
  Widget.Box({
    vertical: true,
    class_name: "quicksettings",
    children: [
      Widget.Box({
        class_name: "power",
        hpack: "end",
        children: [
          Widget.Label({
            class_name: "title-label",
            label: "Quick Settings",
          }),
          // I found icon names using the icon browser example from ags github
          Widget.Button({
            class_name: "power-button",
            child: Widget.Icon({ icon: "lock-symbolic" }),
            onClicked: () => Utils.exec("hyprlock"),
          }),
          Widget.Button({
            class_name: "power-button",
            child: Widget.Icon({ icon: "application-exit-symbolic" }),
            onClicked: () => Utils.exec("loginctl terminate-user $USER"),
          }),
          Widget.Button({
            class_name: "power-button",
            child: Widget.Icon({ icon: "system-shutdown-symbolic" }),
            onClicked: () => Utils.exec("systemctl poweroff"),
          }),
        ],
      }),
      // Volume slider (with mute button)
      // Brightness slider (and potentially night-light toggle)
      Widget.Box({
        class_name: "controls",
        children: [
          Widget.Button({
            class_name: "toggle",
            child: Widget.Box({
              children: [
                Widget.Icon({
                  class_name: "toggle-icon",
                  icon: "network-wireless-signal-good-symbolic",
                }),
                Widget.Label({
                  class_name: "toggle-label",
                  label: "Sushi",
                }),
              ],
            }),
            onClicked: () => print("Toggle wifi"),
          }),
          Widget.Button({
            class_name: "toggle disabled",
            child: Widget.Box({
              children: [
                Widget.Icon({
                  class_name: "toggle-icon",
                  icon: "bluetooth-active-symbolic",
                }),
                Widget.Label({
                  class_name: "toggle-label",
                  label: "Disabled",
                }),
              ],
            }),
            onClicked: () => print("Toggle bluetooth"),
          }),
        ],
      }),
      Widget.Box({
        class_name: "controls",
        children: [
          Widget.Button({
            class_name: "toggle",
            child: Widget.Box({
              children: [
                Widget.Icon({
                  class_name: "toggle-icon",
                  icon: "battery-good-symbolic",
                }),
                Widget.Label({
                  class_name: "toggle-label",
                  label: "Limited",
                }),
              ],
            }),
            onClicked: () => print("Toggle battery limit"),
          }),
          Widget.Button({
            class_name: "toggle",
            child: Widget.Box({
              children: [
                Widget.Icon({
                  class_name: "toggle-icon",
                  icon: "audio-input-microphone-high-symbolic",
                }),
                Widget.Label({
                  class_name: "toggle-label",
                  label: "Unmuted",
                }),
              ],
            }),
            onClicked: () => print("Toggle microphone"),
          }),
        ],
      }),
      // Playing media
      // (Menu height transition and hide when not playing)
    ],
  });

export default (monitor: number = 0) =>
  Widget.Window({
    monitor: monitor,
    name: "quicksettings",
    exclusivity: "exclusive",
    anchor: ["top", "right"],
    child: Settings(),
    visible: false,
  });
