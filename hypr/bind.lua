-- Keybinds — mirrors mango/bind.conf and niri/binds.kdl.
--
-- NOTE: NixOS deploys a patched copy (nixos-config home/dotfiles.nix):
-- v4-era Noctalia IPC calls, zen-browser, and the signal-desktop spawn are
-- rewritten by seds that match the exact line text below. Rewording a
-- matched line fails the NixOS build on purpose. Edit both places together.

local mod = "SUPER"

-- System
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

-- Terminal
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + CTRL + Return",
    hl.dsp.exec_cmd("ghostty --gtk-single-instance=false --class=com.ghostty.floating", {
        float = true,
        size = { 900, 600 },
    })
)

-- Launcher
hl.bind(mod .. " + space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

-- App spawns
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("mullvad-exclude vesktop"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("signal-desktop"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("tidal-hifi"))
hl.bind(mod .. " + SHIFT + ALT + B", hl.dsp.exec_cmd("zen-browser --private-window"))
hl.bind(mod .. " + SHIFT + Z", hl.dsp.exec_cmd("zeditor"))

-- Noctalia
hl.bind(mod .. " + backslash", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center audio"))
hl.bind(mod .. " + ALT + E", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher emoji"))
hl.bind(mod .. " + ALT + W", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call wallpaper toggle"))
hl.bind(mod .. " + ALT + R", hl.dsp.exec_cmd([[bash -lc "pkill -f 'qs.*noctalia' && sleep 1 && qs -c noctalia-shell"]]))

-- Screenshots
hl.bind("ALT + SHIFT + S", hl.dsp.exec_cmd([[bash -lc 'grim -g "$(slurp)" - | wl-copy']]))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd([[bash -lc 'grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%s).png']]))

-- Window focus (arrows + vim)
hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Window movement — window.move re-inserts into the layout (movewindow),
-- so pushing the right window Down stacks it under the left one. window.swap
-- only exchanges two existing windows and can't restructure the tree.
hl.bind(mod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Flip the focused split between side-by-side and stacked (dwindle)
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"))

-- Monitor focus
hl.bind(mod .. " + CTRL + Left", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + Right", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + L", hl.dsp.focus({ monitor = "r" }))

-- Workspace navigation on current monitor
hl.bind(mod .. " + CTRL + Up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + CTRL + Down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ workspace = "m+1" }))

-- Move window to adjacent monitor
hl.bind(mod .. " + CTRL + ALT + Left", hl.dsp.window.move({ monitor = "l", follow = true }))
hl.bind(mod .. " + CTRL + ALT + Right", hl.dsp.window.move({ monitor = "r", follow = true }))
hl.bind(mod .. " + CTRL + ALT + H", hl.dsp.window.move({ monitor = "l", follow = true }))
hl.bind(mod .. " + CTRL + ALT + L", hl.dsp.window.move({ monitor = "r", follow = true }))

-- Move window to adjacent workspace on current monitor
hl.bind(mod .. " + CTRL + ALT + Up", hl.dsp.window.move({ workspace = "m-1", follow = false }))
hl.bind(mod .. " + CTRL + ALT + Down", hl.dsp.window.move({ workspace = "m+1", follow = false }))
hl.bind(mod .. " + CTRL + ALT + K", hl.dsp.window.move({ workspace = "m-1", follow = false }))
hl.bind(mod .. " + CTRL + ALT + J", hl.dsp.window.move({ workspace = "m+1", follow = false }))

-- Window states
hl.bind(mod .. " + W", hl.dsp.window.float())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + SHIFT + G", hl.dsp.window.pin()) -- closest stock equivalent to Mango's global-ish visibility

-- Alt-tab style window cycling
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Resize
hl.bind(mod .. " + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mod .. " + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))

-- Clipboard — Omarchy-style universal copy/paste: SUPER+C/X/V everywhere.
-- CTRL+Insert (copy) and SHIFT+Insert (paste) are honored by terminals AND
-- regular apps alike, so no window-class detection is needed. SUPER+CTRL+V
-- opens the noctalia clipboard-history panel.
hl.bind(mod .. " + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }))
hl.bind(mod .. " + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }))
hl.bind(mod .. " + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }))
hl.bind(mod .. " + CTRL + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

-- Scratchpad
hl.bind("ALT + Z", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("ALT + SHIFT + Z", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Workspace numbers
for i = 1, 6 do
    hl.bind(mod .. " + " .. tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mod .. " + CTRL + " .. tostring(i), hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

-- Mouse wheel workspace cycling
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "m-1" }))

-- Mouse move / resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl prev"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Optional Mango-like layout controls you can enable later:
-- On scrolling workspaces:
-- hl.bind(mod .. " + R", hl.dsp.layout("colresize +conf"))
-- hl.bind("ALT + E", hl.dsp.layout("colresize 1.0"))
-- hl.bind(mod .. " + comma", hl.dsp.layout("swapcol l"))
-- hl.bind(mod .. " + period", hl.dsp.layout("move +col"))

-- On master workspaces:
-- hl.bind(mod .. " + CTRL + A", hl.dsp.layout("orientationleft"))
-- hl.bind(mod .. " + CTRL + D", hl.dsp.layout("orientationcenter"))
-- hl.bind(mod .. " + CTRL + T", hl.dsp.layout("orientationright"))
-- hl.bind(mod .. " + CTRL + M", hl.dsp.layout("mfact exact 0.50"))
