return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "assets",
        relative_to_current_file = true,
        use_absolute_path = false,
      },
      filetypes = {
        markdown = {
          template = "![$CURSOR]($FILE_PATH)",
        },
      },
    },
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image" },
    },
  },
  {
    "3rd/image.nvim",
    ft = { "markdown" },
    opts = {
      backend = (vim.env.KITTY_PID or vim.env.TERM == "xterm-kitty") and "kitty" or "sixel",
      integrations = {
        markdown = {
          enabled = true,
        },
      },
    },
  },
}
