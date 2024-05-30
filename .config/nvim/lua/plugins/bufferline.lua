return {
	"akinsho/bufferline.nvim",

	version = "v1.*",
	dependencies = "nvim-tree/nvim-web-devicons",

	config = function()
		require("bufferline").setup({
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					-- local icon = level:match("error") and " " or " "
					local icon = level:match("error") and "E:" or "W:"
					return " " .. icon .. count
				end,
				left_trunc_marker = "",
				right_trunc_marker = "",
				separator_style = "none",
				show_buffer_close_icons = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		})
	end,
}
