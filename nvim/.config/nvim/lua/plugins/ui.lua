return {
  -- Theme
  { "catppuccin/nvim", enabled = false },
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

  -- Smooth scroll tuning (faster animation, snappy response)
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        animate = {
          duration = { step = 4, total = 80 },
          easing = "outQuad",
        },
        animate_repeat = {
          delay = 50,
          duration = { step = 3, total = 30 },
          easing = "linear",
        },
      },
    },
  },
}
