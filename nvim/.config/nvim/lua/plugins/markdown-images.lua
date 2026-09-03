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
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
        },
      },
    },
  },
}
