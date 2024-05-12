export default (monitor: number = 0) =>
  Widget.Window({
    monitor: monitor,
    name: `osd${monitor}`,
    class_name: "osd",
  });
