// Add calendar on hover
// text calendar (ascii type)

const n = Variable(0);
const pad = (v: number) => { return v.toString().padStart(2, "0") };
const day = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']


const time = Variable("", {
	poll: [
		500,
		function() {
			if (n.getValue() == 0) {
				const d = new Date();
				return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
			}
			else {
				const d = new Date();
				return `${day[d.getDay()]} ${pad(d.getDate())}, ${month[d.getMonth()]} ${d.getFullYear()}`;
			}

		},
	],
});

export default () => Widget.EventBox({
	child: Widget.Label({
		class_name: "time",
		label: time.bind().as(v => `${v}`)
	}),
	on_primary_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
	on_secondary_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
	on_middle_click: () => { n.setValue(n.getValue() == 0 ? 1 : 0) },
})

