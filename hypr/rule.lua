-- Rule ordering matters in Hyprland.

-- Floating Ghostty helper terminal
hl.window_rule({
    name = "ghostty-floating",
    match = { class = "com.ghostty.floating" },
    float = true,
    size = { 900, 600 },
})

-- Steam + games → workspace 2 (Alienware); "silent" = no workspace switch or focus steal.
hl.window_rule({
    name = "steam-main",
    match = { class = "steam" },
    workspace = "2 silent",
    scrolling_width = 1.0,
})

hl.window_rule({
    name = "steam-games",
    match = { class = "steam_app_.*" },
    workspace = "2 silent",
    scrolling_width = 1.0,
})

-- Secondary Steam windows float, main window tiles. RE2 has no lookahead, so
-- float everything and un-float the main window below (later rules win).
hl.window_rule({
    name = "steam-secondary-float",
    match = { class = "steam" },
    float = true,
})

hl.window_rule({
    name = "steam-main-tile",
    match = { class = "steam", title = "Steam" },
    tile = true,
})

-- Comms / media on secondary monitor workspaces
-- Verify final classes with: hyprctl clients -j | jq '.[].class'
hl.window_rule({
    name = "vesktop-secondary",
    match = { class = "vesktop" },
    workspace = "5 silent",
})

-- Comms apps may yank focus on request (notification clicks jump to them);
-- global focus_on_activate stays false so Steam can't. Add new apps here.
hl.window_rule({
    name = "vesktop-focus-on-activate",
    match = { class = "vesktop" },
    focus_on_activate = true,
})

hl.window_rule({
    name = "signal-focus-on-activate",
    match = { class = "signal|Signal" },
    focus_on_activate = true,
})

hl.window_rule({
    name = "signal-secondary",
    match = { class = "signal|Signal" },
    workspace = "5 silent",
})

hl.window_rule({
    name = "tidal-secondary",
    match = { class = "tidal-hifi|TIDAL HiFi" },
    workspace = "5 silent",
})

-- Optional layer blur for bars/shells: hl.layer_rule({ match = { namespace = ... }, blur = true })
-- (find the namespace with `hyprctl layers`).
