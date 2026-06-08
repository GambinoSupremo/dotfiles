-- Hyprland entry point
-- Mirrors mango/config.conf's `source =` structure.
-- Load order matters: env → monitor → config → theme → rule → bind → autostart.
-- See ~/.config/mango/config.conf and ~/.config/niri/config.kdl for sibling configs.
-- hyprland.lua — very top of file

require("env")
require("monitor")
require("config")
require("noctalia")
require("workspaces")
require("rule")
require("bind")
require("autostart")
