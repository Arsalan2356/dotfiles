{ pkgs }:

pkgs.writeShellScriptBin "btbattery" ''
  jc upower -d | jq -r 'if .[] | select(.native_path) | select(.native_path | contains("bluez")) | length == 0 then "" else .[] | select(.native_path) | select(.native_path | contains("bluez")) | .detail.percentage end'
''
