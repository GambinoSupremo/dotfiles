-- Rule ordering matters in Hyprland.

-- Floating Ghostty helper terminal
hl.window_rule({
    name = "ghostty-floating",
    match = { class = "com.ghostty.floating" },
    float = true,
    size = { 900, 600 },
})

-- Satty screenshot editor (Super+Shift+S) floats centered
hl.window_rule({
    name = "satty-floating",
    match = { class = "^com\\.gabm\\.satty$" },
    float = true,
    center = true,
    size = "monitor_w*0.7 monitor_h*0.7",
})

-- Steam + games → workspace 2 (Alienware); "silent" = no workspace switch or focus steal.
-- no_follow_mouse: hovering them doesn't grab focus (and scroll the view back); click instead.
-- Anchored (^...$) to match niri/windowrules.kdl — unanchored "steam" also
-- substring-matches "steam_app_NNNNNN", which was letting steam-secondary-float
-- below force-float actual game windows.
hl.window_rule({
    name = "steam-main",
    match = { class = "^steam$" },
    workspace = "2 silent",
    no_follow_mouse = true,
    scrolling_width = 1.0,
})

-- Proton with PROTON_ENABLE_WAYLAND=1 names the window after the exe instead
-- (Deadlock is deadlock.exe), so match both. Games open fullscreen; Super+F
-- drops one to a full-width column you can scroll past, and back.
hl.window_rule({
    name = "steam-games",
    match = { class = "^(steam_app_.*|.*\\.exe)$" },
    workspace = "2 silent",
    no_follow_mouse = true,
    tile = true, -- Wayland games can ask to float
    fullscreen = true,
    scrolling_width = 1.0,
})

-- Pre-launch "Launcher" windows (updaters, EAC/BattlEye prompts, etc.) share
-- the steam_app_ class with the actual game, so the rule above was tiling
-- them too. Float them back to their own requested size (later rules win).
-- Confirmed via Marvel Rivals (class steam_app_2767030): title starts as
-- "broken" (Proton placeholder) then flips to "Launcher".
hl.window_rule({
    name = "steam-games-launcher-float",
    match = { class = "^(steam_app_.*|.*\\.exe)$", title = "^(Launcher|broken)$" },
    float = true,
    fullscreen = false,
})

-- Secondary Steam windows float, main window tiles. RE2 has no lookahead, so
-- float everything and un-float the main window below (later rules win).
hl.window_rule({
    name = "steam-secondary-float",
    match = { class = "^steam$" },
    float = true,
})

hl.window_rule({
    name = "steam-main-tile",
    match = { class = "^steam$", title = "Steam" },
    tile = true,
})

-- Comms / media on the Philips (workspace 12 = its "2")
-- Verify final classes with: hyprctl clients -j | jq '.[].class'
hl.window_rule({
    name = "vesktop-secondary",
    match = { class = "vesktop" },
    workspace = "12 silent",
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
    workspace = "12 silent",
})

hl.window_rule({
    name = "tidal-secondary",
    match = { class = "tidal-hifi|TIDAL HiFi" },
    workspace = "12 silent",
})

-- Per-app opacity (focused / unfocused), same values as niri/windowrules.kdl.
hl.window_rule({
    name = "app-opacity",
    match = { class = "^(signal|vesktop|tidal-hifi|cider|obsidian)$" },
    opacity = "0.95 0.90",
})

-- Zen fully opaque (overrides global inactive_opacity): translucent video looks wrong on the HDR monitor.
hl.window_rule({
    name = "zen-opaque",
    match = { class = "^zen-beta$" },
    opacity = "1.0 override 1.0 override",
})

-- xdph screen-share picker: tiling + popin resized it under the cursor, eating the first clicks.
hl.window_rule({
    name = "share-picker-float",
    match = { class = "^hyprland-share-picker$" },
    float = true,
    center = true,
    pin = true,
    no_anim = true,
})

-- Optional layer blur for bars/shells: hl.layer_rule({ match = { namespace = ... }, blur = true })
-- (find the namespace with `hyprctl layers`).
