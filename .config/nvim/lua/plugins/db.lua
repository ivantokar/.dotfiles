return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	config = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_winwidth = 80
		vim.g.dbs = {
			Dev = "postgresql://postgres:vapor_password@0.0.0.0:5432/postgres",
			-- Production = "postgresql://postgres:vapor_password@0.0.0.0:5432/postgres",
		}

		vim.keymap.set("n", "<leader>db", ":DBUIToggle<cr>", {})
	end,
}
