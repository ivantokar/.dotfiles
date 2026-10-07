-- Trouble: Diagnostics and lists
return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        use_diagnostic_signs = true,

        icons = {
            indent = {
                middle = " ",
                last = " ",
                top = " ",
                ws = "│  ",
            },
        },

        modes = {
            diagnostics = {
                groups = {
                    { "filename", format = "{file_icon} {basename:Title} {count}" },
                },
            },

            preview_float = {
                mode = "diagnostics",
                preview = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "Preview",
                    title_pos = "center",
                    position = { 0, -2 },
                    size = { width = 0.3, height = 0.3 },
                    zindex = 200,
                },
            },
        },
    },
    config = function(_, opts)
        require("trouble").setup(opts)
    end,
    keys = {
        { "<leader>tt", "<cmd>Trouble<cr>",                       desc = "Toggle Trouble" },
        { "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
        { "<leader>td", "<cmd>Trouble document_diagnostics<cr>",  desc = "Document Diagnostics" },
        { "<leader>tl", "<cmd>Trouble loclist<cr>",               desc = "Location List" },
        { "<leader>tq", "<cmd>Trouble quickfix<cr>",              desc = "Quickfix List" },
        { "gR",         "<cmd>Trouble lsp_references<cr>",        desc = "LSP References" },
    },
}
