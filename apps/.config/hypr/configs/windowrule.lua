hl.window_rule({ match = { title = "(fcitx)" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true })
hl.window_rule({ match = { class = "^(soffice)$" }, float = true })
hl.window_rule({ match = { class = "^(thunar)$" }, float = true })
hl.window_rule({ match = { class = "(thunar)" }, size = { 1000, 875 } })
hl.window_rule({ match = { class = "(vivaldi-stable)", title = "(Open Files)" }, float = true })

hl.layer_rule({ match = { namespace = "rofi" }, blur = true })

-- hl.window_rule({ match = { class = "(chrome)" }, float = true })
-- hl.window_rule({ match = { class = "(chromium)" }, float = true })
-- hl.layer_rule({ match = { namespace = "waybar" }, blur = true }) -- Add blur to waybar
-- hl.layer_rule({ match = { namespace = "waybar" }, blur_popups = true }) -- Blur waybar popups too!
-- hl.layer_rule({ match = { namespace = "waybar" }, ignore_alpha = 0.2 }) -- Make it so transparent parts are ignored
