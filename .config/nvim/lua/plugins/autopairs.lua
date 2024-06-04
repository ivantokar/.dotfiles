return {
    {

	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {}, -- this is equalent to setup({}) function

    },
    {
	"windwp/nvim-ts-autotag",

	opts = {
		event = "BufWritePre",
		enable = true,
	},

	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				-- Defaults
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Auto close on trailing </
			},
		})
	end,
}}
