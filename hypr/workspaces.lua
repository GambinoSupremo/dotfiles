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

-- Games. Scroller again on 0.57 (0.56 dropped the cursor lock, Hyprland#16326).
hl.workspace_rule({
    workspace = "2",
    monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    persistent = true,
    layout = "scrolling",
    layout_opts = { direction = "right" },
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
        layout = i == 2 and "master" or "dwindle",
    })
end

-- Comms on ws 12: Vesktop is the wide master on the left, Signal and Tidal stack on
-- the right. mfact is per workspace only via layout message, so set it when Vesktop opens.
hl.on("window.open", function(w)
    if not (w and w.class == "vesktop" and w.workspace and w.workspace.id == 12) then
        return
    end
    hl.timer(function()
        if w.workspace.tiled_layout ~= "master" then
            return
        end
        local prev = hl.get_active_window()
        hl.dispatch(hl.dsp.focus({ window = w }))
        hl.dispatch(hl.dsp.layout("swapwithmaster ignoremaster"))
        hl.dispatch(hl.dsp.layout("mfact exact 0.6"))
        if prev then
            hl.dispatch(hl.dsp.focus({ window = prev }))
        end
    end, { timeout = 200, type = "oneshot" })
end)

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
