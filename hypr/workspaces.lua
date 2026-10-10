-- Workspace pinning + default layouts (layouts.lua switches them at runtime).
-- Monitors matched by EDID description (same strings as monitor.lua).

-- Alienware

hl.workspace_rule({
    workspace = "1",
    monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    default = true,
    persistent = true,
    layout = "dwindle",
})

-- Games. No scrolling on this monitor: in 0.56 a hidden scrolling workspace
-- drops a fullscreen game's pointer lock (hyprwm/Hyprland#16326).
hl.workspace_rule({
    workspace = "2",
    monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "3",
    monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    persistent = true,
    layout = "dwindle",
})

-- Philips: workspaces 11-16, named 1-6 for the bar (bind.lua's Mod+N is per monitor).

for i = 1, 6 do
    hl.workspace_rule({
        workspace = tostring(10 + i),
        monitor = "desc:Philips Consumer Electronics Company PHL 278E1 0x0000065F",
        default_name = tostring(i),
        default = i == 1 or nil,
        persistent = i <= 3 or nil,
        layout = "dwindle",
    })
end

-- Alienware 4-6 exist on demand only.
for i = 4, 6 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    })
end

-- Scratchpad / special workspace
hl.workspace_rule({
    workspace = "special:scratchpad",
    persistent = true,
    animation = "slidevert",
    on_created_empty = "ghostty --gtk-single-instance=false --class=com.ghostty.floating",
})
