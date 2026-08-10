-- Environment variables — mirrors mango/env.conf (kept inline for parity;
-- under uwsm these would live in ~/.config/uwsm/env-hyprland).

hl.env("TERMINAL", "ghostty")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24") -- Hypr-specific; XCURSOR_SIZE alone is not enough
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
