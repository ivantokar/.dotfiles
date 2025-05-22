return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "-", "<cmd>split | Oil<CR>", desc = "Oil (normal)" },
		-- { "<leader>fo", "<cmd>OilFloat<CR>", desc = "Oil (floating)" },
	},
	config = function(_, opts)
		require("oil").setup(opts)

		-- vim.api.nvim_create_user_command("OilFloat", function()
		-- 	local width = math.floor(vim.o.columns * 0.8)
		-- 	local height = math.floor(vim.o.lines * 0.8)
		-- 	local row = math.floor((vim.o.lines - height) / 2)
		-- 	local col = math.floor((vim.o.columns - width) / 2)
		--
		-- 	-- Create a scratch buffer
		-- 	local bufnr = vim.api.nvim_create_buf(false, true)
		--
		-- 	-- Create the floating window
		-- 	vim.api.nvim_open_win(bufnr, true, {
		-- 		relative = "editor",
		-- 		width = width,
		-- 		height = height,
		-- 		row = row,
		-- 		col = col,
		-- 		style = "minimal",
		-- 		border = "rounded",
		-- 	})
		--
		-- 	-- Set filetype to oil and load it manually
		-- 	vim.bo[bufnr].filetype = "oil"
		--
		-- 	-- Tell Oil to open in that buffer
		-- 	require("oil").open(nil, { bufnr = bufnr })
		--
		-- 	-- Optional: allow closing with `q`
		-- 	vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = bufnr, silent = true })
		-- end, {})
	end,

	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	-- vim.keymap.set("n", "<leader>fo", "<cmd>OilFloat<CR>", { desc = "Open Oil in float" }),
}
