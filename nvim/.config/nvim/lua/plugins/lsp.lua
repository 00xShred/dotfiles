return {
  -- Mason (Package Manager)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- LSPs
        "clangd",
        "pyright",
        "dockerfile-language-server",
        "yaml-language-server",
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
