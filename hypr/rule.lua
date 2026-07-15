-- Rule ordering matters in Hyprland.

-- Floating Ghostty helper terminal
hl.window_rule({
    name = "ghostty-floating",
    match = { class = "com.ghostty.floating" },
    float = true,
    size = { 900, 600 },
})

-- Steam and games go to workspace 2 (Alienware).
-- "silent" opens them there WITHOUT switching workspace / stealing focus
-- (if you're already on workspace 2, the new window focuses normally).
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

-- Steam secondary windows (Friends List, Settings, dialogs) float; the main
-- client window tiles. Hyprland's regex engine (RE2) has no lookahead, so
-- "title != Steam" can't be matched directly — instead float everything and
-- un-float the main window below (later rules win).
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

-- Notification-click focus: comms apps may yank focus when they ask for it —
-- that's what makes clicking a notification jump to the app's workspace. The
-- global misc.focus_on_activate stays false so Steam/games can't steal focus
-- on launch. Add a rule here whenever a new app should behave this way.
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

-- Uncomment if the Proton Mail desktop app ever gets installed
-- (pkgs.protonmail-desktop; verify class with: hyprctl clients)
-- hl.window_rule({
--     name = "protonmail-focus-on-activate",
--     match = { class = "proton-mail|Proton Mail" },
--     focus_on_activate = true,
-- })

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

-- Optional layer blur for bars/shells.
-- Run `hyprctl layers` and replace the namespace once you know your Noctalia shell namespace.
-- Example:
-- hl.layer_rule({
--   match = { namespace = "waybar" },
--   blur = true,
--   blur_popups = true,
-- })
