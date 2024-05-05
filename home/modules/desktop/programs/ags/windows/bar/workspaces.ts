import { Widget, Hyprland, Utils, GLib } from "../../imports";

//const active_specialisation = Utils.exec(
//  "printenv NIXOS_ACTIVE_SPECIALISATION",
//);

const active_specialisation = GLib.getenv("NIXOS_ACTIVE_SPECIALISATION");

export default () =>
  Widget.Box({
    class_name: `workspaces specialisation_${active_specialisation}`,
    children: [...Array(10)].map((_, i) => {
      const id = i + 1;
      return Widget.Button({
        class_name: "workspace",
        attribute: id,

        // Stop it from extending beyond min-height and min-width:
        hexpand: false,
        vexpand: false,
        vpack: "center",

        on_clicked: () => Hyprland.message(`dispatch workspace ${id}`),
        setup: (self) =>
          self.hook(Hyprland, () => {
            self.toggleClassName("active", Hyprland.active.workspace.id === id);
            self.toggleClassName(
              "occupied",
              (Hyprland.getWorkspace(id)?.windows || 0) > 0,
            );
            self.toggleClassName(
              "mon0",
              (Hyprland.getWorkspace(id)?.monitorID || 0) == 0,
            );
            self.toggleClassName(
              "mon1",
              (Hyprland.getWorkspace(id)?.monitorID || 0) == 1,
            );
          }),
      });
    }),
  });
