#!/usr/bin/env bash

commit=$(curl --silent "https://api.github.com/repos/hyprwm/Hyprland/releases/latest" | jq -r '.target_commitish')

sed -i "s/hyprland.url.*/hyprland.url = \"github:hyprwm\/Hyprland\/$commit\";/" flake.nix
