-- Keybinds — mirrors niri/binds.kdl. NixOS deploys this file unchanged.

local mod = "SUPER"

-- System
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("hyprshutdown"), { description = "Quit Hyprland" })
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), { description = "Power menu" })

-- Terminal
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"), { description = "Terminal" })
hl.bind(mod .. " + CTRL + Return",
    hl.dsp.exec_cmd("ghostty --gtk-single-instance=false --class=com.ghostty.floating", {
        float = true,
        size = { 900, 600 },
    }),
    { description = "Floating terminal" }
)

-- Launcher, system menu (nixos-config home/menu.nix), keybind list
hl.bind(mod .. " + space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { description = "App launcher" })
hl.bind(mod .. " + SHIFT + space", hl.dsp.exec_cmd("sysmenu"), { description = "System menu" })
hl.bind(mod .. " + ALT + space", hl.dsp.exec_cmd("sysmenu"), { description = "System menu (alt)" })
hl.bind(mod .. " + SHIFT + slash", hl.dsp.exec_cmd("keybinds"), { description = "Keybindings" })
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd("theme"), { description = "Theme picker" })
hl.bind(mod .. " + CTRL + T", hl.dsp.exec_cmd("theme next"), { description = "Next theme" })
hl.bind(mod .. " + D", hl.dsp.exec_cmd("voxtype record toggle"), { description = "Dictation (start/stop)" })

-- App spawns
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("zen-beta"), { description = "Browser" })
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("nautilus"), { description = "Files" })
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("mullvad-exclude vesktop"), { description = "Discord" })
-- No signal-desktop spawn bind — it double-bound SUPER+SHIFT+S with the
-- screenshot; Signal autostarts, respawn via launcher.
hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "Obsidian" })
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("sone"), { description = "Music" })
hl.bind(mod .. " + SHIFT + ALT + B", hl.dsp.exec_cmd("zen-beta --private-window"), { description = "Private browser window" })
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("zeditor"), { description = "Zed" })

-- Noctalia
hl.bind(mod .. " + backslash", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center audio"), { description = "Audio panel" })
hl.bind(mod .. " + ALT + E", hl.dsp.exec_cmd("noctalia msg panel-open launcher /emo"), { description = "Emoji picker" })
hl.bind(mod .. " + ALT + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"), { description = "Wallpaper picker" })
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), { description = "Clipboard history" })
hl.bind(mod .. " + ALT + R", hl.dsp.exec_cmd("systemctl --user restart noctalia.service"), { description = "Restart Noctalia" })

-- Screenshots
hl.bind("ALT + SHIFT + S", hl.dsp.exec_cmd([[bash -lc 'grim -g "$(slurp)" - | wl-copy']]), { description = "Screenshot region to clipboard" })
-- Noctalia region capture (freezes screen) → Satty annotate; Enter copies, Ctrl+S saves.
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Screenshot region + annotate" })
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Screenshot region + annotate" })

-- Window focus (arrows + vim)
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left (or arrows)" })
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Carry (Super+Shift+dir). Dwindle: swap with the window there; if none, re-stack
-- with the neighbour (J = go under it, L = go beside it); past the edge, next monitor.
local function carry(dir)
    local w, ws = hl.get_active_window(), hl.get_active_workspace()
    if w and not w.floating and ws and ws.tiled_layout == "dwindle" then
        local ax, ay, aw, ah = w.at.x, w.at.y, w.size.x, w.size.y
        local function has(d)
            for _, o in ipairs(hl.get_windows({ workspace = tostring(ws.id) })) do
                if o.address ~= w.address and not o.floating and not o.hidden then
                    local ox, oy, ow, oh = o.at.x, o.at.y, o.size.x, o.size.y
                    local xo = ox < ax + aw - 5 and ax < ox + ow - 5
                    local yo = oy < ay + ah - 5 and ay < oy + oh - 5
                    if (d == "l" and yo and ox + ow <= ax + 5) or (d == "r" and yo and ox >= ax + aw - 5)
                        or (d == "u" and xo and oy + oh <= ay + 5) or (d == "d" and xo and oy >= ay + ah - 5) then
                        return true
                    end
                end
            end
            return false
        end
        if not has(dir) then
            local a, b = "u", "d"
            if dir == "u" or dir == "d" then a, b = "l", "r" end
            if has(a) or has(b) then
                local wasFirst = not has(a)
                hl.dispatch(hl.dsp.layout("togglesplit"))
                if wasFirst ~= (dir == "u" or dir == "l") then
                    hl.dispatch(hl.dsp.layout("swapsplit"))
                end
                return
            end
        end
    end
    hl.dispatch(hl.dsp.window.move({ direction = dir }))
end

local dirs = {
    { "H", "Left", "l", "left" }, { "J", "Down", "d", "down" },
    { "K", "Up", "u", "up" }, { "L", "Right", "r", "right" },
}
for _, d in ipairs(dirs) do
    hl.bind(mod .. " + SHIFT + " .. d[2], function() carry(d[3]) end)
    hl.bind(mod .. " + SHIFT + " .. d[1], function() carry(d[3]) end,
        { description = "Carry window " .. d[4] .. " (J under, K over; or arrows)" })
end

-- Flip the focused split between side-by-side and stacked (dwindle); Super+Shift+J/K does it too
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"), { description = "Flip split direction" })

-- Monitor focus
hl.bind(mod .. " + CTRL + Left", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + Right", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + CTRL + H", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor (or arrows)" })
hl.bind(mod .. " + CTRL + L", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })

-- Hyprland only: Mango and Niri don't have this one (nixos-config home/philips-input.nix).
hl.bind(mod .. " + ALT + I", hl.dsp.exec_cmd("philips-input"), { description = "Switch Philips input (Linux/work Mac)" })

-- Workspace navigation on current monitor
hl.bind(mod .. " + CTRL + Up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + CTRL + Down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ workspace = "m-1" }), { description = "Previous workspace (or arrows)" })
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ workspace = "m+1" }), { description = "Next workspace" })

-- Carry window to the other monitor (H/L) or workspace (K/J); you go with it
hl.bind(mod .. " + CTRL + SHIFT + Left", hl.dsp.window.move({ monitor = "l", follow = true }))
hl.bind(mod .. " + CTRL + SHIFT + Right", hl.dsp.window.move({ monitor = "r", follow = true }))
hl.bind(mod .. " + CTRL + SHIFT + H", hl.dsp.window.move({ monitor = "l", follow = true }), { description = "Carry window to left monitor (or arrows)" })
hl.bind(mod .. " + CTRL + SHIFT + L", hl.dsp.window.move({ monitor = "r", follow = true }), { description = "Carry window to right monitor" })
hl.bind(mod .. " + CTRL + SHIFT + Up", hl.dsp.window.move({ workspace = "m-1", follow = true }))
hl.bind(mod .. " + CTRL + SHIFT + Down", hl.dsp.window.move({ workspace = "m+1", follow = true }))
hl.bind(mod .. " + CTRL + SHIFT + K", hl.dsp.window.move({ workspace = "m-1", follow = true }), { description = "Carry window to previous workspace (or arrows)" })
hl.bind(mod .. " + CTRL + SHIFT + J", hl.dsp.window.move({ workspace = "m+1", follow = true }), { description = "Carry window to next workspace" })

-- Window states
hl.bind(mod .. " + W", hl.dsp.window.float(), { description = "Toggle floating" })
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize" })
hl.bind(mod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudotile" })
hl.bind(mod .. " + SHIFT + G", hl.dsp.window.pin(), { description = "Pin window on all workspaces" }) -- closest stock equivalent to Mango's global-ish visibility

-- Alt-tab style window cycling
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Resize (repeats while held; the Lily58 Lower layer sends these)
hl.bind(mod .. " + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true, description = "Wider" })
hl.bind(mod .. " + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true, description = "Narrower" })
hl.bind(mod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true, description = "Taller" })
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true, description = "Shorter" })

-- Resize mode (easy on the Lily58): SUPER+R, then H/L narrower/wider, K/J shorter/taller
-- (hold to repeat, arrows too). Esc or Enter exits.
hl.bind(mod .. " + R", hl.dsp.submap("resize"), { description = "Resize mode (HJKL, Esc exits)" })
hl.define_submap("resize", function()
    local steps = {
        { "H", "Left", -50, 0 }, { "L", "Right", 50, 0 },
        { "K", "Up", 0, -50 }, { "J", "Down", 0, 50 },
    }
    for _, s in ipairs(steps) do
        for _, key in ipairs({ s[1], s[2] }) do
            hl.bind(key, hl.dsp.window.resize({ x = s[3], y = s[4], relative = true }), { repeating = true })
        end
    end
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- SUPER+Z/X/C/V (with any extra modifiers) never reach Hyprland: keyd turns them
-- into undo/cut/copy/paste (Ctrl+Z, Shift+Delete, Ctrl+Insert, Shift+Insert).

-- Scratchpad
hl.bind("ALT + Z", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Scratchpad" })
hl.bind("ALT + SHIFT + Z", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), { description = "Send window to scratchpad" })

-- Hyprland only: Mango and Niri don't hide Battle.net.
hl.bind(mod .. " + ALT + B", hl.dsp.workspace.toggle_special("battlenet"), { description = "Show/hide Battle.net" })

-- Workspace numbers act on the focused monitor, like niri: the Alienware has 1-6,
-- the Philips 11-16 (named 1-6, see workspaces.lua).
local function onMonitor(i)
    local m = hl.get_active_monitor()
    local philips = m and m.description and m.description:find("PHL 278E1", 1, true)
    return tostring((philips and 10 or 0) + i)
end

for i = 1, 6 do
    hl.bind(mod .. " + " .. tostring(i), function()
        hl.dispatch(hl.dsp.focus({ workspace = onMonitor(i) }))
    end, { description = "Workspace " .. i })
    hl.bind(mod .. " + SHIFT + " .. tostring(i), function()
        hl.dispatch(hl.dsp.window.move({ workspace = onMonitor(i), follow = true }))
    end, { description = "Carry window to workspace " .. i })
end

-- Layouts (layouts.lua): pick tile / scroller / dwindle like Mango. No cycle key:
-- it was too easy to hit by accident.
local layouts = require("layouts")
hl.bind(mod .. " + CTRL + A", function() layouts.set("tile") end, { description = "Tile layout" })
hl.bind(mod .. " + CTRL + S", function() layouts.set("scroller") end, { description = "Scroller layout" })
hl.bind(mod .. " + CTRL + D", function() layouts.set("dwindle") end, { description = "Dwindle layout" })

-- Mouse wheel workspace cycling (matches Hyprland's own default example:
-- mouse_down -> next, mouse_up -> previous; this repo previously had it swapped)
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))

-- Mouse move / resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl prev"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Numpad 3 (QK75 knob press, remapped by keyd) toggles Discord mute, even in games.
-- code:89 matches with NumLock on or off. Hyprland only: niri/Mango can't send keys to a window.
hl.bind("code:89", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "m", window = "class:vesktop" }))

-- Numpad 0 (Caps Lock, remapped by keyd) is in-game push-to-talk. While it's held, mute Discord's copy
-- of the mic (nixos-config home/vesktop-mic.nix) so friends don't hear you twice. The game still gets the key.
hl.bind("code:90", hl.dsp.exec_cmd("vesktop-mic mute"), { non_consuming = true })
hl.bind("code:90", hl.dsp.exec_cmd("vesktop-mic unmute"), { non_consuming = true, release = true })

