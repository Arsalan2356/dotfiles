#!/usr/bin/env bash

branch=$(curl --silent "https://api.github.com/repos/hyprwm/Hyprland/releases/latest" | jq -r '.target_commitish')

sed -i "s/hyprland.url.*/hyprland.url = \"github:hyprwm\/Hyprland\/$branch\";/" flake.nix

commit=$(curl --silent "https://api.github.com/repos/outfoxxed/hy3/tags?per_page=1" | jq -r '.[0].commit.sha')

sed -i "/hy3/{n;s/url.*/url = \"github:outfoxxed\/hy3\/$commit\";/}" flake.nix
