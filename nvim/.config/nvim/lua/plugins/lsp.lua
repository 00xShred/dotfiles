return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
    },
  },

  -- Mason (Package Manager)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- LSPs
        "astro-language-server",
        "clangd",
        "pyright",
        "dockerfile-language-server",
        "yaml-language-server",
        "rust-analyzer",

        -- Formatters
        "prettier",
        "stylua",
        "clang-format",
        "black",
        "shfmt",

        -- Linters
        "shellcheck",
        "eslint_d",
        "markdownlint",
        "hadolint",
        "codelldb",
      })
    end,
  },
}
