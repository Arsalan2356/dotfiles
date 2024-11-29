
export default () => Widget.EventBox({
  class_name: "custom_b",
  child: Widget.Label({
    css: 'color: #e8e8e8;'
      + 'font-size : 20px;'
      + 'padding-right : 5px;',
    label: " "
  }),
  on_primary_click: () => { Utils.execAsync("wlogout") },
  on_secondary_click: () => { Utils.execAsync("wlogout") },
  on_middle_click: () => { Utils.execAsync("wlogout") },
})
