const hyprland = await Service.import("hyprland")

export default () => Widget.Label({
  class_name: "client-title",
  tooltip_text: hyprland.active.client.bind("title"),
  label: hyprland.active.client.bind("title").as((title: string) => {
    if (title.includes("Firefox")) {
      title = `󰈹  ${title.substring(0, title.lastIndexOf("Firefox") - 3)}`
    }
    else if (title.includes("vim")) {
      title = ` ${title.substring(title.indexOf("vim") + 3)}`
    }
    else if (title.includes("Vesktop")) {
      title = `  ${title}`
    }
    else if (title.includes("Thunar")) {
      title = ` ${title.substring(0, title.indexOf("Thunar") - 3)}`
    }
    return title.length <= 60 ? title : title.substring(0, 60) + " ..."
  })
})
