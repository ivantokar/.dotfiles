-- Autocmds are automatically loaded on the VeryLazy event.
-- Add personal autocmds here when you need them.

-- Neovim does not detect the .mdx extension by default. Give MDX its own
-- filetype so its parser and formatter can be selected consistently.
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
