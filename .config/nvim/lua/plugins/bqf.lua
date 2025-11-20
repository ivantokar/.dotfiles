return {
	"kevinhwang91/nvim-bqf",
	ft = "qf", -- Load only for quickfix filetype
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		auto_enable = true,
		auto_resize_height = true, -- Automatically resize quickfix window height

		preview = {
			auto_preview = true, -- Automatically show preview when navigating
			win_height = 12,
			win_vheight = 12,
			delay_syntax = 80,
			border = "rounded",
			show_title = true,
			should_preview_cb = function(bufnr, qwinid)
				local ret = true
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(bufname)
				-- Skip preview for files larger than 100KB
				if fsize > 100 * 1024 then
					ret = false
				-- Skip preview for certain filetypes
				elseif bufname:match("^fugitive://") then
					ret = false
				end
				return ret
			end,
		},
		func_map = {
			-- Navigation
			vsplit = "",
			ptogglemode = "z,",
			stoggleup = "",
			-- Preview controls
			pscrollorig = "<C-b>",
			pscrollup = "<C-u>",
			pscrolldown = "<C-d>",
			-- Filter
			filter = "zn",
			filterr = "zN",
			-- Toggle modes
			tab = "st",
			tabb = "sT",
			tabc = "<C-t>",
			drop = "o",
			-- History navigation
			prevfile = "<C-p>",
			nextfile = "<C-n>",
			-- Misc
			prevhist = "<",
			nexthist = ">",
		},
		filter = {
			fzf = {
				action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
				extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
			},
		},
	},
}
