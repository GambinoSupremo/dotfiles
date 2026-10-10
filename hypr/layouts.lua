-- Mango-style layouts per workspace. Super+N / Super+Shift+N cycle, Super+Ctrl+A/S/D jump.
-- Choices are saved to ~/.local/state/hypr/layouts.lua so config reloads (Noctalia's
-- wallpaper theme) keep them. Grid and deck are Lua layouts; the rest are built in.

local M = {}

local GAP = 5 -- matches general.gaps_in

local function inset(b)
    return { x = b.x + GAP / 2, y = b.y + GAP / 2, w = b.w - GAP, h = b.h - GAP }
end

-- Grid: near-square, the last row stretches to fill the width.
hl.layout.register("grid", {
    recalculate = function(ctx)
        local n = #ctx.targets
        local cols = math.ceil(math.sqrt(n))
        local rows = math.ceil(n / cols)
        local a = ctx.area
        for i, t in ipairs(ctx.targets) do
            local row = (i - 1) // cols
            local inRow = (row == rows - 1) and (n - row * cols) or cols
            local col = (i - 1) % cols
            t:place(inset({
                x = a.x + a.w * col / inRow,
                y = a.y + a.h * row / rows,
                w = a.w / inRow,
                h = a.h / rows,
            }))
        end
    end,
})

-- Deck: master on the left, every other window stacked full-size on the right.
hl.layout.register("deck", {
    recalculate = function(ctx)
        local a = ctx.area
        if #ctx.targets == 1 then
            ctx.targets[1]:place(inset(a))
            return
        end
        local master = ctx:split(a, "left", 0.55)
        local stack = ctx:split(a, "right", 0.45)
        for i, t in ipairs(ctx.targets) do
            t:place(inset(i == 1 and master or stack))
        end
    end,
})

-- msg = master orientation, sent after the layout switch (and again on revisit).
local LAYOUTS = {
    { key = "tile", label = "Tile", layout = "master", msg = "orientationleft" },
    { key = "center", label = "Center tile", layout = "master", msg = "orientationcenter" },
    { key = "vtile", label = "Vertical tile", layout = "master", msg = "orientationtop" },
    { key = "scroller", label = "Scroller", layout = "scrolling", opts = { direction = "right" } },
    { key = "vscroller", label = "Vertical scroller", layout = "scrolling", opts = { direction = "down" } },
    { key = "dwindle", label = "Dwindle", layout = "dwindle" },
    { key = "monocle", label = "Monocle", layout = "monocle" },
    { key = "grid", label = "Grid", layout = "lua:grid" },
    { key = "deck", label = "Deck", layout = "lua:deck" },
}
local BY_KEY = {}
for i, l in ipairs(LAYOUTS) do
    l.index = i
    BY_KEY[l.key] = l
end

local stateDir = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/hypr"
local stateFile = stateDir .. "/layouts.lua"

local function loadState()
    local ok, t = pcall(dofile, stateFile)
    return (ok and type(t) == "table") and t or {}
end

local state = loadState()

local function saveState()
    os.execute("mkdir -p '" .. stateDir .. "'")
    local f = io.open(stateFile, "w")
    if not f then
        return
    end
    f:write("return {\n")
    for ws, key in pairs(state) do
        f:write(string.format("    [%q] = %q,\n", ws, key))
    end
    f:write("}\n")
    f:close()
end

local function rule(ws, l)
    hl.workspace_rule({ workspace = ws, layout = l.layout, layout_opts = l.opts or {} })
end

-- Saved layouts become workspace rules at load; they merge into workspaces.lua's.
for ws, key in pairs(state) do
    if BY_KEY[key] then
        rule(ws, BY_KEY[key])
    end
end

-- Orientation lives in the master layout's runtime state, so re-send it on revisit.
hl.on("workspace.active", function(w)
    local l = w and BY_KEY[state[tostring(w.id)] or ""]
    if l and l.msg then
        hl.dispatch(hl.dsp.layout(l.msg))
    end
end)

function M.set(key)
    local w = hl.get_active_workspace()
    local l = BY_KEY[key]
    if not w or w.special or not l then
        return
    end
    local ws = tostring(w.id)
    rule(ws, l)
    -- Re-setting general.layout is what makes Hyprland re-match workspace layouts.
    hl.config({ general = { layout = "dwindle" } })
    hl.timer(function()
        if l.msg then
            hl.dispatch(hl.dsp.layout(l.msg))
        end
    end, { timeout = 50, type = "oneshot" })
    state[ws] = key
    saveState()
    hl.notification.create({ text = "Layout: " .. l.label, duration = 1200, icon = "info" })
end

function M.cycle(step)
    local w = hl.get_active_workspace()
    if not w then
        return
    end
    local cur = BY_KEY[state[tostring(w.id)] or ""]
    local i = cur and cur.index or 0
    M.set(LAYOUTS[(i - 1 + step) % #LAYOUTS + 1].key)
end

return M
