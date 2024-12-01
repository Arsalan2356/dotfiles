// Switch icons based on whether something is playing in current player
// Allow switching current player by scrolling
// Show something (event box) when clicking on current player name (!? maybe pavucontrol)
// Possibly icons instead of names ? might be easier to work with
// Use existing iconfinder and parse name and pass to get a path for an icon


const currplayer = Variable(0)
const clients = Variable([], {
  poll: [380, () => {
    const q = Utils.exec("playerctl -l").split("\n")
    return q
  }]
})
const ispaused = Variable(true, {
  poll: [1000, () => {
    if (currplayer != undefined) {
      const ind = currplayer.getValue()
      if (clients != undefined) {
        const k = Utils.exec(`playerctl status -p ${clients.getValue()[ind]}`)
        if (k.includes("Playing")) {
          return false;
        }
      }
    }
    return true;
  }]
})

export default () => Widget.Box({
  spacing: 14,
  css: 'padding-right: 5px',
  children: [
    Widget.EventBox({
      child: Widget.Label({
        label: clients.bind().as(v => {
          const ind = currplayer.getValue()
          const name = v[ind >= v.length - 1 ? v.length - 1 : ind]
          const i = name.indexOf(".")
          return i != -1 ? name.substring(0, i) : name
        })
      }),
      on_scroll_up: (_) => {
        const oldval = currplayer.getValue()
        const v = clients.getValue()
        currplayer.setValue(oldval <= 0 ? v.length - 1 : oldval - 1)
      },
      on_scroll_down: (_) => {
        const oldval = currplayer.getValue()
        const v = clients.getValue()
        currplayer.setValue(oldval >= v.length - 1 ? 0 : oldval + 1)
      },
    }),
    Widget.CenterBox({
      spacing: 21,
      start_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: `${App.configDir}/style/assets/previous.svg`,
        }),
        on_primary_click: () => { Utils.execAsync(`playerctl previous -p ${clients.getValue()[currplayer.getValue()]}`)}
      }),
      center_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: ispaused.bind().as(v => {
            return `${App.configDir}/style/assets/${v ? "play" : "pause"}.svg`
          })
        }),
        on_primary_click: () => { Utils.execAsync(`playerctl play-pause -p ${clients.getValue()[currplayer.getValue()]}`)}
      }),
      end_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: `${App.configDir}/style/assets/next.svg`,
        }),
        on_primary_click: () => { Utils.execAsync(`playerctl next -p ${clients.getValue()[currplayer.getValue()]}`)}
      })
    }),
    Widget.Label({
      label: "|",
    })
  ]
})


