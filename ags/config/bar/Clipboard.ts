export default () => Widget.EventBox({
	class_name: "custom_b",
	child: Widget.Label({
		css: 'font-size : 20px;'
			+ 'padding-right : 3pt',
		label: "󰅌"
	}),
	on_primary_click: () => { Utils.execAsync("nwg-clipman") },
	on_secondary_click: () => { Utils.execAsync("nwg-clipman") },
	on_middle_click: () => { Utils.execAsync("nwg-clipman") },
})
