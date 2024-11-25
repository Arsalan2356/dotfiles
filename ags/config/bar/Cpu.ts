const cpu = Variable(0, {
	poll: [2250, 'sysinfo cpu']
})

export default () =>
	Widget.Label({
		label: cpu.bind().as(v => `${v}%  `),
		justification: "center",
	})
