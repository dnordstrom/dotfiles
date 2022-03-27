----
-- LIGHTSPEED.NVIM
----

require("lightspeed").setup({
	ignore_case = true,
	exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

	--- s/x ---
	jump_to_unique_chars = { safety_timeout = 400 },
	match_only_the_start_of_same_char_seqs = true,
	force_beacons_into_match_width = false,

	-- Display characters in a custom way in the highlighted matches.
	substitute_chars = { ["\r"] = "¬" },

	-- These keys are captured directly by the plugin at runtime.
	special_keys = {
		next_match_group = "<Space>",
		prev_match_group = "<Tab>",
	},

	--- f/t ---
	limit_ft_matches = 4,
	repeat_ft_with_target_char = false,
})
