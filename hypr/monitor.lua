-- Monitor config
-- IMPORTANT:
-- 1) Position uses logical/scaled coordinates.
-- 2) DP-2 is the HDR-capable Alienware.
-- 3) Always-on HDR means SDR desktop content is tone-mapped into HDR.
-- 4) If screen sharing breaks, test bitdepth = 8 or keep_unmodified_copy = 1/2.

local BAR_TOP = 0

hl.monitor({
	output = "DP-2",
	mode = "3440x1440@174",
	position = "0x0",
	scale = 1,

	-- 2 = fullscreen only: games keep VRR, but the desktop stays locked at
	-- 175 Hz — fluctuating refresh on this QD-OLED causes visible gamma
	-- flicker on dark backgrounds.
	vrr = 2,

	bitdepth = 10,

	cm = "hdr",

	supports_wide_color = 1,
	supports_hdr = 1,

	-- SDR content inside the HDR signal: brightness boost so the desktop
	-- doesn't look dim next to HDR highlights.
	sdrbrightness = 1.4,
	sdrsaturation = 1.0,
})

hl.monitor({
	output = "DP-1",
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
