import { Widget, Notifications, Utils } from "../../imports.ts";

const NotificationIcon = ({ app_entry, app_icon, image }) => {
  if (image)
    // Can probably be set inside css instead of hard-coded here
    return Widget.Box({
      css:
        `background-image: url("${image}");` +
        `background-size: contain;` +
        `background-repeat: no-repeat;` +
        `background-position: center;`,
    });

  let icon = "dialog-information-symbolic";
  if (Utils.lookUpIcon(app_icon)) icon = app_icon;

  if (app_entry && Utils.lookUpIcon(app_entry)) icon = app_entry;

  return Widget.Box({
    child: Widget.Icon(icon),
  });
};

const Notification = (n: any) => {
  const icon = Widget.Box({
    vpack: "start",
    class_name: "icon",
    child: NotificationIcon(n),
    hexpand: false,
    vexpand: false,
  });

  const title = Widget.Label({
    class_name: "title",
    xalign: 0,
    justification: "left",
    hexpand: true,
    max_width_chars: 24,
    truncate: "end",
    wrap: true,
    label: n.summary,
    use_markup: true,
  });

  const body = Widget.Label({
    class_name: "body",
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: "left",
    label: n.body,
    wrap: true,
  });

  const actions = Widget.Box({
    class_name: "actions",
    children: n.actions.map(({ id, label }) =>
      Widget.Button({
        class_name: "action-button",
        on_clicked: () => {
          n.invoke(id);
          n.dismiss();
        },
        hexpand: true,
        child: Widget.Label(label),
      }),
    ),
  });

  return Widget.EventBox(
    {
      attribute: { id: n.id },
      on_primary_click: n.dismiss,
    },
    Widget.Box(
      {
        class_name: `notification ${n.urgency}`,
        vertical: true,
      },
      Widget.Box([icon, Widget.Box({ vertical: true }, title, body)]),
      actions,
    ),
  );
};

export default (monitor: number = 0) => {
  const list = Widget.Box({
    vertical: true,
    children: Notifications.popups.map(Notification),
  });

  function onNotified(_: any, id: number) {
    const n = Notifications.getNotification(id);
    if (n) list.children = [Notification(n), ...list.children];
  }

  function onDismissed(_: any, id: number) {
    list.children.find((n) => n.attribute.id === id)?.destroy();
  }

  list
    .hook(Notifications, onNotified, "notified")
    .hook(Notifications, onDismissed, "dismissed");

  return Widget.Window({
    monitor,
    name: `notifications${monitor}`,
    class_name: "notification-popups",
    anchor: ["top", "right"],
    child: Widget.Box({
      class_name: "notifications",
      vertical: true,
      child: list,
    }),
  });
};
