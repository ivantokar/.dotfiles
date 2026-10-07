-- Inline image rendering via the kitty graphics protocol (works through tmux passthrough).
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		image = {
			enabled = true,
			doc = { enabled = true, inline = true, float = true },
		},
	},
}
