hl.config({
    cursor = {
        no_hardware_cursors = false,
        -- no_hardware_cursors = true, -- for nvidia graphic
        enable_hyprcursor = true,
        warp_on_change_workspace = true,
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = 1.0,
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 0,
        col = {
            active_border = { colors = { "rgba(7aa2f7ee)", "rgba(7dcfffee)" }, angle = 45 },
        },
        layout = "dwindle",
        allow_tearing = false,
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
        },
        shadow = {
            color = "rgba(1a1a1aee)",
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = false,
        force_default_wallpaper = 0,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        mouse_move_enables_dpms = true,
    },
    render = {
        direct_scanout = 0,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })
