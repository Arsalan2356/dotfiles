---@module 'hl'

hl.monitor({
    output   = "DP-3",
    mode     = "1920x1080@240.0",
    position = "0x0",
    scale    = 1.0,
})

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@165.0",
    position = "0x0",
    scale    = 1.0,
})

hl.env("XCURSOR_THEME", "VolantesX")

hl.env("XCURSOR_SIZE", 24)

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 3,
        border_size = 1,
        resize_on_border = true,
        allow_tearing = true,
        layout = "hy3",
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
    },
})

hl.config({
    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            xray = true,
            vibrancy = 0.1696,
        },
    },
})


hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier"})
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%"})
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default"})
hl.animation({ leaf = "borderangle", enabled = true, speed = 5, bezier = "default"})
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default"})
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default"})



hl.config({
    dwindle = {
        preserve_split = true,
        smart_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        disable_watchdog_warning = true,
    },
})

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        numlock_by_default = true,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
        accel_profile = "flat",
    },
})

hl.config({
    cursor = {
        no_warps = true,
    },
})

hl.config({
    plugin = {
        hy3 = {
            autotile = {
                enable = true,
                workspaces = "not:8",
            },
            no_gaps_when_only = 0,
            tab_first_window = false,
            tabs = {
                text_center = true,
            },
        }
    }
})

local mainMod = "ALT"

hl.bind("Print", hl.dsp.exec_cmd("grimBlast"))

-- GPU Screen Recorder Shortcut

hl.bind("F10", hl.dsp.exec_raw("killall -SIGUSR1 gpu-screen-recorder"))

hl.bind("F10", hl.dsp.exec_raw("hyprctl notify -1 4000 \"rgb(9889ff)\" \"fontsize:23 Replay Saved\""))

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

hl.bind(mainMod .. " + " .. "Return", hl.dsp.exec_cmd("foot"))

hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "W", hl.dsp.window.close())

hl.bind("SUPER" .. " + " .. "SUPER_L", hl.dsp.exec_cmd("fuzzel"), { repeating = true })

hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd("thunar"))

hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd("fuzzel"))

hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())

hl.bind(mainMod .. " + " .. "F", hl.dsp.exec_cmd("zen"))

hl.bind(mainMod .. " + " .. "G", hl.dsp.exec_cmd("foot --app-id=game-finder --working-directory=/home/rc/gameindex -e ~/gameindex/finder.sh"))

hl.bind(mainMod .. " + " .. "F9", hl.dsp.window.tag({ tag = "immediate"}))

-- Move focus with mainMod + hjkl keys

local hy3 = hl.plugin.hy3

hl.bind(mainMod .. " + " .. "H", hy3.move_focus("l"))

hl.bind(mainMod .. " + " .. "L", hy3.move_focus("r"))

hl.bind(mainMod .. " + " .. "K", hy3.move_focus("u"))

hl.bind(mainMod .. " + " .. "J", hy3.move_focus("d"))

-- Move window with mainMod + SHIFT + arrow/hjkl

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "left", hy3.move_window("l"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "H", hy3.move_window("l"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "right", hy3.move_window("r"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "L", hy3.move_window("r"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "up", hy3.move_window("u"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "K", hy3.move_window("u"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "down", hy3.move_window("d"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "J", hy3.move_window("d"))

hl.bind(mainMod .. " + " .. "I", hy3.change_group("opposite"))

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "KP_1", hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "KP_2", hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "KP_3", hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "KP_4", hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "KP_5", hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "KP_6", hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "KP_7", hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "KP_8", hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "KP_8", hl.dsp.focus({ workspace = 8 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8, follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "right", hl.dsp.window.move({ direction = "right", follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "left", hl.dsp.window.move({ direction = "left", follow = false }))

hl.bind(mainMod .. " + " .. "M", hl.dsp.window.move({ workspace = 8 }, { follow = false }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "M", hl.dsp.window.fullscreen())

-- Scroll through existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + " .. "right", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mainMod .. " + " .. "left", hl.dsp.focus({ workspace = "-1" }))

hl.bind("SUPER" .. " + " .. "V", hl.dsp.exec_cmd("nwg-clipman"))

hl.bind(mainMod .. " + " .. "Space", hl.dsp.exec_cmd("nwg-drawer"))

-- Move/resize windows with mouse buttons and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind("mouse:276", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("mouse:275", hl.dsp.window.resize(), { mouse = true })

--#############################

--## WINDOWS AND WORKSPACES ###

--#############################

hl.window_rule({
    name  = "windowrule-1",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "windowrule-2",
    match = {
        class = "(clipse)",
    },
    float = true,
    size = { 622, 652 },
})

hl.window_rule({
    name  = "windowrule-3",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    opacity = "0.0 override",
    no_anim = true,
    no_initial_focus = true,
    max_size = { 1, 1 },
    no_blur = true,
})

hl.window_rule({
    name  = "windowrule-4",
    match = {
        title = "Picture-in-Picture",
    },
    float = true,
})

-- No borders

hl.window_rule({
    name  = "windowrule-5",
    match = {
        float = true,
    },
    border_size = 0,
})

hl.window_rule({
    name  = "windowrule-6",
    match = {
        class = "game-finder",
    },
    float = true,
    size = { 600, 300 },
    center = true,
    border_size = 0,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("ags-wrapped")
    hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("hyprctl setcursor Volantes 24")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("nwg-drawer -r -fm thunar -ft -term foot -wm hyprland")
    hl.exec_cmd("sleep 3; vesktop --start-minimized")
    hl.exec_cmd("sleep 4; steam -silent -nofriendsui -console")
    hl.exec_cmd("sleep 5; input-remapper-control --command autoload")
    hl.exec_cmd("sleep 5; hyprctl notify -1 3000 rgb(9889ff) fontsize:23 Started Replay Buffer ; gpu-screen-recorder -w screen -f 60 -r 180 -c mp4 -o /mnt/G/Clips")
    hl.exec_cmd("sleep 9; hyprctl dispatch exec audiomonitor")
    hl.exec_cmd("sleep 6; wallpaperengine-gui -m")
end)
