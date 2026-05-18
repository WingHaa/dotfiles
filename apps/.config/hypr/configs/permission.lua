hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal*", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wf-recorder", type = "screencopy", mode = "allow" })
hl.permission({ binary = "*", type = "screencopy", mode = "ask" })

hl.permission({ binary = "/usr/bin/hyprctl", type = "plugin", mode = "deny" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
hl.permission({ binary = "*", type = "plugin", mode = "ask" })
