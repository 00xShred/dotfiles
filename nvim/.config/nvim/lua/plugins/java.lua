return {
  { import = "lazyvim.plugins.extras.lang.java" },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.java = {}
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.format = opts.settings.java.format or {}

      opts.settings.java.format.enabled = true
      opts.settings.java.format.settings = {
        url = nil,
        profile = nil,
      }
    end,
  },
}
