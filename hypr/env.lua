-- Environment variables
-- Mirrors mango/env.conf
--
-- NOTE: If you run Hyprland under uwsm, the upstream Arch wiki recommends
-- ~/.config/uwsm/env-hyprland instead of setting these here. Keeping them
-- inline for parity with Mango (which uses env= in env.conf).

hl.env("TERMINAL", "ghostty")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24") -- Hypr-specific; XCURSOR_SIZE alone is not enough
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
