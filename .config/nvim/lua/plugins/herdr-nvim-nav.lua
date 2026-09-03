-- Let Herdr move between Neovim windows before falling through to external panes.
return {
  {
    "aimdevlee/herdr-nvim-nav",
    config = function()
      require("herdr-nvim-nav").setup({
        with_tmux = false,
      })
    end,
  },
}
