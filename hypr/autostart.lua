-- Autostart — mirrors mango/autostart.conf.
--
-- NOTE: NixOS deploys a patched copy (nixos-config home/dotfiles.nix): the
-- two env-import lines are replaced by a session-bootstrap script, the raw
-- noctalia spawn is dropped (it races noctalia.service there), and
-- signal-desktop gains --password-store. The seds match exact line text
-- below — rewording a matched line fails the NixOS build on purpose.

hl.on("hyprland.start", function()
    -- Import env for portals and user services
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Prefer the Hyprland portal stack; normally systemd/dbus activation should handle it.
    -- Do NOT manually start xdg-desktop-portal-wlr for this profile.

    -- GTK dark mode
    hl.exec_cmd([[gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark']])

    -- Set X11 primary output for older XWayland fullscreen apps / some Steam titles
    hl.exec_cmd([[bash -lc "sleep 2 && xrandr --output DP-2 --primary"]])

    -- Shell / clipboard
    hl.exec_cmd("noctalia")
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Startup apps, placed directly onto desired workspaces
    hl.exec_cmd([[bash -lc "sleep 5 && mullvad-exclude vesktop"]], { workspace = "5" })
    hl.exec_cmd([[bash -lc "sleep 5 && signal-desktop"]], { workspace = "5" })
    --hl.exec_cmd([[bash -lc "sleep 5 && tidal-hifi"]], { workspace = "5" })
end)
