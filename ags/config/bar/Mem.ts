const mem_usage = Variable("", {
	poll: [1000, 'sysinfo memory']
})


export default () =>
	Widget.Label({
		label: mem_usage.bind().as(v => `${v} GiB`),
		justification: "center",
		maxWidthChars: 10,
		useMarkup: true,
	})


