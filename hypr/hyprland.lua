-- Entry point; load order matters. noctalia.lua is runtime-generated — until it
-- exists Hyprland falls back to hyprland.conf (self-heals once Noctalia runs).
-- NixOS appends the scroll-overview block here; hyprland.lua beats hyprland.conf.

require("env")
require("monitor")
require("config")
require("noctalia")
require("workspaces")
require("rule")
require("bind")
require("autostart")
