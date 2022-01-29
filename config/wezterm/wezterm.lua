local wezterm = require("wezterm")

return {
	color_scheme = "/etc/nixos/config/wezterm/colors/catppuccin.itermcolors",
	font = wezterm.font("PragmataPro Mono Liga", { weight = "Regular", stretch = "Normal", italic = false }),
	hide_tab_bar_if_only_one_tab = true,
}
