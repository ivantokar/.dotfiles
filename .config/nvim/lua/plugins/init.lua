local xmap_reload = vim.fs.joinpath(vim.env.HOME, "Work", "xmap.nvim", "reload.lua")

if vim.uv.fs_stat(xmap_reload) then
	vim.keymap.set("n", "<leader>R", function()
		vim.cmd("luafile " .. vim.fn.fnameescape(xmap_reload))
	end, { desc = "Reload xmap.nvim" })
end

return {
	{
		"nvim-lua/plenary.nvim",
		name = "plenary",
	},

	"nvim-tree/nvim-web-devicons",
}
