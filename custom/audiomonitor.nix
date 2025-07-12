{ pkgs }:

pkgs.writeShellScriptBin "audiomonitor" ''
out=$(pactl get-default-source)
while true; do
  sleep 10
  prevout=$out
  echo "$prevout"
  out=$(pactl get-default-source)
  echo "$out"
  if [[ "$out" != "$prevout" ]]; then
    echo "Changed Output"
    killall -SIGTERM gpu-screen-recorder
    hyprctl notify -1 3000 "rgb(9889ff)" "fontsize:23 Started Replay Buffer"
    hyprctl dispatch exec "gpu-screen-recorder -w screen -f 60 -r 180 -c mp4 -o /mnt/G/Rnd/Clips"
  fi
done
''
