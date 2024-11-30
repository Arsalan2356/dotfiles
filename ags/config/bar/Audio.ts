// Switch icons based on whether something is playing in current player
// Allow switching current player by scrolling
// Show something (event box) when clicking on current player name (!? maybe pavucontrol)
// Possibly icons instead of names ? might be easier to work with
// Use existing iconfinder and parse name and pass to get a path for an icon


const currplayer = Variable(0)
const clients = Variable([], {
  poll: [1000, () => {
    const q = Utils.exec("playerctl -l").split("\n")
    return q
  }]
})

export default () => Widget.Box({
  spacing: 10,
  css: 'padding-right: 5px',
  children: [
    Widget.Label({
      label: currplayer.bind().as(v => {
        const name = clients.getValue()[v]
        const i = name.indexOf(".")
        return i != -1 ? name.substring(0, i) : name
      })
    }),
    Widget.CenterBox({
      spacing: 16,
      start_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: `${App.configDir}/style/assets/previous.svg`,
        })
      }),
      center_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: `${App.configDir}/style/assets/play.svg`,
        })
      }),
      end_widget: Widget.EventBox({
        child: Widget.Icon({
          icon: `${App.configDir}/style/assets/next.svg`,
        })
      })
    }),
    Widget.Label({
      label : "|",
    })
  ]
})


