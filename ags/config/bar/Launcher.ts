export default () =>
  Widget.EventBox({
    class_name: "custom_b",
    child: Widget.Icon({
      class_name: "launcher",
      icon: `${App.configDir}/style/assets/gamma.svg`,
      size: 26,
      tooltip_text: "Application Drawer",
    }),
    on_primary_click: () => { Utils.execAsync("nwg-drawer") },
    on_secondary_click: () => { Utils.execAsync("nwg-drawer") },
    on_middle_click: () => { Utils.execAsync("nwg-drawer") },
  })
