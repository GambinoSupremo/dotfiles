-- General config: look & feel, input, animations. Mirrors the non-include
-- portion of mango/config.conf (mango-key equivalents noted inline).

hl.config({
    general = {
        gaps_in          = 5,         -- mango gappih/gappiv = 5
        gaps_out         = 10,        -- mango gappoh/gappov = 10
        border_size      = 2,         -- mango borderpx = 2
        layout           = "dwindle", -- swap to "scrolling" later if you want per-tag layouts
        resize_on_border = false,
        allow_tearing    = false,     -- enable per-game via window_rule if needed
    },

    decoration = {
        rounding           = 6,   -- mango border_radius = 6
        active_opacity     = 1.0, -- mango focused_opacity
        inactive_opacity   = 0.98,
        fullscreen_opacity = 1.0, -- mango unfocused_opacity

        blur               = {
            enabled  = true,
            size     = 5, -- mango blur_params_radius
            passes   = 2, -- mango blur_params_num_passes
            vibrancy = 0.1696,
        },

        shadow             = {
            enabled      = true,
            range        = 10,               -- mango shadows_size
            render_power = 3,
            color        = "rgba(000000ff)", -- overridden in noctalia.lua
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
        focus_on_activate       = false, -- OFF globally (Steam steals focus);
                                         -- per-app exceptions live in rule.lua.
    },

    render = {
        cm_auto_hdr = true,
    },

    -- NVIDIA hardware cursors freeze on screen (worse under HDR/10-bit) —
    -- software cursors fix it, same as WLR_NO_HARDWARE_CURSORS in mango/env.conf.
    cursor = {
        no_hardware_cursors = true,
        -- Software cursors + VRR render no frames on static screens, freezing
        -- the cursor icon; force frames while it moves.
        min_refresh_rate = 60,
    },

    dwindle = {
        preserve_split = true,
    },

    input = {
        kb_layout          = "us", -- mango xkb_rules_layout
        repeat_rate        = 25,   -- mango repeat_rate
        repeat_delay       = 600,  -- mango repeat_delay
        follow_mouse       = 1,
        sensitivity        = 0,
        numlock_by_default = false,       -- mango numlockon = 0
        touchpad           = {
            natural_scroll       = false, -- mango trackpad_natural_scrolling = 0
            tap_to_click         = true,
            drag_lock            = true,
            disable_while_typing = true,
        },
    },
})

-- Animation curves — bezier values lifted from your mango/config.conf
hl.curve("openCurve", { type = "bezier", points = { { 0.46, 1.0 }, { 0.29, 1 } } })
hl.curve("moveCurve", { type = "bezier", points = { { 0.46, 1.0 }, { 0.29, 1 } } })
hl.curve("closeCurve", { type = "bezier", points = { { 0.08, 0.92 }, { 0, 1 } } })
hl.curve("fadeCurve", { type = "bezier", points = { { 0.46, 1.0 }, { 0.29, 1 } } })

-- Hyprland animation speeds are in 100ms units; mango durations were in ms.
-- 400ms open → speed 4.  500ms move → speed 5.  100ms close → speed 1.
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "openCurve", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "closeCurve", style = "popin 80%" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "moveCurve" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "moveCurve" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "fadeCurve" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "openCurve", style = "fade" })
