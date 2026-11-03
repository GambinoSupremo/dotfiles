-- Match monitors by EDID; positions are logical pixels after scaling.
-- The desktop stays SDR; Hyprland switches the Alienware to HDR for fullscreen HDR content.

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

	-- Keep desktop colors in sRGB; HDR capability enables fullscreen auto-HDR.
	cm = "srgb",

	supports_wide_color = 1,
	supports_hdr = 1,
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
