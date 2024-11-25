import Launcher from "./Launcher";
import Workspaces from "./Workspaces";
import Clients from "./Clients";
import ClientTitle from "./ClientTitle";
// import Cpu from "./Cpu";
// import Mem from "./Mem";
import Bluetooth from "./Bluetooth";
import Volume from "./Volume";
// import Clipboard from "./Clipboard";
import Time from "./Time";
import SysTray from "./SysTray";
import Logout from "./Logout";


/*
	change all event boxes to have a hover translucency thing
	(have a blue shade when hovering over them)
	# change workspaces and how they appear and how the # of windows show up
	# rewrite workspaces
	# remove the gray background behind non-active workspaces (still visible)
	# everything should try and blend into the background
	# add in the icons stuff with the clients (need to first make the iconfinder)
	change client title to have an icon instead of a nerdfont text icon
	add gpu usage to cpu and memory area and combine into one class file
	date is fine but maybe move it around more to the right
	bluetooth icon should be right beside the tray
	# bluetooth should have a battery percentage beside it (update maybe every 5 minutes idk)
	clipboard either remove or move somewhere else (feels out of place)
	maybe create some sort of dropdown or something (should be beside the tray icons)
	tray icons are fine but just move it around
	create a volume box with the ability to at least see volume and maybe change it

# ALL DONE
	FOR CLIENTS
	we've switched to a db and query model (as long as we reubuild at most half the time,
	this is faster)
	So, we create the db once when creating the list of cliets and then we only query
	This will always be faster than the other method as long as this condition is met

	TODO:
	ADD STEAM INTEGRATION (read acf convert into a dictionary mapping titles to appids)
	then query with the appid instead of the title
	Don't strip steam_icon_ anymore since we're gonna be reading appids directly

*/


const Left = Widget.Box({
	spacing: 2,
	children: [Launcher(), Workspaces(), ClientTitle()],
});

const Center = Widget.Box({
	spacing: 5,
	children: [Clients()],
});

const Right = Widget.Box({
	hpack: "end",
	spacing: 9,
	children: [
		// Cpu(),
		// Mem(),
		Volume(),
		Bluetooth(),
		// Clipboard(),
		SysTray(),
		Time(),
		Logout(),
	],
});

export default (monitor: number = 0) =>
	Widget.Window({
		monitor,
		name: `bar${monitor}`,
		className: "bar",
		anchor: ["top", "left", "right"],
		exclusivity: "exclusive",
		vexpand: true,
		child: Widget.CenterBox({
			spacing: 5,
			start_widget: Left,
			center_widget: Center,
			end_widget: Right,
		})
	})
