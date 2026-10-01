-- Workspace pinning + layouts. NixOS patches the /usr/bin/ghostty path below.
-- Monitors matched by EDID description (same strings as monitor.lua).

-- Alienware

hl.workspace_rule({
    workspace = "1",
    monitor = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
    default = true,
    persistent = true,
    layout = "dwindle",
})

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
    layout = "scrolling",
    layout_opts = { direction = "right" },
})

-- Philips

hl.workspace_rule({
    workspace = "4",
    monitor = "desc:Philips Consumer Electronics Company PHL 278E1 0x0000065F",
    default = true,
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "5",
    monitor = "desc:Philips Consumer Electronics Company PHL 278E1 0x0000065F",
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "6",
    monitor = "desc:Philips Consumer Electronics Company PHL 278E1 0x0000065F",
    persistent = true,
    layout = "dwindle",
})

-- Scratchpad / special workspace
hl.workspace_rule({
    workspace = "special:scratchpad",
    persistent = true,
    animation = "slidevert",
    on_created_empty = "/usr/bin/ghostty --gtk-single-instance=false --class=com.ghostty.floating",
})
