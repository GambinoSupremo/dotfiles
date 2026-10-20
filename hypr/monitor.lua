-- Monitors — matched by EDID description so connector renumbering can't unmatch them.
-- Positions are logical/scaled. The Alienware runs HDR all the time (monitor in HDR 400 True Black), so
-- there's no SDR<->HDR mode switch to blank the screen. Stream outputs (SUNSHINE) stay SDR.

local BAR_TOP = 0

hl.monitor({
	output = "desc:Dell Inc. Dell AW3423DW #tBszGDAYBQUH",
	mode = "3440x1440@174",
	position = "0x0",
	scale = 1,

	-- VRR off: on the RX 9070 XT, fullscreen VRR stutters on this G-SYNC-module monitor
	-- (smooth windowed, firmware DMCUB errors on each fullscreen switch). Was 2.
	vrr = 0,

	bitdepth = 10,

	-- Always-on HDR; SDR apps are mapped in with gamma 2.2.
	cm = "hdr",
	sdr_eotf = "gamma22",

	supports_wide_color = 1,
	supports_hdr = 1,

	-- SDR content inside the HDR signal: 2.0 matches the old SDR desktop brightness.
	sdrbrightness = 2.0,
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
