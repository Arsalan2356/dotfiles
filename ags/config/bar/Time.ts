
const n = Variable(0);
var prev_date = -1;
const pad = (v: number) => { return v.toString().padStart(2, "0") };
const day = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
const tooltip_text = Variable("");


const update_tooltip_text = () => {
  const v = Utils.exec(`cal -s`)
  // TODO: add second portion where we highlight the current day via some math to find it's pos in the text
  tooltip_text.setValue(v);
}

const time = Variable("", {
  poll: [
    500,
    function() {
      var t = "";
      const d = new Date();
      const date = d.getDate();
      if (n.getValue() == 0) {
        t = `${pad(date)}/${pad(d.getMonth() + 1)}/${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
      }
      else {
        t = `${day[d.getDay()]} ${pad(date)}, ${month[d.getMonth()]} ${d.getFullYear()}`;
      }
      update_tooltip_text();

      return t
    },
  ],
});

export default () => Widget.EventBox({
  child: Widget.Label({
    class_name: "time",
    label: time.bind(),
    tooltip_text: tooltip_text.bind()
  }),
  on_primary_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
  on_secondary_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
  on_middle_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
  on_scroll_up: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
  on_scroll_down: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
})

