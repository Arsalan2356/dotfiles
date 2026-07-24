{ pkgs }:

pkgs.writeShellScriptBin "startup" ''

exec > ~/startup.log 2>&1

hlrun () {
  echo "Command: $1"
  hyprctl dispatch 'hl.dsp.exec_cmd("'$1'")'
}

hlexec () {
  echo "Command: $1"
  hyprctl dispatch 'hl.dsp.exec_cmd("$1")'
}


echo "Autostarting background apps"


echo "Starting shell"
hlrun "rcshell"

echo "Starting notification daemon"
hlrun "dunst"

echo "Starting network-manager applet"
hlrun "nm-applet"

echo "Setting Hyprland Cursor"
hyprctl setcursor Volantes 24

echo "Starting Clipboard Manager"
hlexec "wl-paste --type text --watch cliphist store"
hlexec "wl-paste --type image --watch cliphist store"

echo "Starting Application Drawer"
hlexec "nwg-drawer -r -fm thunar -ft -term foot -wm hyprland"

sleep 1
echo "Starting Wallpaper Engine"
hlexec "wallpaperengine-gui -m"

sleep 1
echo "Starting Vesktop"
hlexec "vesktop --start-minimized"

sleep 2
echo "Starting Steam"
hlexec "steam -silent -nofriendsui -console"

sleep 1
echo "Starting Input Remapper"
hlexec "input-remapper-control --command autoload"

sleep 1
echo "Starting Replay Buffer"
hyprctl notify -1 3000 "rgb(9889ff)" "fontsize:23 Started Replay Buffer"
hlexec "gpu-screen-recorder -w screen -f 60 -r 180 -c mp4 -o /mnt/G/Clips"

sleep 3
echo "Starting Audio Monitor"
hlrun "audiomonitor"

sleep 1
echo "Checking games database"
cd gameindex && source .venv/bin/activate && python sync.py

echo "Started All Processes"
''
