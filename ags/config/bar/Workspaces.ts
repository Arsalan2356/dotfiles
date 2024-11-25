// Make event box so we can scroll

const hyprland = await Service.import("hyprland");
const submap = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"];
const supermap = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
const events = ["workspace", "workspacev2", "createworkspace", "createworkspacev2", "openwindow", "closewindow", "movewindow", "movewindowv2"];

var workspaces = Array.from({ length: 8 }, (_) => Variable(0));
var class_names = Array.from({ length: 8 }, (_) => Variable(["workspacechild"]))


for (let i = 0; i < workspaces.length; i++) {
	workspaces[i].setValue(0);
	class_names[i].setValue(["workspacechild"]);
}

for (const el of hyprland.workspaces) {
	workspaces[el.id - 1].setValue(el.windows);
	if (hyprland.active.workspace.id == el.id) {
		class_names[el.id - 1].setValue(["workspacechild", "active"]);
	}
	else if (el.windows > 0) {
		class_names[el.id - 1].setValue(["workspacechild", "occupied"]);
	}
}

hyprland.connect("event", (__, v, _) => {
	if (events.includes(v)) {
		for (let i = 0; i < workspaces.length; i++) {
			workspaces[i].setValue(0);
			class_names[i].setValue(["workspacechild"]);
		}
		for (const el of hyprland.workspaces) {
			workspaces[el.id - 1].setValue(el.windows);
			if (hyprland.active.workspace.id == el.id) {
				class_names[el.id - 1].setValue(["workspacechild", "active"]);
			}
			else if (el.windows > 0) {
				class_names[el.id - 1].setValue(["workspacechild", "occupied"]);
			}
		}
	}
})

export default () => Widget.Box({
	class_name: "workspaces",
	children: Array.from({ length: 8 }, (_, i) => i + 1).map(i => Widget.EventBox({
		"on-primary-click": (_) => {
			hyprland.messageAsync(`dispatch workspace ${i}`)
		},
		child: Widget.Label({
			attribute: i,
			class_names: class_names[i - 1].bind(),
			hpack: "center",
			label: workspaces[i - 1].bind().as(v => {
				var x = "";
				var j = v;
				while (j != 0) {
					x = submap[j % 10] + x;
					j = Math.floor(j / 10);
				}
				return v == 0 ? `${i}` : `${supermap[i]}⁄${x}`
			}),
		})
	})),
});




