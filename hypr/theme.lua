-- Environment
-- If you use uwsm, move hl.env() values into uwsm env files instead.
hl.env("TERMINAL", "ghostty")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Curves approximating your Mango animation profile
hl.curve("mango_fast", {
	type = "bezier",
	points = {
		{ 0.46, 1.00 },
		{ 0.29, 1.00 },
	},
})

hl.curve("mango_close", {
	type = "bezier",
	points = {
		{ 0.08, 0.92 },
		{ 0.00, 1.00 },
	},
})

-- Core visual + behavior settings
hl.config({
	general = {
		border_size = 2,
		gaps_in = 5,
		gaps_out = { top = 10, right = 10, bottom = 10, left = 10 },
		float_gaps = 10,
		gaps_workspaces = 0,
		layout = "dwindle",

		["col.inactive_border"] = {
			colors = { "#8c928cff", "#8c928cff" },
			angle = 0,
		},

		["col.active_border"] = {
			colors = { "#aecfb5ff", "#aecfb5ff" },
			angle = 0,
		},

		allow_tearing = false,
		resize_on_border = false,
	},

	decoration = {
		rounding = 6,
		rounding_power = 2.0,

		-- HDR-safe: keep all Hyprland-managed windows opaque.
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,

		-- Blur can make HDR look like transparency. Keep enabled, but do not
		-- let opacity values influence blur.
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			new_optimizations = true,
			ignore_opacity = true,
		},

		shadow = {
			enabled = true,
			range = 15,
			render_power = 3,
			color = "rgba(000000ff)",
		},
	},

	input = {
		kb_layout = "us",
		repeat_rate = 25,
		repeat_delay = 600,

		follow_mouse = 0,
		focus_on_close = 2,
		mouse_refocus = true,
		float_switch_override_focus = 1,
		special_fallthrough = true,
		natural_scroll = false,

		touchpad = {
			natural_scroll = false,
			tap_to_click = true,
			tap_and_drag = true,
			drag_lock = true,
			disable_while_typing = true,
			middle_button_emulation = false,
		},
	},

	misc = {
		focus_on_activate = false,
		mouse_move_focuses_monitor = false,
		initial_workspace_tracking = 2,
		middle_click_paste = false,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
	},

	cursor = {
		no_warps = false,
		persistent_warps = true,
		warp_on_change_workspace = 1,
		warp_on_toggle_special = 1,
	},

	render = {
		cm_enabled = false,
		cm_auto_hdr = 0,
		use_fp16 = 0,
	},

	quirks = {
		-- Always-on HDR: advertise HDR preference to clients.
		prefer_hdr = 0,
	},

	master = {
		mfact = 0.50,
		new_status = "master",
		new_on_top = false,
		orientation = "left",
		smart_resizing = true,
		drop_at_cursor = true,
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.50,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.40,
		explicit_column_widths = "0.5, 0.7, 1.0",
		wrap_focus = true,
		wrap_swapcol = true,
		direction = "right",
	},

	dwindle = {
		preserve_split = true,
	},

	binds = {
		drag_threshold = 10,
	},
})

-- Workspace and window animation profile tuned toward Mango timing
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "mango_fast", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "mango_fast", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.0, bezier = "mango_close", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.0, bezier = "mango_fast" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.0, bezier = "mango_fast", style = "slide" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3.0, bezier = "mango_fast" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.0, bezier = "mango_close" })
hl.animation({ leaf = "border", enabled = true, speed = 3.0, bezier = "mango_fast" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "mango_fast", style = "slidevert 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.5, bezier = "mango_fast", style = "slidevert 20%" })
