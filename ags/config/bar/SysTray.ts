import { TrayItem } from "types/service/systemtray";

const systemtray = await Service.import('systemtray')

const SysTrayItem = (item: TrayItem) => Widget.EventBox({
  class_name: "systrayitem",
  child: Widget.Icon().bind('icon', item, 'icon'),
  tooltipMarkup: item.bind('tooltip_markup'),
  on_primary_click: (_, event) => item.activate(event),
  on_secondary_click: (_, event) => item.openMenu(event),
});

export default () => Widget.Box({
  class_name: "systray",
  spacing: 16,
  children: systemtray.bind('items').as(i => i.map(SysTrayItem))
})
