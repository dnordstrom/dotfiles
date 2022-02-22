local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin",

	font = wezterm.font("PragmataPro Mono Liga", {
		weight = "Regular",
		stretch = "Normal",
		italic = false,
	}),

	font_size = 10.5,
  line_height = 1.35,

	hide_tab_bar_if_only_one_tab = true,

  window_background_opacity = 0.98,

  window_padding = {
    left = "18px",
    right = "18px",
    top = "12px",
    bottom = "12px"
  },

	colors = {
		indexed = { [16] = "#F8BD96", [17] = "#F5E0DC" },

		scrollbar_thumb = "#575268",
		split = "#161320",

		tab_bar = {
			background = "#1E1E2E",

			active_tab = {
				bg_color = "#575268",
				fg_color = "#F5C2E7",
			},

			inactive_tab = {
				bg_color = "#1E1E2E",
				fg_color = "#D9E0EE",
			},

			inactive_tab_hover = {
				bg_color = "#575268",
				fg_color = "#D9E0EE",
			},

			new_tab = {
				bg_color = "#15121C",
				fg_color = "#6E6C7C",
			},

			new_tab_hover = {
				bg_color = "#575268",
				fg_color = "#D9E0EE",
				italic = true,
			},
		},

		visual_bell = "#302D41",

		-- nightbuild only
		-- compose_currsor = "#F8BD96",
		-- },
	},
}
