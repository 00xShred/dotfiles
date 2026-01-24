return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(".git", "*.iml", "mvnw", "gradlew", "pom.xml", "build.gradle")(
              fname
            ) or vim.fn.getcwd()
          end,
        },
      },
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
        "jdtls",
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
