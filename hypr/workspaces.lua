-- Workspace-to-monitor pinning + per-workspace layouts.
-- NOTE: NixOS patches the /usr/bin/ghostty path below (home/dotfiles.nix).
-- Monitor names here are DP-2/DP-1 only; if NVIDIA probe order flips them
-- to DP-4/DP-3 these rules silently stop matching (same caveat as
-- mango/tag.conf).

-- DP-2 / Alienware

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-2",
    default = true,
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "2",
    monitor = "DP-2",
    persistent = true,
    layout = "scrolling",
    layout_opts = { direction = "right" },
})

hl.workspace_rule({
    workspace = "3",
    monitor = "DP-2",
    persistent = true,
    layout = "scrolling",
    layout_opts = { direction = "right" },
})

-- DP-1 / Philips

hl.workspace_rule({
    workspace = "4",
    monitor = "DP-1",
    default = true,
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "5",
    monitor = "DP-1",
    persistent = true,
    layout = "dwindle",
})

hl.workspace_rule({
    workspace = "6",
    monitor = "DP-1",
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
