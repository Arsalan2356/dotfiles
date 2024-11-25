const volume = Variable("0", {
	poll: [2000, 'wpctl get-volume @DEFAULT_AUDIO_SINK@'],
})

export default () => Widget.EventBox({
	class_name: "custom_b",
	child: Widget.Label({
		css: 'padding-right : 5px;',
		label: volume.bind().as(v => {
			if (v == "0")
				return "0"
			else {
				const v2 = parseFloat(v.substring(8));
				return `${v2 >= 0.5 ? " " : " "} ${v2 * 100}%`
			}
		}),
	}),
	on_primary_click: () => { Utils.execAsync("pavucontrol") },
	on_secondary_click: () => { Utils.execAsync("pavucontrol") },
	on_middle_click: () => { Utils.execAsync("pavucontrol") },
})

