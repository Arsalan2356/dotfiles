
const hyprland = await Service.import("hyprland");

// Workspace changes -> reload all clients and get new ones
// Open/Close Window -> remove said window from the list or just reload all windows
// Active Window -> set a classname on the active window to give it some highlight or something
// Urgent Window -> flickering on said window to indicate urgency
const events = ["workspacev2", "openwindow", "closewindow", "activewindowv2", "urgent", "movewindowv2"];


class Client {
  initialTitle: string;
  id: number;
  focus: number;
  title: any;
  windowClass: string;
  class_names: any;
  constructor(initialTitle: string, id: string, focusHistory: string, title: any, cl: string, cnames: string) {
    this.initialTitle = initialTitle;
    this.id = parseInt(id);
    this.focus = parseInt(focusHistory);
    this.title = title;
    this.windowClass = cl;
    this.class_names = Variable(cnames);
  }
}





var windows = Variable(new Map<String, Client>());
export var inactive = Variable(false);

// Load all windows once before starting
const out = Utils.exec("hyprclients").split("\n");

const startm = new Map();

const active_workspace_stats = Utils.exec("hypractive").split("<separator>");
const active_id = parseInt(active_workspace_stats[0]);
for (const q of out) {
  const vals = q.split("<separator>");
  if (parseInt(vals[2]) == active_id) {
    var tempcname = "clientchild";
    if (parseInt(vals[3]) == 0) {
      tempcname += ",active";
    }
    startm.set(vals[0], new Client(vals[1], vals[2], vals[3], Variable(vals[4]), vals[5], tempcname));
  }
}
windows.setValue(startm);

const numWindows = parseInt(active_workspace_stats[1]);
if (numWindows == 0) {
  inactive.setValue(true);
}


hyprland.connect("event", (__, v, _args) => {
  if (events.includes(v)) {
    if (v == "activewindowv2") {
      const out = Utils.exec("hyprclients").split("\n");
      for (const q of out) {
        const vals = q.split("<separator>");
        const w = windows.getValue().get(vals[0]);
        if (parseInt(vals[3]) == 0) {
          if (w != undefined)
            w.class_names.setValue("clientchild,active");
        }
        else {
          w?.class_names.setValue("clientchild");
        }
      }
    }
    else {
      const active_workspace_stats = Utils.exec("hypractive").split("<separator>");
      const active_workspace_id = parseInt(active_workspace_stats[0]);
      const newm = new Map();
      const out = Utils.exec("hyprclients").split("\n");
      for (const q of out) {
        const vals = q.split("<separator>");
        if (parseInt(vals[2]) == active_workspace_id) {
          var tempcname = "clientchild";
          if (parseInt(vals[3]) == 0) {
            tempcname += ",active";
          }
          newm.set(vals[0], new Client(vals[1], vals[2], vals[3], Variable(vals[4]), vals[5], tempcname));
        }
      }
      const numWindows = parseInt(active_workspace_stats[1]);
      if (numWindows == 0) {
        inactive.setValue(true);
      }
      else {
        inactive.setValue(false);
      }
      windows.setValue(newm);
    }
  }
  else {
    if (v == "windowtitlev2") {
      const i = _args.indexOf(",");
      const addr = _args.substring(0, i);
      const newt = _args.substring(i + 1);
      const m = windows.getValue().get("0x" + addr);
      if (m != undefined) {
        m.title.setValue(newt);
      }
    }
  }
})


export default () => Widget.Box({
  class_name: "clients",
  spacing: 8,
  children: windows.bind().as(m => {
    Utils.exec("iconfinderdb");
    const q = Array.from(m.entries())
      .map(e => {
        const icon = Utils.exec(`iconfinder "${e[1].initialTitle}"`);
        const i1 = (icon == "" || icon.includes(".svgz")) ? ["/home/rc/default/window-icon.svg", "0"] : icon.split("<separator>");
        const icon2 = Utils.exec(`iconfinder "${e[1].windowClass}"`);
        const i2 = (icon2 == "" || icon.includes(".svgz")) ? ["/home/rc/default/window-icon.svg", "0"] : icon2.split("<separator>");
        // Wrap this in an event box and try to listen for events to maybe switch which window is active?
        return Widget.Icon({
          class_names: e[1].class_names.bind().as((c: string | undefined) => {
            if (c != undefined) {
              return c.split(",")
            }
            else {
              return ["clientchild"]
            }
          }),
          icon: parseFloat(i2[1]) - parseFloat(i1[1]) > 0.2 ? i2[0] : i1[0],
          css: 'font-size : 30px',
          tooltip_text: e[1].title.bind(),
        })
      })
    return q;
  })
});




