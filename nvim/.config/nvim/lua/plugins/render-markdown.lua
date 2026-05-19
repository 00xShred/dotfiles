return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    pipe_table = {
      style = "normal",
      cell = "trimmed",
      padding = 0,
    },
  },
  ft = { "markdown" },
}
