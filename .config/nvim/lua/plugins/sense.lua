return {
	"boltlessengineer/sense.nvim",
	config = function()
		vim.g.sense_nvim = {
			presets = {
				virtualtext = {
					enabled = true,
					max_width = 0.5,
				},
				statuscolumn = {
					enabled = true,
				},
			},
		}
	end,
}
