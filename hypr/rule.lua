-- Rule ordering matters in Hyprland.

-- Floating Ghostty helper terminal
hl.window_rule({
    name = "ghostty-floating",
    match = { class = "com.ghostty.floating" },
    float = true,
    size = { 900, 600 },
})

-- Steam and games go to workspace 2 (Alienware)
hl.window_rule({
    name = "steam-main",
    match = { class = "steam" },
    workspace = "2",
    scrolling_width = 1.0,
})

hl.window_rule({
    name = "steam-games",
    match = { class = "steam_app_.*" },
    workspace = "2",
    scrolling_width = 1.0,
})

-- Steam dialogs / secondary windows float
hl.window_rule({
    name = "steam-secondary-float",
    match = { class = "steam", title = "^(?!Steam$).*" },
    float = true,
})

-- Comms / media on secondary monitor workspaces
-- Verify final classes with: hyprctl clients -j | jq '.[].class'
hl.window_rule({
    name = "vesktop-secondary",
    match = { class = "vesktop" },
    workspace = "5",
})

hl.window_rule({
    name = "signal-secondary",
    match = { class = "signal|Signal" },
    workspace = "5",
})

hl.window_rule({
    name = "tidal-secondary",
    match = { class = "tidal-hifi|TIDAL HiFi" },
    workspace = "5",
})

-- Optional layer blur for bars/shells.
-- Run `hyprctl layers` and replace the namespace once you know your Noctalia shell namespace.
-- Example:
-- hl.layer_rule({
--   match = { namespace = "waybar" },
--   blur = true,
--   blur_popups = true,
-- })
