vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>")

-- Closed nvim-tree when last buffer is closed

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd "quit"
        end
    end
})

return {
    "nvim-tree/nvim-tree.lua",

    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- optionally enable 24-bit colour
        vim.opt.termguicolors = true

        -- OR setup with some options
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                side = "left",
                width = 40,
                float = {
                    enable = false,
                    open_win_config = {
                        width = 40,
                        height = 40,
                    },
                },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })
    end,
}
