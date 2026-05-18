local mod = "SUPER"
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Apps
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("uwsm-app -- kitty.desktop"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("uwsm-app -- thunar.desktop"))
hl.bind(
    mod .. " + D",
    hl.dsp.exec_cmd('pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -run-command "uwsm app -- {cmd}"')
)
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(scriptsDir .. "/refresh.sh"))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp -d)\" -t ppm - | satty -f - --fullscreen -o ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png --copy-command wl-copy"
    )
)
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd(scriptsDir .. "/blur.sh"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("~/.config/waybar/scripts/theme-switcher.sh"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/screenlock.sh"))
hl.bind(mod .. " + ALT + V", hl.dsp.exec_cmd(scriptsDir .. "/clipboard.sh"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())

-- Basic
hl.bind(mod .. " + Q", hl.dsp.window.kill())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:'| xargs kill"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pseudo())

-- Move focus with mod + vim keys
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

-- Resize with mod + SHIFT + vim keys
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

hl.bind(mod .. " + ALT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + ALT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + ALT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + ALT + L", hl.dsp.window.move({ direction = "r" }))

-- Switch workspaces with mod + [0-9]
for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mod + ALT + [0-9]
for i = 1, 9 do
    hl.bind(mod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

-- Move active window silently to a workspace with mod + SHIFT + [0-9]
for i = 1, 9 do
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))

-- Example special workspace (scratchpad)
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true }
)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Zoom
hl.bind(
    "CTRL + " .. mod .. " + mouse_down",
    hl.dsp.exec_cmd(
        "hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.1}\")"
    )
)
hl.bind(
    "CTRL + " .. mod .. " + mouse_up",
    hl.dsp.exec_cmd(
        "hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.1}\")"
    )
)

-- hl.bind(mod .. " + W", hl.dsp.exec_cmd(scriptsDir .. "/wallpaper.sh"))
