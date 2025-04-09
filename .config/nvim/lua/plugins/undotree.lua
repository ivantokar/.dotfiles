return {
    -- Undotree for undo history

    "mbbill/undotree",

    config = function()
        vim.g.undotree_WindowLayout = 1
        vim.g.undotree_SplitWidth = 40
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_HighlightChangedWithSign = 1
    end,
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle),
}
