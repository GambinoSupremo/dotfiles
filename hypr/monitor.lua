-- Monitors — matched by EDID description so connector renumbering can't unmatch them.
-- Positions are logical/scaled. The Alienware is in its own Creator mode (sRGB, gamma 2.2), so Hyprland
-- sends plain sRGB. HDR is deliberately off (supports_hdr = 0, cm_auto_hdr = false) until desktop HDR
-- works with Moonlight/Sunshine streaming. If screen sharing breaks, try bitdepth 8 or keep_unmodified_copy.

local BAR_TOP = 0

hl.monitor({
	output = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
	mode = "3440x1440@174",
	position = "0x0",
	scale = 1,

	-- 2 = fullscreen-only VRR: games keep it, desktop stays locked —
	-- fluctuating refresh gamma-flickers this QD-OLED on dark backgrounds.
	vrr = 2,

	bitdepth = 10,

	-- SDR desktop: always-HDR greyed out Wayland-native games (PROTON_ENABLE_WAYLAND).
	-- Plain sRGB: the monitor's Creator/sRGB mode does the gamut clamp; dcip3 here would convert twice.
	cm = "srgb",
	sdr_eotf = "gamma22",

	supports_wide_color = 1,
	supports_hdr = 0,

	-- Only apply in HDR mode (SDR content inside an HDR signal); inert while HDR is off.
	sdrbrightness = 1.4,
	sdrsaturation = 1.0,
	-- 0.2 default lifts OLED blacks to grey in SDR games/apps.
	sdr_min_luminance = 0,
})

hl.monitor({
	output = "desc:Philips Consumer Electronics Company PHL 278E1 0x0000065F",
	mode = "3840x2160@60",
	position = "3440x0",
	scale = 1.5,
	vrr = 0,

	bitdepth = 8,
	cm = "srgb",

	supports_wide_color = 0,
	supports_hdr = 0,

	sdrbrightness = 1.00,
	sdrsaturation = 1.00,

	reserved_area = { top = BAR_TOP, right = 0, bottom = 0, left = 0 },
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-right",
	scale = 1,
})
