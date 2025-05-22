return {

	{
		-- Commenting

		"numToStr/Comment.nvim",

		opts = {
			-- add any options here
		},

		lazy = false,

		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		-- Commenting for JSX, TSX, etc.

		"JoosepAlviste/nvim-ts-context-commentstring",

		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},

	-- todo: add todo comments:wa

	-- {
	--
	--     -- Commenting TODOs and FIXMEs in code
	--
	--     "folke/todo-comments.nvim",
	--     cmd = { "TodoTrouble", "TodoTelescope" },
	--     opts = {},
	--     -- stylua: ignore
	--     keys = {
	--         { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
	--         { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
	--         { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
	--         { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
	--     }
	--     ,
	-- },
}
