import { Widget, Utils, Variable } from "../../imports";

const icon = Variable("night-light-disabled-symbolic");
const toggle = () => {
  const state = Utils.exec("matcha -t -b waybar");
  const enabled = state.match(/Enabled/g);
  icon.value = enabled
    ? "night-light-symbolic"
    : "night-light-disabled-symbolic";
};

export default () =>
  Widget.Box({
    class_name: "idle_inhibit",
    vpack: "center",
    tooltip_text: "Inhibit Idle",
    child: Widget.Button({
      hexpand: false,
      vexpand: false,
      class_name: "inhibit_button button",
      on_clicked: toggle,
      child: Widget.Icon({
        class_name: "inhibit_icon",
        icon: icon.bind(),
      }),
    }),
  });
