{ pkgs }:

pkgs.writeShellScriptBin "startup" ''

exec > "$HOME/startup.log" 2>&1

hlrun () {
  local command="$1"
  local process="$2"
  local max_attempts=15
  local attempts=0

  echo "Command: $command"

  while true; do
    if pgrep -f "$process" >/dev/null; then
      echo "Detected: $process"
      return 0
    fi

    if (( attempts >= max_attempts )); then
      echo "ERROR: Failed to start $process after $max_attempts attempts"
      return 1
    fi

    echo "Starting $process (attempt $((attempts + 1))/$max_attempts)"
    hyprctl dispatch "hl.dsp.exec_cmd(\"$command\")"

    ((attempts += 1))
    sleep 2.5
  done
}

sleep 5

echo "Autostarting background apps"

echo "Starting shell"
hlrun "rcshell" "rcshell"

echo "Starting notification daemon"
hlrun "dunst" "dunst"

echo "Starting network-manager applet"
hlrun "nm-applet" "nm-applet"

echo "Setting Hyprland Cursor"
hyprctl setcursor Volantes 24

echo "Starting Clipboard Manager"
hlrun "wl-paste --type text --watch cliphist store" "wl-paste.*--type text"
hlrun "wl-paste --type image --watch cliphist store" "wl-paste.*--type image"

echo "Starting Application Drawer"
hlrun "nwg-drawer -r -fm thunar -ft -term foot -wm hyprland" "nwg-drawer"

sleep 1
echo "Starting Wallpaper Engine"
hlrun "wallpaperengine-gui -m" "wallpaperengine-gui"

sleep 1
echo "Starting Vesktop"
hlrun "vesktop --start-minimized" "electron"

sleep 2
echo "Starting Steam"
hlrun "steam -silent -nofriendsui -console" "steam"

sleep 1
echo "Starting Input Remapper"
hlrun "input-remapper-control --command autoload" "input-remapper"

sleep 1
echo "Starting Replay Buffer"
hyprctl notify -1 3000 "rgb(9889ff)" "fontsize:23 Started Replay Buffer"
hlrun "gpu-screen-recorder -w screen -f 60 -r 180 -c mp4 -o /mnt/G/Clips" "gpu-screen-recorder"

sleep 3
echo "Starting Audio Monitor"
hlrun "audiomonitor" "audiomonitor"

sleep 1
echo "Checking games database"
cd "$HOME/gameindex" && source .venv/bin/activate && python sync.py

echo "Started All Processes"
''
