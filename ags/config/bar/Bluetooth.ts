
const icons = ["󰥈 ", "󰥆 ", "󰥅 ", "󰥄 ", "󰥃 ", "󰥂 ", "󰥁 ", "󰥀 ", "󰤿 ", "󰤾 "];

const btbattery = Variable("", {
  poll: [2000, 'btbattery']
});

export default () => Widget.EventBox({
  class_name: "custom_b",
  child: Widget.Label({
    label: btbattery.bind().as(v => {
      if (v == "")
        return "󰂯"
      else {
        const icon_index = Math.round((100 - parseFloat(v)) / 10);
        return `${icons[Math.max(0, Math.min(icon_index, 9))]} ${parseInt(v)}%`
      }
    }),
  }),
  on_primary_click: () => { Utils.execAsync("foot -e bluetuith") },
  on_secondary_click: () => { Utils.execAsync("foot -e bluetuith") },
  on_middle_click: () => { Utils.execAsync("foot -e bluetuith") },
})
