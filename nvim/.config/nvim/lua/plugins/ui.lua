return {
  -- Theme
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {
      use_palette = "pywal",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "neopywal-dark",
    },
  },

  -- Dashboard (Disabled)
  { "folke/alpha-nvim", enabled = false },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },
}
